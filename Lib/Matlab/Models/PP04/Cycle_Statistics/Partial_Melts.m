% Partial_Melts attempts to find all the partial melts in a PP04 model run
% Author: Brian Knight
% Created: 07/09/18
% Last Edit: 07/18/18

addMatlabpath
PP04_Params_Model_Run

n0=[0,0,0.8];
[tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0);

tstart = 0;
tfinal = 5000;

% Need to generalize script to work for any end_time
end_time = 5000; % 800; 2600; 5000;
Hout = (Hout > 0); % Gets rid of any uncertanties 

% Collect times when melt begins (Deglaciation triggers)
trig_warm = [];

for i = tstart+1:end_time
 
    if Hout(i+1)<Hout(i)
        if isempty(trig_warm) || trig_warm(end)~= i-1
            trig_warm=[trig_warm,i];
        end
    end 
     
end

trig_cool = [];

for i = tstart+1:end_time
 
    if Hout(i+1)>Hout(i)
        if isempty(trig_cool) || trig_cool(end)~= i-1
            trig_cool=[trig_cool,i];
        end
    end
     
end

% Array with length of full cycles
full_cycles = trig_warm(2:end) - trig_warm(1:end-1);

% Find probably cycles with partial melts

ppmelts = [];
min_max = [];

for i = 1:length(full_cycles)
   
   if trig_warm(1)>trig_cool(1)
        V = Vout(fliplr(trig_warm(i):trig_cool(i+1)));
    else
        V = Vout(fliplr(trig_warm(i):trig_cool(i)));
    end % if
    
    V = (V(1:end-2) + V(2:end-1) + V(3:end))/3; % Smoothing
     
    for n = 2:length(V) - 1
        if V(n-1) < V(n) &  V(n) > V(n+1)
            for j = n+2: length(V) - 1
                if V(j-1) > V(j) & V(j) < V(j+1)
                    min_max = [min_max, i];
                    break
                end % if
            end % for
        end % if
    end % for                        
end % for

ppmelts = union(min_max, min_max);
num_partials = length(min_max);

% Find how many partial melts per cycle
melts_per_cycle = [];
for i = 1:length(full_cycles)
    melts_per_cycle = [melts_per_cycle, sum(min_max == i)];
end % for


% Calculate points of minimum distance from trigger line for each cycle in ppmelts

min_dist = [];

if insol ~=0
    [~,SouthF]=read_PP04_Insolation('60S_21st_Feb.txt',tstart, tfinal); % Read in I60 forcing
    SouthF=(SouthF-mean(SouthF))/std(SouthF); % Normalize
else
    SouthF = zeros(tfinal + 1, 1);
end % if
    
for i = ppmelts                                 %!!!! left off here
    cycl_dist = [];
    if trig_warm(1)>trig_cool(1)
        ln = length(trig_warm(i):trig_cool(i+1));
    else
        ln = length(trig_warm(i):trig_cool(i));
    end
    
    for n = 2:ln-1 % Losing end points
        
        % the y-intercept of the line perpendicular to the triggerand through the point in question
        intercept = Vout(trig_cool(i+1)-n)+a/b*Aout(trig_cool(i+1)-n); 

        % coordinates where the line intersects the trigger
        xcrss_pt = a/b*(-a/b*Aout(trig_cool(i+1)-n) + intercept + d/a - k*trig_warm(i)/a - ...
                                                                        c*SouthF(trig_warm(i)));
        ycrss_pt = (b*xcrss_pt - d + k*trig_warm(i))/a;
        
        % The point where the line from pt to trigger (perp) hits the trigger
        pt1 = [xcrss_pt, ycrss_pt]; 

        % Where the point in question lies        
        pt2 = [Aout(trig_cool(i+1)-n), Vout(trig_cool(i+1)-n)]; 

        cycl_dist = [cycl_dist, norm(pt1-pt2)]; % length of line from point to trigger

    end
    
    for j = 4:length(cycl_dist) - 4 % Losing more endpoints
        if (cycl_dist(j-1) > cycl_dist(j)) & (cycl_dist(j) < cycl_dist(j+1))
            min_dist = [min_dist, [i;j]];
        end
    end

end


%============Scratch Work============%
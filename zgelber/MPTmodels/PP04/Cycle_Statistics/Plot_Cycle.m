function Plot_Cycle(n)
% This function will plot the full cycles corresponding to the cycle number n
% Plots cycle on V vs Ac phase plane
% Author: Brian Knight
% Created: 07/09/18
% Last Edit: 07/18/18

addMatlabpath
PP04_Params_Model_Run

n0=[0,0,0.8];
[tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0);

tstart = 0;
tfinal = 5000;

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

% Displays length of full cycle, warming time and cooling time.

if trig_warm(1) > trig_cool(1)
    periods = [trig_warm(n+1) - trig_warm(n), trig_warm(n+1) - trig_cool(n+1), trig_cool(n+1) - trig_warm(n)];
else
    periods = [trig_warm(n+1) - trig_warm(n), trig_warm(n+1) - trig_cool(n), trig_cool(n) - trig_warm(n)];
end

disp(sprintf('Full Period = %d,  Warming Time = %d, Cooling Time = %d', periods(1), periods(2), periods(3)))


% Begin Plot Routine


%Ac = Aout(fliplr(trig_warm(n):trig_warm(n+1)));
%Vc = Vout(fliplr(trig_warm(n):trig_warm(n+1)));

if trig_warm(1) > trig_cool(1)
    Ac_cool = Aout(fliplr(trig_warm(n):trig_cool(n+1)));
    Ac_warm = Aout(fliplr(trig_cool(n+1):trig_warm(n+1)));
    Vc_cool = Vout(fliplr(trig_warm(n):trig_cool(n+1)));
    Vc_warm = Vout(fliplr(trig_cool(n+1):trig_warm(n+1)));
else
    Ac_cool = Aout(fliplr(trig_warm(n):trig_cool(n)));
    Ac_warm = Aout(fliplr(trig_cool(n):trig_warm(n+1)));
    Vc_cool = Vout(fliplr(trig_warm(n):trig_cool(n)));
    Vc_warm = Vout(fliplr(trig_cool(n):trig_warm(n+1)));   
end % if

% Plots a single cycle (beginning of melt to end of cool)

hold on
hold all
%plot(AcSmooth, VcSmooth, 'k')
plot(Ac_warm, Vc_warm, 'r', 'LineWidth', 2)
plot(Ac_cool, Vc_cool, 'b', 'LineWidth', 2)
%scatter(Ac, Vc, 'k')
set(gca, 'YDir', 'reverse')
% Plot trigger line analytically from Model Structure (Switch at F = 0)
if insol == 0 % Unforced w/ Drift
    if trig_warm(1) > trig_cool(1)
        plot([0:0.1:0.9], (b*[0:0.1:0.9]-d+k*trig_warm(n))/a, '--k')
    else
        plot([0:0.1:0.9], (b*[0:0.1:0.9]-d+k*trig_warm(n+1))/a, '--k')
    end % if
else
    [~,SouthF]=read_PP04_Insolation('60S_21st_Feb.txt',tstart, tfinal); % Read in I60 forcing
    SouthF=(SouthF-mean(SouthF))/std(SouthF); % Normalize
    if trig_warm(1) > trig_cool(1)
        plot([0:0.1:0.9], (b*[0:0.1:0.9]-d+k*trig_warm(n)+c*SouthF(trig_warm(n)))/a, '--k') % Forced w/ Drift
    else
        plot([0:0.1:0.9], (b*[0:0.1:0.9]-d+k*trig_warm(n+1)+c*SouthF(trig_warm(n+1)))/a, '--k') % Forced w/ Drift
    end % if
end % if


xlim([0,0.9])
ylim([0,0.9])
xlabel('Antarctic Ice Volume')
ylabel('Global Ice Volume')
title(['Plot of Cycle ', num2str(n)])
%legend(sprintf('Warming Phase: %d kyrs', periods(2)),sprintf('Cooling Phase: %d kyrs', periods(3)), 'Trigger Line',...
%                                                                                                        'Location','southwest')

hold off



%============Scratch Work============%


% Alternate Title

%if insol == 0
%    title(['Unforced Cycle', num2str(n)])
%else
%    title(['Forced Cycle', num2str(n)])
%end % if
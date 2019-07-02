% This script collects sample statistics of cycles
% Needs the following scripts to run:
%   sm90_find_cycles.m
%   sm90_partialmelts.m

% General Flags and runID
runID = 41;

ReadMeFlag = 0; 
%Distr_Fig = 0;
%FigSave = 0;

% Identifies data of model runs by the forcing used
descr = 'unforced';

fileName = sprintf('SM90_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';

%%Find max/min ice and min/nmax ice, cool/warm and cool/nwarm trigger correlations

% Reading in data and putting it into an array
[data,te,ye] = readSM90Data(fileName,filePath,4);

% Separating the variables
t = data(:,1);
I = data(:,2);  %./1.3;
Mu = data(:,3);  %./26.3;
Theta = data(:,4);  %./0.7;

if ye(1,2) < ye(2,2)
   tmin = te(7:2:end);
   tmax = te(8:2:end);
   ye_min = ye(7:2:end,:);
   ye_max = ye(8:2:end,:);
else
   tmin = te(8:2:end);
   tmax = te(9:2:end);
   ye_min = ye(8:2:end,:);
   ye_max = ye(9:2:end,:);
end %if

%tmin_co2 = fullMat(:,1);
%tmax_co2 = fullMat(:,2);

maxI_k = [];
minI_k = [];
%next_maxI_k = iceMat(:,3);


% Finding lengths of full cycles, and warm/cool phases, adn partial melts
full_times = [];
warm_times = [];
cool_times = [];
%idMax_parI = [];
%idMin_parI = [];
%num_pmelts = 0;
%melts_per_cycle = [];
%pmelt_times = [];
for i=1:length(tmin)-1
   %full = t(tmin_co2(i+1)) - t(tmin_co2(i));
   %warm = t(tmax_co2(i)) - t(tmin_co2(i));
   %cool = t(tmin_co2(i+1)) - t(tmax_co2(i));
   
   full = tmin(i+1) - tmin(i);
   warm = tmax(i) - tmin(i);
   cool = tmin(i+1) - tmax(i);
   
   val1 = round(tmin(i),1);
   val2 = round(tmin(i+1),1);
   t1 = find(abs(t-val1) < 0.001);
   t2 = find(abs(t-val2) < 0.001);
   %t1 = find(t == round(tmin(i),1));
   %t2 = find(t == round(tmin(i+1),1));
   int = I(t1:t2);
      
   % Constructing vecotrs of lengths of full cycles, warming and cooling phases
   full_times = [full_times 10*full];
   warm_times = [warm_times 10*warm];
   cool_times = [cool_times 10*cool];
   
   % vectors of the max/min ice mass
   mx = find(int == max(int));
   mn = find(int == min(int));
   maxI_k= [maxI_k; mx+t1];  % The absolute max ice in cycle
   minI_k = [minI_k; mn+t1];  % The absolute min ice in cycle
   %next_maxI_k = I(next_maxI_k);  % The max ice during cooling phase
   
end %for


% costructing vector of proportion of ice melted in each cycle
%dI = next_maxI_k(1:end-1) - minI_k(2:end);  % difference of ice from max ice in previous cycle to min ice melted in next cycle
%dI = maxI_k - minI_k;
%prop_melt = [];
%for j=1:length(dI)
%   %prop = dI(j)/next_maxI_k(j);
%   prop = dI(j)/maxI_k(j);
%   prop_melt = [prop_melt prop];
%end %for


% Full Cycle Statistics
avg_cycle = mean(full_times);

max_cycle = max(full_times);

min_cycle = min(full_times);


% Cooling Model Statistics (Glaciation)
avg_cool_time = mean(cool_times);

max_cool_time = max(cool_times);

min_cool_time = min(cool_times);


% Warming Model Statistics (Deglacition)
avg_warm_time = mean(warm_times);

max_warm_time = max(warm_times);

min_warm_time = min(warm_times);


% Length of averge glaciation relative to average deglaciation

asymmetry_of_avg = avg_cool_time/avg_warm_time;
asymm_vec = cool_times(1:length(warm_times))./warm_times;
avg_of_asymmetry = sum(asymm_vec)/length(asymm_vec);


% Finds correlations between variables of interest
[r1,p1] = corrcoef(I(maxI_k),I(minI_k));  %max ice to min ice in a cycle

%[r2,p2] = corrcoef(maxI_k,dI);  %max ice to size of next melt
%[r2,p2] = corrcoef(next_maxI_k(1:end-1),dI);

%[r3,p3] = corrcoef(maxI_k,prop_melt);  %max ice to relative size of next melt
%[r3,p3] = corrcoef(next_maxI_k(1:end-1),prop_melt);

%[r4,p4] = corrcoef(maxI_k,full_times);  %max ice to length of next cycle
%[r4,p4] = corrcoef(next_maxI_k(1:end-1),full_times(2:end));

%[r5,p5] = corrcoef(minI_k(2:end),dI);  %min ice to size of previous melt
%[r5,p5] = corrcoef(minI_k,dI);

%[r6,p6] = corrcoef(minI_k(2:end),prop_melt);  %min ice to relative size of prev. melt
%[r6,p6] = corrcoef(minI_k,prop_melt);

%[r7,p7] = corrcoef(melts_per_cycle,full_times);  %number partials to length of cycle

%[r8,p8] = corrcoef(warm_times,I(tmin_co2(1:end-1))-I(tmax_co2(1:end-1)));  %length of warming with change of ice in warming

%[r9,p9] = corrcoef(cool_times(1:end-1),dI);  %cooling time to size of next melt
%[r9,p9] = corrcoef(cool_times(1:end-1),dI(2:end));

[r10,p10] = corrcoef(I(minI_k(1:end-1)),I(maxI_k(2:end)));  %min ice to next max ice
%[r10,p10] = corrcoef(minI_k,next_maxI_k);

%[r11,p11] = corrcoef(next_maxI_k(1:end-1),next_maxI_k(2:end));  %max ice to next max ice
%[r11,p11] = corrcoef(maxI_k(1:end-1),maxI_k(2:end));

%[r12,p12] = corrcoef(minI_k,next_maxI_k-minI_k);  %min ice to size of growth

%[r13,p13] = corrcoef(minI_k,(next_maxI_k-minI_k)./next_maxI_k);  %min ice to relative size of growth

%[r14,p14] = corrcoef(next_maxI_k-minI_k,melts_per_cycle);  %size of melt to number of partials per cycle
%[r14,p14] = corrcoef(dI,melts_per_cycle);

%[r15,p15] = corrcoef(melts_per_cycle(1:end-1),dI);  %partial melts per cycle to size of next melt
%[r15,p15] = corrcoef(melts_per_cycle(1:end-1),dI(2:end));

[r16,p16] = corrcoef(ye_min(1:end-1,1),ye_max(:,1));  %Ice at melt to Ice at cool

[r17,p17] = corrcoef(ye_max(:,1),ye_min(2:end,1));  %Ice at cooling to Ice at next melt


if ReadMeFlag == 1    

    % Construct filepath/filename to save stats
    filename = sprintf('SM90_%s_%d_Cycles.txt', descr, runID);
    filepath = '~/campgrp/rjballes/ModelRuns/sm90/Statistics/';
    fname = strcat(filepath, filename);
    fid = fopen(fname, 'w');
    fprintf(fid,'SM90_%s_%d_Cycles.txt\n', descr, runID);
    fprintf(fid, '\n\nLate Cycle Statistics (%g kyr run, p = %g, u = %g, Forcing = %s)\n', 10*t(end),p,u, descr);
    fprintf(fid, 'Total # of Cycles: %g', length(full_times));

    % Full Cycle Stats
    fprintf(fid, '\n\nFull Cycle Statistics:\n');
    fprintf(fid, '\tMean Cycle Length = %g\n', avg_cycle);
    fprintf(fid, '\tMax Cycle Length = %g\n', max_cycle);
    fprintf(fid, '\tMin Cycle Length = %g\n', min_cycle);

    %Cooling Model Stats
    fprintf(fid, '\n\nCooling Statistics:\n');
    fprintf(fid, '\tMean Cooling Time = %g\n', avg_cool_time);
    fprintf(fid, '\tMax Cooling Time = %g\n', max_cool_time);
    fprintf(fid, '\tMin Cooling Time = %g\n', min_cool_time);

    %Warming Model Stats
    fprintf(fid, '\n\nWarming Statistics:\n');
    fprintf(fid, '\tMean Warming Time = %g\n', avg_warm_time);
    fprintf(fid, '\tMax Warming Time = %g\n', max_warm_time);
    fprintf(fid, '\tMin Warming Time = %g\n', min_warm_time);

    %Asymmetry Stats
    fprintf(fid, '\nAsymmetry Statistics:\n');
    fprintf(fid, '\tAsymmetry of the Averages = %g\n', asymmetry_of_avg);
    fprintf(fid, '\tAverage of the Asymmetries = %g\n', avg_of_asymmetry);
    
    %Correlations
    fprintf(fid, '\nCorrelation Statistics:\n');
    fprintf(fid, '\tMaximum Ice Volume to Minimum Ice Volume: corr =  %g, p = %g\n\n', r1(1,2), p1(1,2));
    %fprintf(fid, '\tMaximum Ice Volume to Size of Next Melt: corr =  %g, p = %g\n\n', r2(1,2), p2(1,2));
    %fprintf(fid, '\tMaximum Ice Volume to Relative Size of Next Melt: corr =  %g, p = %g\n\n', r3(1,2), p3(1,2));
    %fprintf(fid, '\tMaximum Ice Volume to Length of Next Cycle: corr =  %g, p = %g\n\n', r4(1,2), p4(1,2));
    %fprintf(fid, '\tMinimum Ice Volume to Size of Preceding Melt: corr =  %g, p = %g\n\n', r5(1,2), p5(1,2));
    %fprintf(fid, '\tMinimum Ice Volume to Relative Size of Preceeding Melt: corr =  %g, p = %g\n\n', r6(1,2), p6(1,2));
    %fprintf(fid, '\tNumber of Partial Melts to the Length of the Cycle: corr =  %g, p = %g\n\n', r7(1,2), p7(1,2));
    %fprintf(fid, '\tElapsed Time of Warming Phases to Change in Ice Volume in Warming Phases: corr =  %g, p = %g\n\n', r8(1,2), p8(1,2));
    %fprintf(fid, '\tCooling Times of Cycle k to Size of Next Melt: corr =  %g, p = %g\n\n', r9(1,2), p9(1,2));
    fprintf(fid, '\tMinimum Ice Volume to Next Maximum Ice Volume: corr =  %g, p = %g\n\n', r10(1,2), p10(1,2));
    %fprintf(fid, '\tMaximum Ice Volume to Next Maximum Ice Volume: corr =  %g, p = %g\n\n', r11(1,2), p11(1,2));
    %fprintf(fid, '\tMinimum Ice Volume to Size of Growth: corr =  %g, p = %g\n\n', r12(1,2), p12(1,2));
    %fprintf(fid, '\tMinimum Ice Volume to Relative Size of Growth: corr =  %g, p = %g\n\n', r13(1,2), p13(1,2));
    %fprintf(fid, '\tSize of Melt to Partial Melts per Cycle: corr =  %g, p = %g\n\n', r14(1,2), p14(1,2));
    %fprintf(fid, '\tPartial Melts per Cycle to Size of Next Melt: corr =  %g, p = %g\n\n', r15(1,2), p15(1,2));
    fprintf(fid, '\tIce Mass at Warming to Ice Mass at Cooling: corr =  %g, p = %g\n\n', r16(1,2), p16(1,2));
    fprintf(fid, '\tIce Mass at Cooling to Ice Mass at Next Warming: corr =  %g, p = %g\n\n', r17(1,2), p17(1,2));
    fprintf(fid, '______________________________________');
    
    fclose(fid);
    
end % if


figure(1)
clf
hold on;
plot(t,-I,'k-')
plot(t(maxI_k),-I(maxI_k),'b.','MarkerSize',10)
plot(t(minI_k),-I(minI_k),'r.','MarkerSize',10)
% Author: Raymart Ballesteros
% Date Created: 7/31/18
% Last edited: 8/16/18

% This script collects sample statistics of cycles
% Needs the following scripts to run:
%   sm91_find_cycles.m
%   sm91_partialcycles.m

sm91_params

% General Flags and runID
runID = 76;

ReadMeFlag = 0; 
Distr_Fig = 0;
FigSave = 0;

% Identifies data of model runs by the forcing used
%descr = 'insolHuybersIntegrated';
descr = 'insolLaskar';
%descr = 'solsticeLaskar';

fileName = sprintf('SM91_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/';

sm91_find_cycles

% Finding lengths of full cycles, and warm/cool phases, adn partial melts
full_times = [];
warm_times = [];
cool_times = [];
idMax_parI = [];
idMin_parI = [];

for i=1:length(tmin_co2)-1
   full = t(tmin_co2(i+1)) - t(tmin_co2(i));
   warm = t(tmax_co2(i)) - t(tmin_co2(i));
   cool = t(tmin_co2(i+1)) - t(tmax_co2(i));
      
   % Constructing vecotrs of lengths of full cycles, warming and cooling phases
   full_times = [full_times 10*full];
   warm_times = [warm_times 10*warm];
   cool_times = [cool_times 10*cool];
   
end %for

% vectors of the max/min ice mass (found in sm90_find_cycles)
maxI_k= I(maxI_k);  % The absolute max ice in cycle
minI_k = I(minI_k);  % The absolute min ice in cycle
next_maxI_k = I(next_maxI_k);  % The max ice during cooling phase

% costructing vector of proportion of ice melted in each cycle
dI = next_maxI_k(1:end-1) - minI_k(2:end);  % difference of ice from max ice in previous cycle to min ice melted in next cycle
prop_melt = [];
for j=1:length(dI)
   prop = dI(j)/next_maxI_k(j);
   prop_melt = [prop_melt prop];
end %for

% Constructing a vector of the lengths of partial melts
[idMax_parI,idMin_parI,partialsper]=sm90_partialmelts(tmax_co2(1:end-1),tmin_co2(2:end),t,I);
melts_per_cycle = partialsper;
num_pmelts = length(idMin_parI);
pmelt_mint = [];
pmelt_maxt = [];
for m=1:length(idMax_parI)
   pmelt_mint = [pmelt_mint t(idMin_parI(m))];
   pmelt_maxt = [pmelt_maxt t(idMax_parI(m))];
end %for

pmelt_lens = 10*(pmelt_mint - pmelt_maxt);


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
[r1,p1] = corrcoef(maxI_k,minI_k);  %max ice to min ice in a cycle

[r2,p2] = corrcoef(next_maxI_k(1:end-1),dI);  %max ice to size of next melt

[r3,p3] = corrcoef(next_maxI_k(1:end-1),prop_melt);  %max ice to relative size of next melt

[r4,p4] = corrcoef(next_maxI_k(1:end-1),full_times(2:end));  %max ice to length of next cycle

[r5,p5] = corrcoef(minI_k(2:end),dI);  %min ice to size of previous melt

[r6,p6] = corrcoef(minI_k(2:end),prop_melt);  %min ice to relative size of prev. melt

[r7,p7] = corrcoef(melts_per_cycle,full_times);  %number partials to length of cycle

[r8,p8] = corrcoef(warm_times,I(tmin_co2(1:end-1))-I(tmax_co2(1:end-1)));  %length of warming with change of ice in warming

[r9,p9] = corrcoef(cool_times(1:end-1),dI);  %cooling time to size of next melt

%[r10,p10] = corrcoef(minI_k(1:end-1),maxI_k(2:end));  %min ice to next max ice
[r10,p10] = corrcoef(minI_k,next_maxI_k);

[r11,p11] = corrcoef(next_maxI_k(1:end-1),next_maxI_k(2:end));  %max ice to next max ice

[r12,p12] = corrcoef(minI_k,next_maxI_k-minI_k);  %min ice to size of growth

[r13,p13] = corrcoef(minI_k,(next_maxI_k-minI_k)./next_maxI_k);  %min ice to relative size of growth

[r14,p14] = corrcoef(next_maxI_k-minI_k,melts_per_cycle);  %size of melt to number of partials per cycle

[r15,p15] = corrcoef(melts_per_cycle(1:end-1),dI);  %partial melts per cycle to size of next melt


%%--------%%
if ReadMeFlag == 1    

    % Construct filepath/filename to save stats
    filename = sprintf('SM91_%s_%d_Cycles.txt', descr, runID);
    filepath = '~/campgrp/rjballes/ModelRuns/sm91/Statistics/';
    fname = strcat(filepath, filename);
    fid = fopen(fname, 'w');
    fprintf(fid,'SM91_%s_%d_Cycles.txt\n', descr, runID);
    fprintf(fid, '\n\nLate Cycle Statistics (%g kyr run, u = %g, Forcing = %s)\n', 10*t(end), u, descr);
    fprintf(fid, 'Total # of Cycles: %g, Total # of Partial Melts: %g', length(full_times), num_pmelts);

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
    fprintf(fid, '\tMaximum Ice Mass to Minimum Ice Mass: corr =  %g, p = %g\n\n', r1(1,2), p1(1,2));
    fprintf(fid, '\tMaximum Ice Mass to Size of Next Melt: corr =  %g, p = %g\n\n', r2(1,2), p2(1,2));
    fprintf(fid, '\tMaximum Ice Mass to Relative Size of Next Melt: corr =  %g, p = %g\n\n', r3(1,2), p3(1,2));
    fprintf(fid, '\tMaximum Ice Mass to Length of Next Cycle: corr =  %g, p = %g\n\n', r4(1,2), p4(1,2));
    fprintf(fid, '\tMinimum Ice Mass to Size of Preceding Melt: corr =  %g, p = %g\n\n', r5(1,2), p5(1,2));
    fprintf(fid, '\tMinimum Ice Mass to Relative Size of Preceeding Melt: corr =  %g, p = %g\n\n', r6(1,2), p6(1,2));
    fprintf(fid, '\tNumber of Partial Melts to the Length of the Cycle: corr =  %g, p = %g\n\n', r7(1,2), p7(1,2));
    fprintf(fid, '\tElapsed Time of Warming Phases to Change in Ice Mass in Warming Phases: corr =  %g, p = %g\n\n', r8(1,2), p8(1,2));
    fprintf(fid, '\tCooling Times of Cycle k to Size of Next Melt: corr =  %g, p = %g\n\n', r9(1,2), p9(1,2));
    fprintf(fid, '\tMinimum Ice Mass to Next Maximum Ice Mass: corr =  %g, p = %g\n\n', r10(1,2), p10(1,2));
    fprintf(fid, '\tMaximum Ice Mass to Next Maximum Ice Mass: corr =  %g, p = %g\n\n', r11(1,2), p11(1,2));
    fprintf(fid, '\tMinimum Ice Mass to Size of Growth: corr =  %g, p = %g\n\n', r12(1,2), p12(1,2));
    fprintf(fid, '\tMinimum Ice Mass to Relative Size of Growth: corr =  %g, p = %g\n\n', r13(1,2), p13(1,2));
    fprintf(fid, '\tSize of Melt to Partial Melts per Cycle: corr =  %g, p = %g\n\n', r14(1,2), p14(1,2));
    fprintf(fid, '\tPartial Melts per Cycle to Size of Next Melt: corr =  %g, p = %g\n\n', r15(1,2), p15(1,2));
    fprintf(fid, '______________________________________');
    
    fclose(fid);
    
end % if


%%--------%%
if Distr_Fig == 1
    
    figure
    
    hold on   
    subplot(2, 2, 1)
    histogram(fullLength, 'BinMethod', 'integers')
    xlabel('Length of Cycle (kyr)')
    ylabel('Number of Cycles')

    subplot(2, 2, 2)
    histogram(melts_per_cycle, 'BinMethod', 'integers')
    xlabel('Number of Partial Melts per Cycle')
    ylabel('Number of Cycles')
    xticks([0 1 2 3])

    subplot(2, 2, 3)
    histogram(coolLength, 'BinMethod', 'integers')
    xlabel('Duration of Cooling Event (kyrs)')
    ylabel('Number of Cycles')

    subplot(2, 2, 4)
    histogram(warmLength, 'BinMethod', 'integers')
    xlabel('Duration of Warming Event (kyrs)')
    ylabel('Number of Cycles')
    hold off
    
    figure;
    
    hold on;
    %subplot(2,2,1)
    %histogram(time_state(:,1) - time_state(:,4), 'BinMethod', 'integers')
    %xlabel('Time to Local V Minimum after Last Warming Trigger (kyrs)')
    
    %subplot(2,3,2)
    %histogram(time_state(:,9), 15) % - time_state() for Delta
    %xlabel('V state at Melting Triggers')
    
    %subplot(2,3,3)
    %histogram(time_state(:,5) - time_state(:,6), 15)
    %xlabel('Delta A during Warming Event')
    %hold off
    
    subplot(2,2,1)
    histogram(pmelt_times, 'BinMethod', 'integers')
    xlabel('Time from Last Warming Trigger to Partial Melts (Local I Min in Cooling Event) (kyrs)')
    
    subplot(2,2,2)
    histogram(pmelt_lens, 'BinMethod', 'integers')
    xlabel('Duration of Partial Melts (Max to Min) (kyrs)')
    %hold off
    
    subplot(2,2,3)
    histogram(dI, 15)
    xlabel('Delta I during Warming Event')
    hold off;
    
    %hold on; 
    %subplot(2,2,1)
    %histogram(time_state(1,:) - time_state(9,:), 'BinMethod', 'integers')
    %xlabel('Time to Local I Minimum after Last Warming Trigger (kyrs)')
    %
    %%subplot(2,2,2)
    %%histogram(time_state(2,:), 15) % - time_state(6,:) for Delta
    %%xlabel('I state at Melting Triggers')
    %
    %subplot(2,2,2)
    %histogram(time_state(3,:) - time_state(7,:), 15)
    %xlabel('Delta A during Warming Event')
    %hold off
    %
    %subplot(2, 2, 3)
    %histogram(wtimes, 'BinMethod', 'integers')
    %xlabel('Duration of Warming Event (kyrs)')
    %ylabel('Number of Cycles')
    %
    %%subplot(2,2,4)
    %%histogram(vmaxes(2,:) - vmins(2,:), 'BinMethod', 'integers')
    %%xlabel('Duration of Partial Melts (Max to Min) (kyrs)')
    %%hold off
    %
    %subplot(2,2,4)
    %histogram(time_state(2,:) - time_state(6,:), 15)
    %xlabel('Delta I during Warming Event')
    %hold off
            
end % if
% Cycle_Stats

% Author: Brian Knight
% 07/04/2018

% Collects sample statistics of full and slow cycles

% initialize general file path

addMatlabpath

% Run PP04_Main to obtain Hout values, **Make sure your Params are identical to model run parameters**
n0 = [0,0,0.8];
PP04_Params_Model_Run
[tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0);

tstart = 0;
tfinal = 5000;

% Construct filepath/filename to save stats
filename = sprintf('PP04_%s_%d_Cycles.txt', descr, run_num);
filepath = '~/campgrp/Lib/Matlab/Models/PP04/Cycle_Statistics/stats/';
fname = strcat(filepath, filename);

%===============================================================%

ReadMeFlag = 1; % Write stats or not

end_time = [5000];%[800, 2600, 5000];

fid = fopen(fname, 'w');
fprintf(fid,'PP04_%s_%d_Cycles.txt\n', descr, run_num);

Hout = (Hout > 0);
for j = 1:length(end_time) % loops through early, mid, and late cycles

    % Collect times when warming begins (Deglaciation triggers)
    trig_warm = [];
    for i = tstart+1:end_time(j)
        
        % *Note* Hout = 1 or Hout = 0
        if Hout(i+1)<Hout(i)
            if isempty(trig_warm) || trig_warm(end)~= i-1
                trig_warm=[trig_warm,i];
            end % if
        end % if

    end % for
    
    
    % Collect times when cooling begins (Glaciation triggers)
    trig_cool = [];

    for i = tstart+1:end_time(j) 

        if Hout(i+1)>Hout(i)
            if isempty(trig_cool) || trig_cool(end)~= i-1
                trig_cool=[trig_cool,i];
            end % if
        end % if

    end % for
    
%===============================================================%

    % Find length of full cycles (warming trigger to warming trigger)
    full_cycles = trig_warm(2:end)-trig_warm(1:end-1);
    
     
    % Find the length of the cooling times and warming times in each cycle

    if trig_warm(1) < trig_cool(1)
         ctimes = trig_cool - trig_warm(1:length(trig_cool));
         wtimes = full_cycles - ctimes(1:length(full_cycles));
    else
        ctimes = trig_cool(2:end) - trig_warm(1:length(trig_cool) - 1);
        wtimes = full_cycles - ctimes(1:length(full_cycles));
    end % if

    % Create equal length arrays
    if length(wtimes) > length(ctimes)
        wtimes = wtimes(1:length(ctimes));
    elseif length(wtimes) < length(ctimes)
        ctimes = ctimes(1:length(wtimes));
    end % if
    
    
    % Full Cycle Statistics

    avg_cycle = mean(full_cycles);

    max_cycle = max(full_cycles);

    min_cycle = min(full_cycles);


    % Cooling Model Statistics (Glaciation)

    avg_cool_time = mean(ctimes);

    max_cool_time = max(ctimes);

    min_cool_time = min(ctimes);
    

    % Warming Model Statistics (Deglacition)

    avg_warm_time = mean(wtimes);

    max_warm_time = max(wtimes);

    min_warm_time = min(wtimes);
    

    % Length of averge glaciation relative to average deglaciation

    asymmetry_of_avg = avg_cool_time/ avg_warm_time;
    asymm_vec = ctimes(1:length(wtimes))/wtimes;
    avg_of_asymmetry = sum(asymm_vec)/length(asymm_vec);
    
%============================ Write Routine ============================%

    if ReadMeFlag    

        fprintf(fid, '\n\nCycle stats for last %d kyr:\n', end_time(j));

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
        fprintf(fid, '\n\nAsymmetry Statistics:\n');
        fprintf(fid, '\tAsymmetry of the Averages = %g\n', asymmetry_of_avg);
        fprintf(fid, '\tAverage of the Asymmetries = %g\n', avg_of_asymmetry);
        fprintf(fid, '\n______________________________________');
        
    end % if
    
end % for
    
fclose(fid);

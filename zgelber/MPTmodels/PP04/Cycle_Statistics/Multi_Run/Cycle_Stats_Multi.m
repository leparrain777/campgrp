% Cycle_Stats

% Author: Brian Knight - 07/04/2018
% Modified by Zachary Gelber - 07/22/2019

% Collects sample statistics of full and slow cycles

addMatlabpath

% Run PP04_Main to obtain Hout values, **Make sure your Params are identical to model run parameters**
%n0 = [0,0,0.8];
PP04_Params_Multi_Run
[tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0);

%===============================================================%


Hout = (Hout > 0);
%for j = 1:length(end_time) % loops through early, mid, and late cycles

    % Collect times when warming begins (Deglaciation triggers)
    trig_warm = [];
    for i = tstart+1:tfinal
        
        % *Note* Hout = 1 or Hout = 0
        if Hout(i+1)<Hout(i)
            if isempty(trig_warm) || trig_warm(end)~= i-1
                trig_warm=[trig_warm,i];
            end % if
        end % if

    end % for
    
    
    % Collect times when cooling begins (Glaciation triggers)
    trig_cool = [];

    for i = tstart+1:tfinal

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

    

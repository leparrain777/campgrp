% Cycle_Stats

% Author: Brian Knight - 07/04/2018
% Modified by Zachary Gelber - 07/22/2019

% Collects sample statistics of full and slow cycles

%===============================================================%
Hout = (Hout > 0);
%for j = 1:length(end_time) % loops through early, mid, and late cycles

    % Collect times when warming begins (Deglaciation triggers)
    trig_warm = [];
    for i = cycle_tstart+1:cycle_tfinal
        
        % *Note* Hout = 1 or Hout = 0
        if Hout(i+1)<Hout(i)
            if isempty(trig_warm) || trig_warm(end)~= i-1
                trig_warm=[trig_warm,i];
            end % if
        end % if

    end % for

%===============================================================%

    % Find length of full cycles (warming trigger to warming trigger)
    full_cycles = trig_warm(2:end)-trig_warm(1:end-1);
    
    % Full Cycle Statistics

    avg_cycle = mean(full_cycles);
    

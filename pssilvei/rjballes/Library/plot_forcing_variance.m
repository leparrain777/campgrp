%data1 = readData('forcing_v_var_stats_old.txt', '~/campgrp/brknight/PP04_Data/forcing_search/forcing_variance_stats/', 11);
% this is for unrealistic forcing coefficients, still valid data, splitting up model output by 800 kyr.

%data2 = readData('forcing_v_var_stats.txt', '~/campgrp/brknight/PP04_Data/forcing_search/forcing_variance_stats/', 11);
% Relevant forcing coefficients, between .55 and 1.05. By splitting up each model run into 4 separate 800 kyr.

%data3 = readData('forcing_v_var_stats_full.txt', '~/campgrp/brknight/PP04_Data/forcing_search/forcing_variance_stats/', 11);
% Only EEMD variation here. Used same model run for each forcing coeff. and ran 4 eemd's on each.

%data4 = readData('forcing_v_var_stats_both.txt', '~/campgrp/brknight/PP04_Data/forcing_search/forcing_variance_stats/', 11);
% Here we randomize 4 initial conditions for each forcing coeff and run an eemd on the output.

%data5 = readData('forcing_v_mode_var_time.txt', '~/campgrp/brknight/PP04_Data/forcing_search/forcing_variance_stats/', 1);
%forcing_coeffs = data4(1,:);

data6 = readData('forcing_v_mode_var_time_fine1.txt', '~/campgrp/rjballes/ModelRuns/sm91/ForcingSearch/forcing_variance_stats/', 1);

data7 = readData('forcing_v_mode_var_time_fine1.txt', '~/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/forcing_variance_stats/', 1);

grid on
hold on

for i = 2:length(data6(:,1))
    
    %scatter(forcing_coeffs, data5(i,:))
    scatter(2:length(data6(:,1)),data6(2:end,1))
    
end % for
xticks(8:8:40)
%xlabel('Forcing Coefficient','FontSize', 12)
ylabel('Mode Variance Ratio','FontSize', 12)
%title('Mode Variance Ratio vs. Forcing Coefficient, Single IC, mulitple EEMDs','FontSize',14)
%title('Mode Variance Ratio vs. Forcing Coefficient, multiple IC, mulitple EEMDs','FontSize',14)
title('Mode Variance Ratio vs. 800 kyr section from model output, forcing coeff = .4, 100kyr window shifts','FontSize',14)
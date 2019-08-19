%Author: Zachary Gelber - 07/31/2019

figure()
x_values = size_of_windows*0.5:size_of_windows*0.5:window_tfinal-(size_of_windows*0.5);
p1 = plot(x_values, mean_vals);
title_string = [descr, ' | Force Amplitude: ', num2str(force_amplitude), ' | Runs Averaged: ', num2str(run_amount)];
title(title_string);
xlabel_string = ['Center of ', num2str(size_of_windows), 'k year windows'];
xlabel(xlabel_string);
ylabel('Period (in thousands of years)');
ylim([30,140]);   %This limit was chosen since we expect periods to be between ~40 and ~120.

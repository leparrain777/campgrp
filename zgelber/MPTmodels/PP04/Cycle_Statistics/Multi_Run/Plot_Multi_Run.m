function Plot_Multi_Run(vals, refined_vals, errors, descr, tstart, tfinal)

%Author: Zachary Gelber - 07/18/2019 

%errors - an array (possibly empty) containing a ratio and its corresponding corrected periodicity.
         %For some ratio values, either no model switches trigger or abnormally large cycles occur. 
         %To avoid crashing and to be able to later investigate these abnormalities, its calculated value is ignored
         %and for the sake of plotting it takes the average of the previous and next ratio value. A red star is plotted
         %on it to indicate that it is an abnormality.
%descr - a string indicating what forcing was used. Used as a title for the plot.
%tstart/tfinal - integers for start and end times (in thousands of years ago)

ratio_values = vals(:,1);
mean_full_cycles_to_plot = vals(:,2);

%Plotting%
%-------------------------------------%
figure()
set(gca, 'XLim', [ratio_values(1), ratio_values(end)]);
hold on

p1 = plot(ratio_values, mean_full_cycles_to_plot, 'r');
if length(errors) > 0
    plot(errors(1,:), errors(2,:), '-p', 'MarkerSize', 8, 'MarkerFaceColor', 'blue', 'MarkerEdgeColor', 'blue', 'LineStyle', 'None')
end

if length(refined_vals) ~= length(vals)
    p2 = plot(refined_vals(:,1), refined_vals(:,2), 'm');
end

legend([p1], 'Mean of cycles');

xlabel('Ratio');
ylabel('Period');

plot_title = [descr, ' ', num2str(tstart), ' kyr to ', num2str(tfinal), ' kyr'];
title(plot_title);
hold off
%-------------------------------------%

end

function Plot_Slow_Cycles(cycles)
% Plots all the cyles in the last ### kyrs

Partial_Melts

figure
for i = cycles %1:length(full_cycles)
    subplot(5, 5, i)
    Plot_Cycle(i)
end
function Plot_MeanGrid(tau_begin, tau_end, force_amplitude_begin, force_amplitude_end, grid_array)
%Author: Zachary Gelber - 08/12/2019

figure;
x_axis = [tau_begin tau_end];
y_axis = [force_amplitude_begin force_amplitude_end];
imagesc(x_axis, y_axis, flipud(grid_array));
colorbar;
set(gca, 'YDir', 'normal');
xlabel('Tau');
ylabel('Force_Amplitude');
title('Cool name to come');
savefig('grid_fig');

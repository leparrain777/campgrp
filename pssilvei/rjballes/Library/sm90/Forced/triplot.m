% Plots the three components of the Saltzman model.  Can be used for any three graphs.

% Date: 30 June 2014
% Author: Andrew Gallatin

figure;
subplot(3,1,1)
plot(t,x(:,1))
axis([0 500 2 8])
subplot(3,1,2)
plot(t,x(:,2))
axis([0 500 150 450])
subplot(3,1,3)
plot(t,x(:,3))
axis([0 500 3 7])

print(gcf, '-djpeg','plots_prac');

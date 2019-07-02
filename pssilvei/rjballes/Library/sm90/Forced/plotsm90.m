% plot the solutions
figure;
subplot(4,1,1)
insolPlot = plot(insolT,insol,'LineWidth',2.0);
axis([0 50 -3.5 3.5])
subplot(4,1,2)
Xplot = plot(t,x(:,1),'LineWidth',2.0);
axis([0 50 -3 3])
subplot(4,1,3)
Yplot = plot(t,x(:,2),'LineWidth',2.0);
axis([0 50 -2 4.5])
subplot(4,1,4)
Zplot = plot(t,x(:,3),'LineWidth',2.0);
axis([0 50 -2 3])

% Save the figure to a file
print(gcf,'-dpdf', 'fig5)insol10');

function trend = PlotEEMDDataTrend(nmodes,distBetweenModes,endmode)
%PlotEEMDDataTrend This function takes an nmodes array and plots each of its mod
%es from EEMD onto the same graph.
%
% PlotEEMDData(nmodes,distBetweenModes)
%
% nmodes is the EEMD output from your data obtained from running the eemd
% function.
%
% distBetweenModes corresponds to the multiple of standard deviations of the
% data desired in between each IMF (or mode).
%
% endmode is the final mode you wish to plot; the rest will be incorperated in
% the trend.
%
% Returns figureOut, a handle for the plot.

nmodes(:,1) = nmodes(:,1) - mean(nmodes(:,1));

for i=1:size(nmodes,2)
    nmodes(:,i) = nmodes(end:-1:1,i);
    nmodes(:,i) = -1*nmodes(:,i);
end

trend = nmodes(:,endmode+2);
for i=endmode+3:size(nmodes,2)
    for j = 1:size(nmodes,1)
        trend(j) = trend(j)+nmodes(j,i);
end

time = [0:1:size(nmodes,1)-1]';
plot(time,nmodes(:,1),'k');
hold on
plot(time,trend-mean(trend));

for i=2:endmode+1
    plot(time,nmodes(:,i)-distBetweenModes*std(nmodes(:,1))*(i-1),'k')
    tmp = -1*distBetweenModes*std(nmodes(:,1))*(i-1);
    plot(time,linspace(tmp,tmp,size(nmodes,1)),'k--')
end
hold off
set(gca,'YTick',[]);
xlabel('Kyr ago','FontSize',14);
%ylabel('Negative Ice Volume','FontSize',14);
ylabel('\delta^{18}O Anomally','FontSize',14);

end


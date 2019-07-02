function figureOut = PlotEEMDData(nmodes,distBetweenModes)
%PlotEEMD This function takes an nmodes array and plots each of its modes from
%EEMD onto the same graph.
% PlotEEMDData(nmodes,distBetweenModes)
% nmodes is the EEMD output from your data obtained from running the eemd
% function.
% distBetweenModes corresponds to the multiple of standard deviations of the
% data desired in between each IMF (or mode).
%
% Returns figureOut, a handle for the plot.

nmodes(:,1) = nmodes(:,1) - mean(nmodes(:,1));

for i=1:size(nmodes,2)
    nmodes(:,i) = -nmodes(:,i);
    nmodes(:,i) = nmodes(end:-1:1,i);
end

figureOut = plot(nmodes(:,1));
hold on
for i=2:size(nmodes,2)
    plot(nmodes(:,i)-distBetweenModes*std(nmodes(:,1))*(i-1))
end
hold off

end

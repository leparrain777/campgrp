function [figure,nmodes] = PlotEEMD(Data,whiteNoise,iterations,distBetweenModes)
%PlotEEMD This function takes a Data array and plots each of its modes from EEMD
%onto the same graph.
% PlotEEMD(Data,whiteNoise,iterations,distBetweenModes) whiteNoise corresponds
% corresponds to the amount of white noise desired in the EEMD run. iterations
% corresponds to the number of desired iterations in the EEMD run.
% distBetweenModes corresponds to the multiple of standard deviations of the
% data desired in between each IMF (or mode).
%
% Returns figure, a handle for the plot, and returns nmodes, a matrix with each
% column corresponding to a vector with the data for that particular IMF, with
% nmodes(1) being the original data set.

nmodes = eemd(Data,whiteNoise,iterations);
figure = plot(nmodes(:,1));
hold on
for i=2:size(nmodes,2)
    plot(nmodes(:,i)-distBetweenModes*std(Data)*(i-1))
end
hold off
end

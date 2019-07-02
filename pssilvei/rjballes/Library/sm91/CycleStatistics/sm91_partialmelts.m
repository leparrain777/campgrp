function [idxMaxI,idxMinI,partialsper] = sm91_partialmelts(tstart,tend,t,I)
% This script searches for partial cycles for each cycle in an entire model run.
% Inputs:
%   tstart := a vector of starting times (indices) of cooling phase
%   tend := vector of the ending times (indices) of cooling phase
%   t := a vector of the timespan of the model run
%   I := a vector of the values of ice mass (for whole data set)
%
% Example:  [idxMaxI,idxMinI,partialsper] = sm90_partialmelts(tmax_co2(1:end-1),tmin_co2(2:end),t,I);
%
% Outputs:
%   idxMaxI := a vector of the indices of max I values in partials
%   idxMinI := a vector of the indices of min I values in partials
%   partialsper := a vector of the number of partial melts per cycle

% Finding max/min pairs of ice
D_extrs = [];
partialsper = [];
num_pmelts = 0;

% We iterate through each interval and find max/min pairs
% First find all indices of local max of ice during cooling phases,
% then from each local max we go through until the sign of delta ice changes from negative to positive.
for k=1:length(tstart)
   
   [mxs,~] = extrema(I(tstart(k):tend(k)));
   mxs = mxs(2:end-1,1);
   partialsper = [partialsper size(mxs,1)];
   D_extrs = [D_extrs; mxs(:,1)+tstart(k) zeros(size(mxs,1),1)];
      
end %for

for k=1:size(D_extrs,1)
   j = D_extrs(k,1);
   while I(j+1) < I(j)
      j = j+1;
   end %while
   D_extrs(k,2) = j;
end %for

% Assigning the output variables
idxMaxI = D_extrs(:,1); %extrs(:,1); %partMaxAt;
idxMinI = D_extrs(:,2); %extrs(:,2); %partMinAt;
partialsper = partialsper; %[partialsper length(idxMaxI)-sum(partialsper)];

end
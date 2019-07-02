function [idxMaxI,idxMinI,partialsper] = sm90_partialmelts(tstart,tend,t,I)
% This script searches for partial cycles within a particular cycle.
% Inputs:
%   tstart := a vector of starting times (indices) of cooling phase
%   tend := vector of the ending times (indices) of cooling phase
%   t := a vector of the timespan of the model run
%   I := a vector of the values of ice mass (for whole data set)
%
% Example:  [idxMaxI,idxMinI,partialsper] = sm90_paritalmelts(tmax_co2(1:end-1),tmin_co2(2:end),I);
%
% Outputs:
%   idxMaxI := a vector of the indices of max I values in partials
%   idxMinI := a vector of the indices of min I values in partials
%   partialsper := a vector of the number of partial melts per cycle


% Finding max/min pairs; define a partial from min to next min.
%new_partMinAt = [];
%new_partMaxAt = [];
%partMinAt = [];
%partialsper = [];

%for k=1:length(tstart)
%   low = min(find(t>=tstart(k)));
%   i = low;
%   %partMinAt = [];
%   count = 0;
%   chck = 0;
%   while i < max(find(t<=tend(k)))
%      if count == 0
%         if I(i+1) > I(i)
%            count = count+1;
%            partMinAt = [partMinAt i];
%            chck = chck+1;
%         end %if
%      
%      else
%         if I(i+1) < I(i)
%            count = 0;
%         end %if
%      
%      end %if
%      i = i+1;
%   
%   end %while
%   partMinAt = [partMinAt 0];
%   %partialsper = [partialsper chck-1];
%   
%end %for

%extrs = [];
%partMaxAt = [];
%count = 0;
%for k=1:length(partMinAt)-1
%   if partMinAt(k)~=0
%      t1 = partMinAt(k);
%      if partMinAt(k+1)~=0
%         t2 = partMinAt(k+1);
%         mx = find(I==max(I(t1:t2)));
%         %partMaxAt = [partMaxAt mx];
%         count = count+1;
%         extrs = [extrs;mx partMinAt(k+1)];
%      end %if
%   else
%      partialsper = [partialsper count];
%      count = 0;
%   end %if
%end %for

%j = 1;
%count = 0;
%num_pmelts = [];
%while j <= length(partMinAt)
%   while partMinAt(j)~=0
%      newpartMinAt = [newpartMinAt j];
%      j = j+1;
%      count = 0;
%   end %while
%   num_pmelts = [num_pmelts count-1];
%   count = 0;
%end %while

% Finding max/min pairs of ice
D_extrs = [];
%partMaxAt = [];
%partMinAt = [];
partialsper = [];
num_pmelts = 0;

% We iterate through each interval and find max/min pairs
% First find all indices of local max of ice during cooling phases,
% then from each local max we go through until the sign of delta ice changes from negative to positive.
for k=1:length(tstart)
   i = tstart(k);
   count = 0;
   %num_pmelts = 0;
   %partMaxAt = i;
   %partMinAt = i;
   
   [mxs,~] = extrema(I(tstart(k):tend(k)));
   mxs = mxs(2:end-1,1);
   num_pmelts = num_pmelts + size(mxs,1);
   partialsper = [partialsper size(mxs,1)];
   D_extrs = [D_extrs; mxs(:,1)+tstart(k) zeros(size(mxs,1),1)];
   
   % might also be abel to use extrema func to find minima
   
   % Truncate times (indices) where ice lags and still decreases after trigger   
   %while I(i+1)-I(i) < 0
   %   i = i+1;
   %end %while

   %while i < tend(k)
   %   %while count < 2
   %      %if i >= tend(k)
   %      %   break
   %      %end %if
   %      
   %   if count == 0
   %      if I(i+1) < I(i)
   %         D_extrs(k,1) = i;
   %         count = count+1;
   %         num_pmelts = num_pmelts+1;
   %      %deltaI = I(i+1)-I(i);
   %      %if count==0
   %         %if deltaI < 0
   %            %partMaxAt = i;
   %            %count = count+1;
   %       end %if
   %   else
   %      if I(i+1) > I(i)
   %         count = 0;
   %         %if deltaI > 0
   %            %partMinAt = i;
   %            %count = count+1;
   %            %num_pmelts = num_pmelts+1;
   %      end %if
   %   end %if
   %   i = i+1;
   %   %end %if
   %   
   %   %D_extrs = [D_extrs; partMaxAt partMinAt];
   %   
   %end %while
   %partialsper = [partialsper num_pmelts];
   
end %for

for k=1:size(D_extrs,1)
   j = D_extrs(k,1);
   while I(j+1) < I(j)
      j = j+1;
   end %while
   D_extrs(k,2) = j;
end %for

% Assigning the output variables
%numPartials = length(partMaxAt);
idxMaxI = D_extrs(:,1); %extrs(:,1); %partMaxAt;
idxMinI = D_extrs(:,2); %extrs(:,2); %partMinAt;
partialsper = partialsper; %[partialsper length(idxMaxI)-sum(partialsper)];

end
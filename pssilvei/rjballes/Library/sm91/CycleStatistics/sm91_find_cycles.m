function [data,fullMat,iceMat] = sm91_find_cycles(fileName,filePath)

% [data,fullMat,iceMat] = sm91_find_cycles(fileName,filePath);
% This function reads the output for the specified model run
% and records times of max/min CO2 with its state variables,
% times of max/min ice mass with state values from past to present.
%
% Input:
%   fileName := the name of the txt file to be read for model output
%   filePath := the path of the file to be read
%
% Output:
%   fullMat := a matrix of the start/switch/end times (indices) of cycles based on co2
%              with the state variables at each time.
%   iceMat := a matrix of the times (indices) of absolute max/min ice mass in each cycle
%             and state vaiables at each time.


% Reading in data and putting it into an array
[A,te,ye] = readSM91Data(fileName,filePath,4);

% Separating the variables
%t = [0:0.1:500];
%I = A(:,2);
%Mu = A(:,3);
%Theta = A(:,4);

t = A(:,1);
I = A(:,2);
Mu = A(:,3);
normMu = (Mu-mean(Mu))/(std(Mu));
Theta = A(:,4);

% We define a cycle as from a time of minimum co2 to the next minimum.
% Create vectors for the times max/min of co2 and its value.

% Truncate early times (transient) and make sure start with min co2 (melt phase).
if ye(1:2) < ye(2,2)
   tmin = te(3:2:end);
   tmax = te(4:2:end);
   ye_min = ye(3:2:end,:);
   ye_max = ye(4:2:end,:);
   %min_co2 = ye(3:2:end,2);
   %max_co2 = ye(4:2:end,2);
   %temin_I = ye(3:2:end,1);
   %temax_I = ye(4:2:end,1);
elseif ye(1,2) > ye(2,2)
   tmin = te(2:2:end);
   tmax = te(3:2:end);
   ye_min = ye(2:2:end,:);
   ye_max = ye(3:2:end,:);
   %min_co2 = ye(2:2:end,2);
   %max_co2 = ye(3:2:end,2);
   %temin_I = ye(2:2:end,1);
   %temax_I = ye(3:2:end,1);
end %if

% We find the difference of max/min pairs of co2.
% Sort through for where the difference is less than one standard
% deviation of the co2 data from model; we combine that interval with the nex pair.
%diff = ye_max(:,2) - ye_min(:,2);
%diff = ye_max(1:end-1,2) - ye_min(2:end,2);
%melts = ye_min(:,1) - ye_max(:,1);

%isfull1 = (diff > std(Mu));
%isfull2 = (abs(melts) > std(I));

%tmaxfull1 = tmax(isfull1);
%tminfull1 = tmin(isfull1);
%id1_1 = [];
%id1_2 = [];
%for k=1:length(tmaxfull1)
%   id1_1 = [id1_1 find(te==tmaxfull1(k))];
%   id1_2 = [id1_2 find(te==tminfull1(k))];
%end %for

%tmaxfull2 = tmax(isfull2);
%tminfull2 = tmin(isfull2);
%id2_1 = [];
%id2_2 = [];
%for k=1:length(tmaxfull2)
%   id2_1 = [id2_1 find(te==tmaxfull2(k))];
%   id2_2 = [id2_2 find(te==tminfull2(k))];
%end %for


%check = find(diff < std(Mu));
%for h=1:length(check)
%   if min_co2(check(h)) > min_co2(check(h)+1)
%      tmin_co2(check(h)) = 9999; %[tmin_co2(1:check(h)); tmin_co2(check(h)+2:end)];
%      tmax_co2(check(h)) = 9999; %[tmax_co2(1:check(h)-1); tmax_co2(check(h)+1:end)];
%      min_co2(check(h)) = 9999; %[min_co2(1:check(h)); min_co2(check(h)+2:end)];
%      max_co2(check(h)) = 9999; %[max_co2(1:check(h)-1); max_co2(check(h)+1:end)];
%      temin_I(check(h)) = 9999; %[temin_I(1:check(h)); temin_I(check(h)+2:end)];
%      temax_I(check(h)) = 9999; %[temax_I(1:check(h)-1); temax_I(check(h)+1:end)];
%   else
%      tmin_co2(check(h)+1) = 999; %[tmin_co2(1:check(h)); tmin_co2(check(h)+2:end)];
%      tmax_co2(check(h)) = 999; %[tmax_co2(1:check(h)-1); tmax_co2(check(h)+1:end)];
%      min_co2(check(h)+1) = 999; %[min_co2(1:check(h)); min_co2(check(h)+2:end)];
%      max_co2(check(h)) = 999; %[max_co2(1:check(h)-1); max_co2(check(h)+1:end)];
%      temin_I(check(h)+1) = 999; %[temin_I(1:check(h)); temin_I(check(h)+2:end)];
%      temax_I(check(h)) = 999; %[temax_I(1:check(h)-1); temax_I(check(h)+1:end)];
%   end %if
%end %for

%tmin_co2 = tmin_co2(tmin_co2 ~= 999 & tmin_co2 ~= 9999);
%tmax_co2 = tmax_co2(tmax_co2 ~= 999 & tmax_co2 ~= 9999);
%min_co2 = min_co2(min_co2 ~= 999 & min_co2 ~= 9999);
%max_co2 = max_co2(max_co2 ~= 999 & max_co2 ~= 9999);
%temin_I = temin_I(temin_I ~= 999 & temin_I ~= 9999);
%temax_I = temax_I(temax_I ~= 999 & temax_I ~= 9999);

% Create a vector of the start times of cycles
%tspan = [];
%for k=1:length(tmin_co2)
%   x = max(find(t <= tmin_co2(k)));
%   tspan = [tspan x];
%end %for

% We determine the time periods for the cycles by finding where the 
% curve loops around near the initial value for CO2.
% We also search for the times of a global max/min for CO2 and ocean temp in each cycle.
lenData = length(Mu);
i = 1;
newi = i;
count = 0;
tspan = [1];
% Times of extreme values for CO2
mx = 1;
mn = 1;
tmax_co2 = []; 
tmin_co2 = []; 

%%figure;
%%hold on;
while i < lenData
   i = i+1;
   if count == 0
      if normMu(i) >= 0
         count = 1;
      end %if
   else
      if normMu(i) <= 0
         count = 0;
         tspan = [tspan i];
         %tmax_co2 = [tmax_co2 mx];
         %tmin_co2 = [tmin_co2 mn];
         %mx = i;
         %mn = i;
      end %if
   end %if
   
end %while

if ~ismember(i,tspan)
   tspan = [tspan i];
end %if

for j=1:length(tspan)-1
   check = Mu(tspan(j):tspan(j+1));
   mx = find(check==max(Mu(tspan(j):tspan(j+1))));
   mn = find(check==min(Mu(tspan(j):tspan(j+1))));
   
   tmin_co2 = [tmin_co2 mn+tspan(j)-1];
   tmax_co2 = [tmax_co2 mx(1)+tspan(j)-1];
   
end %for

% Here we determine the times (indices) of the max/min ice mass in each cycle
maxI_k= [];  % The absolute max ice in cycle
minI_k = [];  % The absolute min ice in cycle
next_maxI_k = [];  % The max ice during cooling phase

for k=1:length(tmin_co2)-1
   t1 = tmin_co2(k);
   t2 = tmin_co2(k+1);
   %e1 = tmax_co2(k);
   check = I(t1:t2);
   mx = find(check==max(check));
   mn = find(check==min(check));
   
   maxI_k = [maxI_k mx+t1-1];
   minI_k = [minI_k mn+t1-1];
end %for

for k=1:length(tmax_co2)-1
   t1 = tmax_co2(k);
   t2 = tmin_co2(k+1);
   check = I(t1:t2);
   mx = find(check==max(check));
   
   next_maxI_k = [next_maxI_k mx+tmin_co2(k)-1];
end %for


% Assigning output variables
data = [t I Mu Theta];
fullMat = [tmin_co2' tmax_co2'];
%fullMat = [tminfull1 ye(id1_2,:) tmaxfull1 ye(id1_1,:)];
iceMat = [maxI_k' minI_k' next_maxI_k'];

end %function
%function [data,fullMat,iceMat,eventsMat] = sm90_find_cycles(fileName,filePath)

% [data,fullMat,iceMat,eventsMat] = sm90_find_cycles(fileName,filePath);
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

fileName = sprintf('SM90_%s_%d_forcing_Model.txt',descr, runID);
filePath = '~/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/';

% Reading in data and putting it into an array
[A,te,ye] = readSM90Data(fileName,filePath,4);

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

time = 0:4000;
len = length(time);

signal = (I)/std(I);
[maxes,mins] = extrema(signal);

maxend = length(maxes); % Array lengths
minend = length(mins);
%maxarray = 1:maxend-1;
%minarray = 2:minend;

if maxes(2,1) > mins(2,1)
    if maxes(end-1,1) > mins(end-1,1)
        maxarray = 1:maxend-1;
        minarray = 2:minend;
        disp('used 1')
    else % maxes(end-1,1) < mins(end-1,1)
        maxarray = 1:maxend-1;
        minarray = 2:minend-1;
        disp('used 2')
    end % if
else % if maxes(2,1) < mins(2,1)
    if maxes(end-1,1) > mins(end-1,1)
        maxarray = 2:maxend-2;
        minarray = 2:minend-1;
        disp('used 3')
    else % maxes(end,1) < mins(end,1)
        maxarray = 2:maxend-1;
        minarray = 2:minend-1;
        disp('used 4')
    end % if
end % if


% Find indices of times of maxes and mins respectively
tmax = [time(maxes(maxarray,1))]';
maxEO = maxes(maxarray,2);
tmin = [time(mins(minarray,1))]';
minEO = mins(minarray,2);
length(tmax)
length(tmin)
cutoff = min(length(maxEO), length(minEO));
maxEO = maxEO(1:cutoff);
minEO = minEO(1:cutoff);

tmid = mean([tmin,tmax],2);
diffEO = maxEO - minEO;
midEO = (signal(floor(tmid)+1) + signal(ceil(tmid)+1))/2;
% create cubic spline for interpolation of midpoints in time
midSig = spline(time, signal,tmid);
dev = 1.1251;
%dev = 1.45;
ind0 = find(diffEO > dev.*std(signal));

% We define a cycle as from a time of minimum co2 to the next minimum.
% Create vectors for the times max/min of co2 and its value.
% Truncate early times (transient) and making sure start with min co2 (melt phase).
%if ye(1,2) < ye(2,2)
%   if ye(1,2) < ye(3,2)
%      disp('1 used')
%      tmin = te(1:2:end);
%      tmax = te(2:2:end);
%      ye_min = ye(1:2:end,:);
%      ye_max = ye(2:2:end,:);
%   else
%      disp('2 used')
%      tmin = te(3:2:end);
%      tmax = te(4:2:end);
%      ye_min = ye(3:2:end,:);
%      ye_max = ye(4:2:end,:);
%   end %if
%elseif ye(1,2) > ye(2,2)
%   if ye(2,2) < ye(4,2)
%      disp('3 used')
%      tmin = te(2:2:end);
%      tmax = te(3:2:end);
%      ye_min = ye(2:2:end,:);
%      ye_max = ye(3:2:end,:);
%   else
%      disp('4 used')
%      tmin = te(4:2:end);
%      tmax = te(5:2:end);
%      ye_min = ye(4:2:end,:);
%      ye_max = ye(5:2:end,:);
%   end %if
%end %if
%
%% We look at the times of max/min CO2 to find the max/min times of ice by
%% looking for max/min ice between two min CO2.
%tmax_ice = [];
%tmin_ice = [];
%for k=1:length(tmin)-1
%   %t1 = find(t==floor(tmin(k)*10)/10);
%   %t2 = find(t==floor(tmin(k+1)*10)/10);
%   t1 = find(abs(t-round(tmin(k))) < 0.001);
%   t2 = find(abs(t-round(tmin(k+1))) < 0.001);
%   int = I(t1:t2);
%   
%   mx = find(int==max(int));
%   mn = find(int==min(int));
%   tmax_ice = [tmax_ice mx+t1-1];
%   tmin_ice = [tmin_ice mn+t1-1];
%end %for
%
%del_r1 = [];
%for p=1:length(tmax_ice)-1
%   if abs(tmax_ice(p)-tmax_ice(p+1)) < 25
%      del_r1 = [del_r1 tmax_ice(p)];
%   end %if
%end %for
%
%del_r2 = [];
%for p=1:length(tmax_ice)-1
%   if abs(tmin_ice(p)-tmin_ice(p+1)) < 25
%      del_r2 = [del_r2 tmin_ice(p)];
%   end %if
%end %for


% We find the difference of max/min pairs of co2.
% Sort through for where the difference is less than some threshold
% of the standard deviation of the co2 data from model and delete that pair.
%diff2 = ye_max(1:end-1,2) - ye_min(2:end,2);
%diff2 = ye_max(1:end-1,2) - ye_min(2:end-1,2);

%issmall1 = find(diff2 < 0.2*std(Mu));

%[tmax,~] = removerows(tmax,'ind',issmall1);
%[ye_max,~] = removerows(ye_max,'ind',issmall1);

%issmall2 = issmall1+1;

%[issmall1 issmall2]
%[tmin,~] = removerows(tmin,'ind',issmall2);
%[ye_min,~] = removerows(ye_min,'ind',issmall2);


%diff1 = ye_max(1:end,2) - ye_min(1:end,2);

%issmall1 = find(diff1 < 0.5969*std(Mu));
%issmall1 = find(diff1 < 0.4*std(Mu));
%issmall1 = find(diff1 < std(Mu));
%issmall1 = find(diff1 < 0.353*std(Mu));
%issmall1 = find(diff1 < 0.475*std(Mu));

%[tmax,~] = removerows(tmax,'ind',issmall1);
%[ye_max,~] = removerows(ye_max,'ind',issmall1);


% At the points where the diff is small, we search for min co2 at
% that point and delete the other point around that index.
%issmall2 = [];
%for q=1:length(issmall1)
%   g1 = issmall1(q);
%   g2 = issmall1(q)+1;
%   if g2 > length(ye_min)
%      g2 = length(ye_min);
%   end %if
%   new = find(ye_min(:,2) == max(ye_min(g1,2),ye_min(g2,2)));
%   if ismember(new,issmall2)
%      issmall2 = [issmall2; new+1];
%   else
%      issmall2 = [issmall2; new];
%   end %if
%end %for

%[issmall1 issmall2]
%[tmin,~] = removerows(tmin,'ind',issmall2);
%[ye_min,~] = removerows(ye_min,'ind',issmall2);


%diff2 = ye_max(1:end-1,2) - ye_min(2:end,2);

%issmall1 = find(diff2 < 0.455*std(Mu));
%issmall1 = find(diff2 < 0.7*std(Mu));
%issmall1 = find(diff2 < 0.51*std(Mu));
%issmall1 = find(diff2 < 0.495*std(Mu));
%issmall1 = find(diff2 < 0.615*std(Mu));

%[tmax,~] = removerows(tmax,'ind',issmall1);
%[ye_max,~] = removerows(ye_max,'ind',issmall1);

%issmall2 = issmall1+1;

%[issmall1 issmall2]
%[tmin,~] = removerows(tmin,'ind',issmall2);
%[ye_min,~] = removerows(ye_min,'ind',issmall2);


%diff1 = ye_max(1:end,2) - ye_min(1:end,2);

%issmall1 = find(diff1 < 0.5969*std(Mu));
%issmall1 = find(diff1 < 0.4*std(Mu));
%issmall1 = find(diff1 < 0.53*std(Mu));
%issmall1 = find(diff1 < 0.63*std(Mu));

%[tmax,~] = removerows(tmax,'ind',issmall1);
%[ye_max,~] = removerows(ye_max,'ind',issmall1);

% At the points where the diff is small, we search for min co2 at
% that point and delete the other point around that index.
%issmall2 = [];
%for q=1:length(issmall1)
%   g1 = issmall1(q);
%   g2 = issmall1(q)+1;
%   if g2 > length(ye_min)
%      g2 = length(ye_min);
%   end %if
%   new = find(ye_min(:,2) == max(ye_min(g1,2),ye_min(g2,2)));
%   if ismember(new,issmall2)
%      issmall2 = [issmall2; new+1];
%   else
%      issmall2 = [issmall2; new];
%   end %if
%end %for

%[issmall1 issmall2]
%[tmin,~] = removerows(tmin,'ind',issmall2);
%[ye_min,~] = removerows(ye_min,'ind',issmall2);


%diff2 = ye_max(1:end-1,2) - ye_min(2:end,2);

%issmall1 = find(diff2 < 0.615*std(Mu));
%issmall1 = find(diff2 < 0.715*std(Mu));

%[tmax,~] = removerows(tmax,'ind',issmall1);
%[ye_max,~] = removerows(ye_max,'ind',issmall1);

%issmall2 = issmall1+1;

%[issmall1 issmall2]
%[tmin,~] = removerows(tmin,'ind',issmall2);
%[ye_min,~] = removerows(ye_min,'ind',issmall2);


% Create two vectors specifying indices of tmin_co2 and tmax_co2
%tmin_co2 = [];
%tmax_co2 = [];
%for i = 1:length(tmin)
   %tmin_co2 = [tmin_co2 find(t==ceil(tmin(i)*10)/10)];
   %tmax_co2 = [tmax_co2 find(t==ceil(tmax(i)*10)/10)];
%   val1 = round(tmin(i),1);
%   val2 = round(tmax(i),1);
%   t1 = find(abs(t-val1) < 0.001);
%   t2 = find(abs(t-val2) < 0.001);
%   tmin_co2 = [tmin_co2 t1];
%   tmax_co2 = [tmax_co2 t2];
%end %for


% Here we determine the times (indices) of the max/min ice mass in each cycle
%maxI_k= [];  % The absolute max ice in cycle
%minI_k = [];  % The absolute min ice in cycle
%next_maxI_k = [];  % The max ice during cooling phase

%for k=1:length(tmin)-1
%   t1 = tmin_co2(k);
%   t2 = tmin_co2(k+1);
   %e1 = tmax_co2(k);
   %t1 = find(t==floor(tmin(k)));
   %t2 = find(t==floor(tmin(k+1)));
%   check = I(t1:t2);
%   mx = find(check==max(check));
%   mn = find(check==min(check));
   %while (i>tmin_co2(k) & i<tmin_co2(k+1))
   %   if I(i)>I(mx)
   %      mx = i;
   %   elseif I(i)<I(mn)
   %      mn = i;
   %   end %if
   %   i = i+1;
   %end %while
%   maxI_k = [maxI_k mx+t1];
%   minI_k = [minI_k mn+t1];
%end %for

%maxI_k = [maxI_k(1)];
%minI = iceMat(:,2);
%for k = 1:length(minI_k)-1
%   t1 = minI_k(k);
%   t2 = minI_k(k+1);
%   check = I(t1:t2);
%   mx = find(check==max(check));
%   maxI_k(k+1) = mx+t1;
%end %for

%for k=1:length(tmax_co2)-1
%   t1 = tmax_co2(k);
%   t2 = tmin_co2(k+1);
   %t1 = tmax(k);
   %t2 = tmin(k+1);
%   check = I(t1:t2);
%   mx = find(check==max(check));
   %while (i>=tmax_co2(k) & i<=tmin_co2(k+1))
   %   if I(i)>I(mx)
   %      mx = i;
   %   end %if
   %   i = i+1;
   %end %while
%   next_maxI_k = [next_maxI_k mx+tmin_co2(k)];
%end %for


figure
H1 = plot(time, signal,'k');
set(H1, 'LineWidth',1.5);
hold on;
H3 = plot(tmax(ind0), maxEO(ind0), 'k+');
H4 = plot(tmin(ind0), minEO(ind0), 'k+');

%hold on;
%plot(t,-I,'k-')
%plot(t(tmin_ice),-I(tmin_ice),'b.','MarkerSize',10)
%plot(t(tmax_ice),-I(tmax_ice),'r.','MarkerSize',10)


% Assigning output variables
%data = [t I Mu Theta];
%fullMat = [tmin_co2' tmax_co2'];
%fullMat = [tminfull1 ye(id1_2,:) tmaxfull1 ye(id1_1,:)];
%iceMat = [maxI_k' minI_k' next_maxI_k'];
%eventsMat = [tmin ye_min tmax ye_max];

%end %function
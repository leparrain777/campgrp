function [t,I,Mu,Theta,insol,IC] = readSM90_IC(run_num,num_runs)
% [t,I,Mu,Theta,insol,IC] = readSM90_IC(run_num,num_runs)
%
% This function reads SM90_ICRun(run_num)_(num_runs).txt text file and
% collects the model output created by sm90_IC_runs.m.
% Input:
%   descr := a string describing the forcing used for the run
%   run_num := the number of the run for initial conditions
%   num_runs := the number of initial conditions, or runs, in a particular call
%
% Output:
%   t := a column vector of the time steps from the run
%   I := a column vector of the Ice mass values from the run
%   Mu := a column vector of the CO2 values
%   Theta := a column vector of the mean ocean temp
%   insol := a column vector of the insolation/forcing signal for the run
%   IC := an array of the initial conditions for each run


filename = sprintf('SM90_ICRun%d_%d.txt', run_num,num_runs);
filepath = '~/campgrp/rjballes/ModelRuns/sm90/ICRuns/';   %need to adjust for details
file = strcat(filepath, filename);

fid = fopen(file, 'r');  %Need to edit from here on to sort output

for i = 1:18
    fgets(fid);
end % if

x = '%g';%'%20.16';
y = '';
for i=1:2
    y = sprintf('%s %s',y,x);
end


data1 = fscanf(fid, y, [2,5001]);

y = strcat(x, y);

data2 = fscanf(fid,y,[3,num_runs]);

y = strcat(x, y);

data3 = fscanf(fid, y, [4,inf]);

fclose(fid);

data1 = data1';
data2 = data2';
data3 = data3';

t = data3(:,1);
I = data3(:,2);
Mu = data3(:,3);
Theta = data3(:,4);
insol = data1(:,2);
IC = data2;


end % function
% This script runs the Unforced SM90 model for a set of varying initial conditions
addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
tspan = [0:0.1:500];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := p
%	param(2) := q
%	param(3) := r
% 	param(4) := s
%	param(5) := u
%	param(6) := v
%	param(7) := w
param = [2.5 0.6 0.2];

% Set up the changing parameters:
parT = [0:0.1:500]';
P = 0.1778*(parT/100-0.5).^3 - 0.0548*(parT/100 -0.5).^2 - 10.58*(parT/100 - 0.5) + 33;
%P = 0.1778*(parT/100 - 0.5).^3 - 0.0548*(parT/100 - 0.5).^2 - 10.58*(parT/100 - 0.5) + 34.25;
R = (9/5)*(parT/100-0.5) - 6;
%R = (9/5)*(parT/100 - 0.5) - 6;
S = 2.05*(parT/100 - 0.5) - 7;
W = -(6/5)*(parT/100 - 0.5) + 6;
%W = -(4.5/5)*(parT/100 - 0.5) + 6;

% Set up the stochastic terms:
Rt = [0:5000]';
Rx = -0.025 + 0.05.*rand(5001,1);
Ry = -0.025 + 0.05.*rand(5001,1);
Rz = -0.025 + 0.05.*rand(5001,1);

tic

for k=1:100
   % Setting an initial condition randomly
   x0 = 5-10*rand(1,3);
   
   % Simulation of Pleistocene departure model:
   [t,xprime] = ode45(@(t,x) sm90Unforced(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz),tspan,x0);
   
   % Re-dimensionalizing the results
   xprime(:,1) = xprime(:,1).*1.3;
   xprime(:,2) = xprime(:,2).*26.3;
   xprime(:,3) = xprime(:,3).*0.7;

   x = [3,Inf];

   for i=1:size(t)
      x(1,i) = xprime(i,1);
      x(2,i) = xprime(i,2);
      x(3,i) = xprime(i,3);
   end %for

   x = x';
   D = [0 x0;t x];
   
   % Saving data as a txt file
   %fileID = fopen('LaskarInsolSM90.txt','w');
   %fprintf(fileID,'%4.4f %4.4f %4.4f\n' ,x);
   %fclose(fileID);
   fileName = sprintf('SM90_Unforced_IC%d_Model.txt',k);
   filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/Unforced/';
   storeData(D,fileName,filePath,4);
   %storeData(nmodes,strcat('SM91_u=',num2str(uspan(k)),'_p=',num2str(pspan(l)),'EEMD_Data.txt'),'/nfsbigdata1/campgrp/agallati/sm91/IntegratedParamSearch_442016/Data/',size(nmodes,2));
   
end %for  

toc
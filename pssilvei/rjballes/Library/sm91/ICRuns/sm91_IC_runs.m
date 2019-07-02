% This script runs the SM91 model for a set of varying initial conditions
addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));
%addpath(genpath('/nfsbigdata1/campgrp/brknight/Lib/Matlab'));

% Flags to control which insolation forcing to use
Laskarflag = 0;
integInsolflag = 0;
noForceFlag = 1;
paperFlag = 1;
tunedFlag = 0;

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
tspan = [0:0.1:500];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := p
%	param(2) := q
%	param(3) := u
%	param(4) := v

if paperFlag
   param = [1.0 2.5 0.5 0.2];

elseif tunedFlag
   if LaskarFlag
      param = [1.0 2.5 1.55 0.2];
   end %if
   
   if integInsolFlag
      param = [1.14 2.5 1.36 0.2];
   end %if
   
elseif noForceFlag
   param = [1.0 2.5 0 0.2];

end %if

if Laskarflag
   %if noForceFlag
   %   descr = 'Unforced';
   %else
   descr = 'insolLaskar';
   %end %if
   
   % Insolation manipulation (normalization)
   [insolT,~,~,~,insol] = readLaskarAstronomical(0,5000);

   %insolT = insolT./10;
   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/std(insol);
   insol = insol(end:-1:1);

elseif integInsolflag
   %if noForceFlag
   %   descr = 'Unforced';
   %else
   descr = 'insolHuybersIntegrated';
   %end %if
   
   % Insolation manipulation (normalization)
   [insolT,insol] = integratedInsolation(0,5000);
   
   insolT = [0:0.1:500];
   
   insol = (insol - mean(insol))/std(insol);
   insol = insol(end:-1:1);
   insol = 0.54.*insol;

elseif noForceFlag
   descr = 'Unforced';
   % Set up the insolation forcing:
   % Set up averaged Summer insolation
   [insolT, insol] = readLaskarInsolation(7,5000,0);

   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/std(insol);
   insol = insol(end:-1:1);   

end %if

% Set up the changing parameters:
% Note: These changing parameters depend on the fact that the model runs for 5 million years.  
parT = [0:0.1:500]';
U = -35*(parT/100) + 425;
R = (2*2.6*10^(-5).*U - 3*3.6*10^(-8)*(U.^2) - 6.3*10^(-3)) / (1*10^(-4)) + 2;
S = (3*3.6*10^(-8).*U - 2.6*10^(-5)) / (sqrt(1*10^(-4)*3.6*10^(-8))); 

% Set up the stochastic terms:
Rt = [0:0.1:500]';
Rx = -0.025 + 0.05.*rand(5001,1);
Ry = -0.025 + 0.05.*rand(5001,1);
Rz = -0.025 + 0.05.*rand(5001,1);

tic

for k=1:150
   % Setting an initial condition randomly
   x0 = rand(1,3);
   
   % Simulation of Pleistocene departure model:
   [t,xprime] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0);
   
   % Re-dimensionalizing the results
   xprime(:,1) = xprime(:,1).*2.0;
   xprime(:,2) = xprime(:,2).*52.5;
   xprime(:,3) = xprime(:,3).*0.9;

   x = [3,Inf];

   for i=1:size(t)
      x(1,i) = xprime(i,1);
      x(2,i) = xprime(i,2);
      x(3,i) = xprime(i,3);
   end %for

   x = x';
   D = [0 x0;t x];
   
   % Saving data as a txt file
   fileName = sprintf('SM91_%s_IC%d_Model.txt',descr,k);
   filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/ICRuns/Unforced_p=1_u=0.5/08082018/';
   storeData(D,fileName,filePath,4);
   %storeData(nmodes,strcat('SM91_u=',num2str(uspan(k)),'_p=',num2str(pspan(l)),'EEMD_Data.txt'),'/nfsbigdata1/campgrp/agallati/sm91/IntegratedParamSearch_442016/Data/',size(nmodes,2));
   
end %for  

toc
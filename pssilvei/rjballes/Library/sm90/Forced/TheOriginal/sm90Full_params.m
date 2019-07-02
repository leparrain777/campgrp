% This is the paramters file for running Saltzman and Maasch's 1990 Model

% General Flags and runID
runID = 46;

% Flags to control which insolation forcing to use
Laskarflag = 1;
integInsolflag = 0;
solsticeFlag = 0;

paperFlag = 1;
tunedFlag = 0;

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
tspan = [0:0.1:500];

% Initial conditions are chosen arbitrarily based loosely on the Saltzman 1990 paper.
%x0 = [-1.0 0.1 1.0];
x0 = [0.001 0.001 0.001];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := q
%	param(2) := u
%	param(3) := v
% The rest of the parameters that show up in the model are dealt with as 
% functions of time to achieve the bifurcation or stochastic modeling.  
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

if Laskarflag
   descr = 'insolLaskar';
   % Insolation manipulation (normalization)
   [insolT,~,~,~,insol] = readLaskarAstronomical(0,5000);

   %insolT = insolT./10;
   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/(std(insol));
   insol = insol(end:-1:1);

elseif integInsolflag
   descr = 'insolHuybersIntegrated';
   % Insolation manipulation (normalization)
   [insolT,insol] = integratedInsolation(0,5000);
   
   insolT = [0:0.1:500];
   
   insol = (insol - mean(insol))/std(insol);
   insol = insol(end:-1:1);
   %insol = 0.54.*insol;

elseif solsticeFlag
   descr = 'solsticeLaskar';
   % Insolation manipulation (normalization)
   [insolT,insol] = readLaskarInsolation(7,5000,0);

   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/(std(insol));
   insol = insol(end:-1:1);

end %if

% Storing Data info
fileName = sprintf('SM90Full_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';

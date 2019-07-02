% Here lies the parameters involved in running Saltzman and Maasch's 1990 model.
%
% Date: 17 August 2014
% Author: Andrew Gallatin

% General flags and Run ID
runID = 1;
storeDataQ = 0;
plotFlag = 0;
printFlag = 0;

% Storing Data info
fileName = strcat('sm91out',num2str(runID),'.txt');
filePath = '/nfsbigdata1/campgrp/agallati/sm91/IntegratedParamTesting/Data/';

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
% Note: The tspan has to line up with the changing parameters to get
%        an accurate run of the model.
tspan = [0:0.1:500];
tphys = tspan(end:-1:1)';

% Initial conditions are chosen arbitrarily based loosely on the Saltzman 1990 paper.
x0 = [0 0 0];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := p
%	param(2) := q
%	param(3) := u
%	param(4) := v
% The rest of the parameters that show up in the model are dealt with as 
% functions of time to achieve the bifurcation or stochastic modelling.  
param = [0.9 2.5 1.55 0.2];

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

% Set up the insolation forcing:
% Set up averaged Summer insolation
[insolT, insol] = integratedInsolation(0,5000);

insolT = [0:0.1:500];

insol = (insol - mean(insol))/std(insol);
insol = insol(end:-1:1);
insol = 0.54*insol;

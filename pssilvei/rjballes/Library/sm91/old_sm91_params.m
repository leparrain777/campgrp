% Here lies the parameters involved in running Saltzman and Maasch's 1990 model.
%
% Date: 7 August 2018
% Author: Raymart Ballesteros

% General flags and Run ID
runID = 15;
storeDataQ = 0;
plotFlag = 0;
printFlag = 0;

% Flags for forcing
unforcedFlag = 0;
LaskarFlag = 1;
solsticeFlag = 0;
integInsolFlag = 0;
paperFlag = 1;
tunedFlag = 0;

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
% Note: The tspan has to line up with the changing parameters to get
%        an accurate run of the model.
tspan = [0:0.1:500];
tphys = tspan(end:-1:1)';

% Initial conditions are chosen arbitrarily based loosely on the Saltzman 1990 paper.
x0 = [0.001 0.001 0.001];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := p
%	param(2) := q
%	param(3) := u
%	param(4) := v
% The rest of the parameters that show up in the model are dealt with as 
% functions of time to achieve the bifurcation or stochastic modelling.
if unforcedFlag
   descr = 'unforced';
   param = [1.0 2.5 0 0.2];
   x0 = [0.001 0.001 0.001];
   
   % Set up the insolation forcing:
   % Set up averaged Summer insolation
   [insolT, insol] = readLaskarInsolation(7,5000,0);

   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/std(insol);
   insol = insol(end:-1:1);   
end %if

if paperFlag 
   param = [1.0 2.5 0.5 0.2];

elseif tunedFlag
   if LaskarFlag||solsticeFlag
      param = [1.0 2.5 0.5 0.2];
   end %if
   
   if integInsolFlag
      param = [1.14 2.5 1.14 0.2];
   end %if
  
end %if

if solsticeFlag
   descr = 'solsticeLaskar';
   % Set up the insolation forcing:
   % Set up averaged Summer insolation
   [insolT, insol] = readLaskarInsolation(7,5000,0);

   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/std(insol);
   insol = insol(end:-1:1);

elseif LaskarFlag
   descr = 'insolLaskar';
   % Insolation manipulation (normalization)
   [insolT,insol] = readLaskarAstronomical(0,5000);
   
   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/std(insol);
   insol = insol(end:-1:1);

elseif integInsolFlag
   descr = 'insolHuybersIntegrated';
   % Set up the insolation forcing:
   % Set up averaged Summer insolation
   [insolT, insol] = integratedInsolation(0,5000);

   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/std(insol);
   insol = insol(end:-1:1);
   insol = 0.54*insol;

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

% Storing Data info
fileName = sprintf('SM91_%s_%d_Model.txt',descr,runID);
%fileName2 = sprintf('SM91_%s_%d_FullModel.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/';
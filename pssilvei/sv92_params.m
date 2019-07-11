% This is the paramters file for running Saltzman and Maasch's 1991 Model

% General Flags and runID
runID = 77;

% Flags to control which insolation forcing to use
Laskarflag = 1;
integInsolflag = 0;
solsticeFlag = 0;
unforcedFlag = 0;

paperFlag = 0;
tunedFlag = 1;

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
tspan = [0:1e0:500e4];

% Initial conditions are chosen arbitrarily based loosely on the Saltzman 1990 paper.
%x0 = [-1.0 0.1 1.0];
x0 = [0.001 0.001 0.001 .001];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := p
%	param(2) := q
%	param(3) := u
%	param(4) := v
if paperFlag
   param = [1.0 2.5 0.5 0.2];

elseif tunedFlag
   if Laskarflag
      param = [1 2.5 0.599 0.2];
   end %if
   
   if integInsolflag
      param = [1.14 2.5 1.14 0.2];
   end %if
  
end %if

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

elseif unforcedFlag
   param = [1.4 2.5 0.9 1.0 0 0.2 0.5];
   x0 = [0.001 0.001 0.001];
   
   descr = 'unforced';
   % Insolation manipulation (normalization)
   [insolT,insol] = readLaskarInsolation(7,5000,0);
   
   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/(std(insol));
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
Rw =  -0.025 + 0.05.*rand(5001,1);

% Storing Data info
fileName = sprintf('SM91_%s_%d_Model.txt',descr,runID);
%fileName2 = sprintf('SM91_%s_%d_FullModel.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/';
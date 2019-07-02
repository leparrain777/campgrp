% This is the paramters file for running Saltzman and Maasch's 1990 Model

% General Flags and runID
runID = 115;

% Flags to control which insolation forcing to use
Laskarflag = 1;
integInsolflag = 0;
solsticeFlag = 0;
unforcedFlag = 0;

paperFlag = 0;
tunedFlag = 1;

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
tspan = [0:0.1:500];

% Initial conditions are chosen arbitrarily based loosely on the Saltzman 1990 paper.
%x0 = [-1.0 0.1 1.0];
x0 = [0.001 0.001 0.001];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := p
%	param(2) := q
%	param(3) := r
% 	param(4) := s
%	param(5) := u
%	param(6) := v
%	param(7) := w
if paperFlag
   param = [1.0 2.5 0.9 1.0 0.6 0.2 0.5];

elseif tunedFlag
   if Laskarflag
      param = [1.0 2.5 0.9 1.0 0.4 0.2 0.5];
   end %if
   
   if integInsolflag
      %param = [1.14 2.5 0.9 1.0 1.36 0.2 0.5];
      param = [1.2 2.5 0.9 1.0 0.6 0.2 0.5];
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

% Storing Data info
fileName = sprintf('SM90_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';
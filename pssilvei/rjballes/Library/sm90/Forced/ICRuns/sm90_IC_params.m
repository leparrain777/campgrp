% This script contains the parameters for running the SM90
% model with different initial conditions; which are chosen randomly.

run_num = 5;

% Flags to control which insolation forcing to use
LaskarFlag = 0;
solsticeFlag = 1;
integInsolFlag = 0;
unforcedFlag = 0;

paperFlag = 0;
tunedFlag = 1;

% Setting the number of runs to do
num_runs = 200;

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

if paperFlag
   param = [1.0 2.5 0.9 1.0 0.6 0.2 0.5];

elseif tunedFlag
   if LaskarFlag || solsticeFlag
      param = [1.0 2.5 0.9 1.0 1.55 0.2 0.5];
   end %if
   
   if integInsolFlag
      param = [1.14 2.5 0.9 1.0 1.36 0.2 0.5];
   end %if
   
elseif unforcedFlag
   param = [1.0 2.5 0.9 1.0 0 0.2 0.5];
   
end %if


if LaskarFlag
   descr = 'insolLaskar';
   
   % Insolation manipulation (normalization)
   [insolT,~,~,~,insol] = readLaskarAstronomical(0,5000);
      
elseif integInsolFlag
   descr = 'insolHuybersIntegrated';
   
   % Insolation manipulation (normalization)
   [insolT,insol] = integratedInsolation(0,5000);
   
   % Making sure the insol vectors are column vectors
   insol = insol';
   
elseif solsticeFlag
   descr = 'solsticeLaskar';
   
   % Insolation manipulation (normalization)
   [insolT,insol] = readLaskarInsolation(7,5000,0);

elseif unforcedFlag
   descr = 'Unforced';
   % Insolation manipulation (normalization)
   [insolT,insol] = readLaskarInsolation(7,5000,0);
   
end %if

%insolT = insolT./10;
insolT = [0:0.1:500];

insol = (insol - mean(insol))/std(insol);
insol = insol(end:-1:1);


if integInsolFlag
   insol = 0.54.*insol;
end %if
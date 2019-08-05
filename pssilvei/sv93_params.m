% This is the paramters file for running Saltzman and Maasch's 1991 Model
function params = sv93_params(varargin)
if nargin < 1
    varargin{1} = 0;
end
% General Flags and runID
runID = 77;

format long e
% Flags to control which insolation forcing to use
Laskarflag = 1;
integInsolflag = 0;
solsticeFlag = 0;
unforcedFlag = 0;

paperFlag = 0;
tunedFlag = 1;


params.massscale = 1e19; %kg

params.co2scale = 1e0; %ppm

params.distancescale = 1e0; %meters

params.tempscale = 1e0; % degrees Celcius

params.timescale = 1000; %years

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
params.tspan = [0:1*1e3/params.timescale:5e6/params.timescale];




% Initial conditions are chosen arbitrarily based loosely on the Saltzman 1990 paper.
%params.x0 = [-1.0 0.1 1.0];
params.x0 = [.001 .001 .001 .001];

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
   params.insolT = [0:1000/params.timescale:5e6/params.timescale];

   params.insol = (insol - mean(insol))/(std(insol));
   params.insol = params.insol(end:-1:1);

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
   params.x0 = [0.001 0.001 0.001];
   
   descr = 'unforced';
   % Insolation manipulation (normalization)
   [insolT,insol] = readLaskarInsolation(7,5000,0);
   
   insolT = [0:0.1:500];

   insol = (insol - mean(insol))/(std(insol));
   insol = insol(end:-1:1);

end %if

params.Rnotstar = 452;
params.Rnot = params.Rnotstar;

params.omegapsi = 0;

params.omegamu = 0;

params.omegatheta = 0;

params.Jpsi = 2.77e-18 / params.distancescale * params.massscale;

params.Jtheta = -1e0 / params.distancescale * params.tempscale;

if varargin{1} == 1
    params.alphanotstar = 2.0e15*params.timescale / params.massscale;
else
    params.alphanotstar = 2.275e15*params.timescale / params.massscale;
end

if varargin{1} == 1
    params.phitwo = 8e14 / params.massscale * params.tempscale * params.timescale;
else
    params.phitwo = 8e14 / params.massscale * params.tempscale * params.timescale;
end

params.alphathree = 1e-4 * params.timescale;

params.alphafour = 20e0 * params.timescale / params.distancescale;

if varargin{1} == 1
    params.Znot = 3.0e2 / params.distancescale;
else
    params.Znot = 4.75e2 / params.distancescale;
end

if varargin{1} == 1
    params.B = 0e0 / params.tempscale;
else
    params.B = 11e0 / params.tempscale;
end
if varargin{1} == 1
    params.mutildestar = 0e2 / params.co2scale;
else
    params.mutildestar = 2.53e2 / params.co2scale;
end

params.kappamu = 0e-2 / params.tempscale * params.co2scale;

if varargin{1} == 1
    params.kappaR = 0.1e0 / params.tempscale / params.distancescale^2;
else
    params.kappaR = 0.1e0 / params.tempscale / params.distancescale^2;
end

if varargin{1} == 1
    params.kappatheta = 0e0; %unitless
else
    params.kappatheta = .5e0; %unitless
end

params.kappapsi = 0e-19 / params.tempscale * params.massscale;

params.epsilontwo = 1/(3.0e3) * params.timescale;

params.zeta = 1.0e0 / nthroot(params.distancescale,2);

if varargin{1} == 1
    params.betatwo = 0e-3 * params.timescale;
else
    params.betatwo = 6.12e-3 * params.timescale;
end

if varargin{1} == 1
    params.betathree = 0e-5 * params.co2scale * params.timescale;
else
    params.betathree = 2.6e-5 * params.co2scale * params.timescale;
end

if varargin{1} == 1
    params.betafour = 0e-8 * params.co2scale^2 * params.timescale;
else
    params.betafour = 3.6e-8 * params.co2scale^2 * params.timescale;
end

if varargin{1} == 1
    params.betafive = 0e-3 / params.co2scale * params.tempscale * params.timescale;
else
    params.betafive = 5.6e-3 / params.co2scale * params.tempscale * params.timescale;
end

if varargin{1} == 1
    params.gammanot = 0e-4 / params.tempscale * params.timescale;
else
    params.gammanot = 2.4e-4 / params.tempscale * params.timescale;
end

if varargin{1} == 1
    params.gammatwo = 1.2e-23 / params.tempscale * params.massscale * params.timescale;
else
    params.gammatwo = 1.2e-23 / params.tempscale * params.massscale * params.timescale;
end

if varargin{1} ==  1
    params.gammathree = 0e-4 * params.timescale;
else
     params.gammathree = 2.5e-4 * params.timescale;
end

if varargin{1} == 1
    params.mutildedot = (0 / 1e6) / params.co2scale * params.timescale;
else
    params.mutildedot = (20.0 / 1e6) / params.co2scale * params.timescale;
end

params.omegamu = 0;

params.omegatheta = 0;

params.omegaI = 0;

params.epsilonone = params.epsilontwo * 1/3; 

params.zeta= 1 / nthroot(params.distancescale,2); 

params.icedensity= 917 / params.massscale;

params.eone= params.epsilonone * nthroot(params.zeta^4/(params.icedensity * 2),5);

params.standarddeviationmultiplier = 1;
load('july60northinsolationraw.mat', 'unnamed')
params.Rprime = interp1(params.insolT,unnamed-mean(unnamed),'spline','pp');

end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set up the changing parameters:
% Note: These changing parameters depend on the fact that the model runs for 5 million years.
% parT = [0:1:5000]';
% U = -35*(parT/100) + 425;
% R = (2*2.6*10^(-5).*U - 3*3.6*10^(-8)*(U.^2) - 6.3*10^(-3)) / (1*10^(-4)) + 2;
% S = (3*3.6*10^(-8).*U - 2.6*10^(-5)) / (sqrt(1*10^(-4)*3.6*10^(-8))); 
% 
% % Set up the stochastic terms:
% Rt = [0:.1:500]';
% Rx = -0.025 + 0.05.*rand(5001,1);
% Ry = -0.025 + 0.05.*rand(5001,1);
% Rz = -0.025 + 0.05.*rand(5001,1);
% Rw =  -0.025 + 0.05.*rand(5001,1);

% Storing Data info
%fileName = sprintf('SM91_%s_%d_Model.txt',descr,runID);
%fileName2 = sprintf('SM91_%s_%d_FullModel.txt',descr,runID);
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/';
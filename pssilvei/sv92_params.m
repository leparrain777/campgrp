% This is the paramters file for running Saltzman and Maasch's 1991 Model
function params = sv92_params(varargin)
% General Flags and runID
disp(varargin{1})
runID = 77;
if nargin < 1
    varargin{1} = 0;
end
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
params.x0 = [.001 .001 0 0];

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

%18 only
%setting the sensitivity to high latitude surface temp constant one aka b
params.b = 18 / params.tempscale ;
%make b a short name for snsitivivityhighlatsurfacetempone

%4e-3 only
%setting the sensitivity to high latitude surface temp constant two aka c
params.c = 4e-3 * params.co2scale ;
%make c a short name for snsitivivityhighlatsurfacetemptwo



%the current value of high latitude radiation

%externalforcingcarbondioxide=[1 2 3 4];
%the forcing signal on carbon dioxid for each timestep of the run, should
%be calculated by something else, this is a placeholder

%externalforcingoceantemp=[1 2 3 4];
%the forcing signal on ocean temperature for each timestep of the run, should
%be calculated by something else, this is a placeholder
if varargin{1} == 1
    params.alphaone= params.timescale*13.7e15 / params.massscale; %13.7e15 or 15.4e15
elseif varargin{1} == 90
    params.alphaone= params.timescale*17e15 / params.massscale; %13.7e15 or 15.4e15
elseif varargin{1} == 91
    params.alphaone= params.timescale*14e15 / params.massscale; %13.7e15 or 15.4e15
else 
    params.alphaone= params.timescale*15.4e15 / params.massscale; %13.7e15 or 15.4e15
end

if varargin{1} == 1
    params.alphatwo= params.timescale*7e15 / params.massscale; %7.0e15 or 9.4e15
elseif varargin{1} == 90
    params.alphatwo= params.timescale*13e15 / params.massscale; %7.0e15 or 9.4e15
else
    params.alphatwo= params.timescale*9.4e15 / params.massscale; %7.0e15 or 9.4e15
end


params.alphathree= params.timescale*1.0e-4; %1.0e-4

if varargin{1} == 90|| varargin{1} ==91|| varargin{1} ==21|| varargin{1} ==22|| varargin{1} ==23
    params.alphafour= params.timescale*0 / params.distancescale; %20 or 0 aka alphafour
else
    params.alphafour= params.timescale*20 / params.distancescale; %20 or 0 aka alphafour
end
%setting the rate of ice destruction
%setting alpha rate constants
if varargin{1} == 90|| varargin{1} ==1
    params.bone= params.timescale*0e-4; %1.3e-4 or 0 
else
    params.bone= params.timescale*1.3e-4; %1.3e-4 or 0 
end

if varargin{1} == 90|| varargin{1} ==1
    params.btwo= params.timescale*0e-6 * params.co2scale; % 1.1e-6 or 0
else
    params.btwo= params.timescale*1.1e-6 * params.co2scale; % 1.1e-6 or 0
end
if varargin{1} == 90|| varargin{1} ==1
    params.bthree= params.timescale*0e-8 * params.co2scale^2; % 0 or 3.6e-8
else
    params.bthree= params.timescale*3.6e-8 * params.co2scale^2; % 0 or 3.6e-8
end
if varargin{1} == 90|| varargin{1} ==1
    params.bfour= params.timescale*0e-3 / params.co2scale * params.tempscale; %0 or 5.6e-3
else
    params.bfour= params.timescale*5.6e-3 / params.co2scale * params.tempscale; %0 or 5.6e-3
end
%setting b constants
if varargin{1} == 1
    params.gammaone= params.timescale*0e-3 / params.tempscale; %1.9e-3 or 0
    params.gammatwo= params.timescale*0e-23 / params.tempscale * params.massscale; %0 or 1.2e-23
    params.gammathree= params.timescale*0e-4; %0 or 2.5e-4
else
    params.gammaone= params.timescale*1.9e-3 / params.tempscale; %1.9e-3 or 0
    params.gammatwo= params.timescale*1.2e-23 / params.tempscale * params.massscale; %0 or 1.2e-23
    params.gammathree= params.timescale*2.5e-4; %0 or 2.5e-4
end

%setting gamma rate constants

if varargin{1} == 91
    params.kappaR= 1.7e-2 / params.distancescale^2; %.7e-2 or 1.1e-2 or 1.7e-2
elseif varargin{1} == 1
    params.kappaR= .7e-2 / params.distancescale^2; %.7e-2 or 1.1e-2 or 1.7e-2
else
    params.kappaR= 1.1e-2 / params.distancescale^2; %.7e-2 or 1.1e-2 or 1.7e-2
end

if varargin{1} == 90
    params.kappatheta= 3.3e-2 * params.tempscale; %3.3e-2 or 4.4e-2
else
    params.kappatheta= 4.4e-2 * params.tempscale; %3.3e-2 or 4.4e-2
end
%setting kappa constants

if varargin{1} == 1
    params.Kmu= 2e-18 * params.massscale / params.co2scale;
    params.Ktheta= 4.8e-20 * params.massscale / params.tempscale;
else
    params.Kmu= 0 * params.massscale / params.co2scale;
    params.Ktheta= 0 * params.massscale / params.tempscale;
end
%setting K constants for pollard paper emulation
if varargin{1} == 1
    params.munotstar= 250 / params.co2scale; %253 or 250 or 215
elseif varargin{1} == 90
    params.munotstar= 215 / params.co2scale; %253 or 250 or 215
else
    params.munotstar= 253 / params.co2scale; %253 or 250 or 215
end

if varargin{1} == 90
    params.thetanotstar= 4.8 / params.tempscale; %5.2 or 4.8
else
    params.thetanotstar= 5.2 / params.tempscale; %5.2 or 4.8
end
%setting current atmosphere averages
if varargin{1} == 90|| varargin{1} ==91
    params.Istar= 3.3e19 / params.massscale; %3e19 or 3.3e19
else
    params.Istar= 3e19 / params.massscale; %3e19 or 3.3e19
end
%setting the present value of global ice mass

if varargin{1} == 90|| varargin{1} ==91|| varargin{1} ==21|| varargin{1} ==22|| varargin{1} ==23
    params.Z= 0e2 / params.distancescale; %4e2 or 0 or 6.4e2
elseif varargin{1} == 1|| varargin{1} ==31
    params.Z= 4e2 / params.distancescale; %4e2 or 0 or 6.4e2
else 
    params.Z= 6.4e2 / params.distancescale; %4e2 or 0 or 6.4e2
end
%Znot=Znotstar;
%setting the baseline value of tectonic crust equilibrium to be the modern tectonic crust equilibrium?

if varargin{1} == 90|| varargin{1} ==91
    params.epsilontwo= 0; %1/(3e3) or 1/(30e3)
elseif varargin{1} == 1|| varargin{1} ==21|| varargin{1} ==31
    params.epsilontwo= params.timescale*1/(30e3); %1/(3e3) or 1/(30e3)
else
    params.epsilontwo= params.timescale*1/(3e3); %1/(3e3) or 1/(30e3)
end
%setting epsilon 2. It is often stated by its inverse in the paper.

params.epsilonone = params.epsilontwo * 1/3; %this should be epsilonone *1/3 as they use a 
%constant in the paper for epsilon one divided by epsilon two with value one third

if varargin{1} == 90|| varargin{1} ==91
    params.zeta= 0 ; %1 or .5
elseif varargin{1} == 23
    params.zeta= .5 / nthroot(params.distancescale,2); %1 or .5
else
    params.zeta= 1 / nthroot(params.distancescale,2); %1 or .5
end


%setting zeta constant

params.icedensity= params.distancescale^3*917 / params.massscale; %917 given in paper
%set ice density, seen as rho with an i subscript

params.n= 2; % 2 in paper
%set number of ice sheets to consider 

params.omegamu = 0; %0 in the paper
%set the forcing term for mu

params.omegatheta = 0; %0 in the paper
%set the forcing term for theta

params.omegaI = 0; %0 in paper when not explicityly stated otherwise
%set the forcing term for I/phi

format long e
%set our outputs to have some more decimals and a seperate magnitude
%multiplier
load('july60northinsolationraw.mat', 'unnamed')

params.munot = params.munotstar; %
%look up
params.thetanot = params.thetanotstar;

params.Rstar = 452;

%make Rstar a short name for high latitude radiation present value
%look up


params.Rnot = mean(unnamed);

params.Rnotstar = params.Rnot-params.Rstar;
%look up
%setting some placeholder values for testing to be replaced later

%gammanot = gammatwo * psinot; %= gammatwo * alphanot / alphathree as phinot = alphnot / alphathree if muprime = thetaprime = 0;

%params.alphatwo = .75;

params.alphanot = params.alphaone - params.alphatwo * (tanh(params.c * params.munot) + params.kappatheta * params.thetanot + params.kappaR * .438 *(params.Rnot - params.Rstar)) - params.alphathree * params.Istar;
%computes the value of alphanot from other items that are given
disp(params.alphanot);
params.psinot = params.alphanot/params.alphathree;
%params.psinot = 5.33;
disp(params.psinot);
%params.gammanot = params.gammaone - params.gammatwo * params.Istar - params.gammathree * params.thetanot;
params.gammanot = params.gammatwo * params.alphanot / params.alphathree;

params.eone= params.epsilonone * nthroot(params.zeta^4/(params.icedensity * params.n),5);
%computes the value of eone from other items that are given

% Insolation:
params.standarddeviationmultiplier = 1;

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
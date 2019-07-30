% This is the paramters file for running Saltzman and Maasch's 1991 Model
function params = sv92_params(override)
% General Flags and runID
runID = 77;

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

params.alphaone= params.timescale*15.4e15 / params.massscale; %13.7e15 or 15.4e15
params.alphatwo= params.timescale*9.4e15 / params.massscale; %7.0e15 or 9.4e15
params.alphathree= params.timescale*1.0e-4; %1.0e-4
params.alphafour= params.timescale*20 / params.distancescale; %20 or 0 aka alphafour
%setting the rate of ice destruction
%setting alpha rate constants

params.bone= params.timescale*1.3e-4; %1.3e-4 or 0 
params.btwo= params.timescale*1.1e-6 * params.co2scale; % 1.1e-6 or 0
params.bthree= params.timescale*3.6e-8 * params.co2scale^2; % 0 or 3.6e-8
params.bfour= params.timescale*5.6e-3 / params.co2scale * params.tempscale; %0 or 5.6e-3
%setting b constants

params.gammaone= params.timescale*1.9e-3 / params.tempscale; %1.9e-3 or 0
params.gammatwo= params.timescale*1.2e-23 / params.tempscale * params.massscale; %0 or 1.2e-23
params.gammathree= params.timescale*2.5e-4; %0 or 2.5e-4
%setting gamma rate constants

params.kappaR= 1.1e-2 / params.distancescale^2; %.7e-2 or 1.1e-2 or 1.7e-2
params.kappatheta= 4.4e-2 * params.tempscale; %3.3e-2 or 4.4e-2
%setting kappa constants

params.Kmu= 0 * params.massscale / params.co2scale;%2e-18; %2e-18 or possibly 0?
params.Ktheta= 0 * params.massscale / params.tempscale;%4.8e-20; %4.8e-20 or possibly 0?
%setting K constants for pollard paper emulation

params.munotstar= 253 / params.co2scale; %253 or 250 or 215
params.thetanotstar= 5.2 / params.tempscale; %5.2 or 4.8
%setting current atmosphere averages

params.Istar= 3e19 / params.massscale; %3e19 or 3.3e19
%setting the present value of global ice mass


params.Z= 4e2 / params.distancescale; %4e2 or 0 or 6.4e2
%Znot=Znotstar;
%setting the baseline value of tectonic crust equilibrium to be the modern tectonic crust equilibrium?

params.epsilontwo= params.timescale*1/(30e3); %1/(3e3) or 1/(30e3)
%setting epsilon 2. It is often stated by its inverse in the paper.

params.epsilonone = params.epsilontwo * 1/3; %this should be epsilonone *1/3 as they use a 
%constant in the paper for epsilon one divided by epsilon two with value one third

params.zeta= 1 / nthroot(params.distancescale,2); %1 or .5
%setting zeta constant

params.icedensity= 917 / params.massscale; %917 given in paper
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


params.munot = params.munotstar; %
%look up
params.thetanot = params.thetanotstar;

if nargin > 0
    params.Rstar = override; % NOTE: this is wrong, it is a parameter
else
    params.Rstar = 500;
end
%make Rstar a short name for high latitude radiation present value
%look up

params.Rnotstar = 452;
params.Rnot = params.Rnotstar;
%look up
%setting some placeholder values for testing to be replaced later
params.gammanot = params.gammaone - params.gammatwo * params.Istar - params.gammathree * params.thetanot;
%gammanot = gammatwo * psinot; %= gammatwo * alphanot / alphathree as phinot = alphnot / alphathree if muprime = thetaprime = 0;

params.psinot = params.gammanot/params.gammatwo; 

params.alphanot = params.alphaone - params.alphatwo * tanh(params.c * params.munot) + params.kappatheta * params.thetanot + params.kappaR * (params.Rnot - params.Rstar) - params.alphathree * params.Istar;
%computes the value of alphanot from other items that are given



params.eone= params.epsilonone * nthroot(params.zeta^4/(params.icedensity * params.n),5);
%computes the value of eone from other items that are given

% Insolation:
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
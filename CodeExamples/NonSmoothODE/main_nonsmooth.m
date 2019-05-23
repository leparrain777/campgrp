%
%	    Main for a Non-smooth ODE Integration Example
%
clear all;
close all;
%
%       Run script to initialize all parameters & initial conditions
%	edit params.m to change the run
params
%
options = odeset('Events',@testodeevents);   % prep ode solver for "Events" option
%			uses user-supplied function "testodeevents"
%
%	Setup "while loop"
t = [];         % initialize a full time array
y = [];         % initialize a full solution array
tspan = tspan0; % initialize "loop" time span
ic = ic0;       % initialize "loop" initial condition
%
tn = [tspan0(1):1:tspan0(end)];
neps = randn([size(tn),1])*.3;
%
%	Integrate until final time is reached
while (tspan(1) < tspan(2))
  %[tj yj] = ode45(@testode, tspan, ic, options, p);
  [tj yj] = ode45(@(t,y) testode(t,y,p), tspan, ic, options);
% Integrate until event is reached using user-supplied function "testode"
  state = mod(state+1,2); % switch state
  p(1) = state;          % save to parameter array
  t = cat(1, t, tj(2:end));    % save integration times to full time array
  y = cat(1, y, yj(2:end));    % save integration solution values to full solution array
  [t(end), y(end)],
  tspan(1) = t(end);      % reset initial time to latest event time
  ic = y(end);           % reset initial condition to last solution value
end % while

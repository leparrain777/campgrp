% This is a sample script to show how to use ode45 with
% passing parameters and time-dependent forcing terms

% Declare tspan for ode45:
tspan = [0 50];   % or tspan = [0:0.1:50]
		  % to specify the time step output from ode45
		  % E.g. [0 0.1 0.2 ... 49.9 50]

% Declare initial condition: x(0) = 1
xinit = 1;

% Declare parameters
param = [10 0.5];    % this corresponds to p = 2 & q = 5
	             % see ode.m for more information.
r = 0.3;
s = 0.1;

% If you wanted to evolve parameters over time, 
% use the same idea as the forcing term.

% Set up the forcing term:
ftime = [0:50]';    % Declare the list of times which f is evaluated
f = ftime.^2;       % Declare f and make the list of values.  
	            % Here, f = t^2

% Run ode45 and pass parameters/forcing terms:
% The first input to ode45 is the differential equation
% Note: when your diff eq has more than 3 inputs (t,x,parameters) you need to specify
% 	which variables ode45 needs to evolve.
%		E.g. the (t,x) before the call to your ode function.
% The other parameters and forcing terms you pass as variables
% like you would with any other function.
% The last two inputs of ode45 are tspan and xinit.
[t,x] = ode45(@(t,x) ode(t,x,param,r,s,ftime,f),tspan,xinit);

% plot the solution:
plot(t,x)

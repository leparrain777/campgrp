%
%	Parameter file for nonSmotth ODE Integration
%
%
runnum = 102;  %run id number
%
state = 1;  % 0 - growth, 1- decay
a0 = .3;    % parameters of growth state
b0 = 0.1;
a1 = -0.7;  % parameters of decay state
b1 = 0.1;
ymax = 5;   % upper threshold: growth to decay transition
ymin = 1.5; % lower threshold: decay to growth transition
p = [state a0 b0 a1 b1 ymax ymin];    % store in a parameter array
%
tspan0 = [0 50];  % full time span
ic0 = 4.1;        % true initial condition

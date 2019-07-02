% Saltzman 1990 model without orbital forcing and with varying parameters.

% Note:
% x(1) is continental ice mass
% x(2) is CO2 concentration in the atmosphere
% x(3) is deep ocean temperature
%
% This is a nondimensionalized model.

% Date: 30 June 2014
% Author: Andrew Gallatin

function xprime = sm90(t,x,param,insolT,insol);

% Parameters
p = param(1);
q = param(2);
r = param(3);
s = param(4);
u = param(5);
v = param(6);
w = param(7);

% No Insolation (Normalized July Insolation curve at 65 degrees N):
f = interp1(insolT,insol,t);

% Stochastic Terms:
Wx = 0;
Wy = 0;
Wz = 0;

xprime = [
 -x(1) - x(2) - v*x(3) - u*f + Wx ;
 -p*x(3) + r*x(2) + s*(x(3)^2) - w*x(2)*x(3) - (x(3)^2)*x(2) + Wy ;
 -q*(x(1)+x(3)) + Wz
];

end

% Saltzman 1990 model without orbital forcing and with varying parameters.

% Note:
% x(1) is continental ice mass
% x(2) is CO2 concentration in the atmosphere
% x(3) is deep ocean temperature
%
% This is a nondimensionalized model.

% Date: 30 June 2014
% Author: Andrew Gallatin

function xprime = sm90(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz,insolT,insol);

% Parameters
p = interp1(parT,P,t);
q = param(1);
r = interp1(parT,R,t);
s = interp1(parT,S,t);
u = param(2);
v = param(3);
w = interp1(parT,W,t);

% Insolation (Normalized July Insolation curve at 65 degrees N):
f = interp1(insolT,insol,t);

% Stochastic Terms:
Wx = interp1(Rt,Rx,t);
Wy = interp1(Rt,Ry,t);
Wz = interp1(Rt,Rz,t);

xprime = [
 -x(1) - x(2) - v*x(3) - u*f + Wx ;
 -p*x(3) + r*x(2) + s*(x(3)^2) - w*x(2)*x(3) - (x(3)^2)*x(2) + Wy ;
 -q*(x(1)+x(3)) + Wz
];

end

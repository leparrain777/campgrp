% Saltzman 1990 model without orbital forcing and with varying parameters.

% Note:
% x(1) is continental ice mass
% x(2) is CO2 concentration in the atmosphere
% x(3) is deep ocean temperature
%
% This is a nondimensionalized model.

% Date: 8 July  2014
% Author: Andrew Gallatin

function diffmodel = sm90(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz);

% p, r, s, and w are dictated by equations loosely defined in Saltzman 1990.
%p = 0.1778*(t/100)^3 - 0.0548*(t/100)^2 - 10.58*(t/100) + 34;
%q = param(1);
%r = (9/5)*(t/100) - 6;
%s = 2.1*(t/100) - 7;
%u = param(2);
%v = param(3);
%w = -(4.8/5)*(t/100) + 6;

%p = interp1(parT,P,t);
q = param(1);
%r = interp1(parT,R,t);
%s = interp1(parT,S,t);
u = param(2);
v = param(3);
%w = interp1(parT,W,t);
% Special solution (from Saltzman 1990 paper)
p = 1;
r = 0.9;
s = 1.0;
w = 0.5;

% No Insolation (Normalized July Insolation curve at 65 degrees N):
f = 0;

% Stochastic Terms:
% With stochastic forcing
%Wx = interp1(Rt,Rx,t);
%Wy = interp1(Rt,Ry,t);
%Wz = interp1(Rt,Rz,t);
% No stochastic forcing
Wx = 0;
Wy = 0;
Wz = 0;

% Set up and express the model:
X = x(1);
Y = x(2);
Z = x(3);

Xprime = -X - Y - v*Z - u*f + Wx;
Yprime = -p*Z + r*Y + s*(Z^2) - w*Y*Z - (Z^2)*Y + Wy;
Zprime = -q*(X + Z) + Wz;

% sm90 Model:
diffmodel = [
   Xprime ; 
   Yprime ;
   Zprime 
];

end

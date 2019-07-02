% Note: 
% x(1) (X) is continental ice mass
% x(2) (Y) is atmospheric concentration of CO2
% x(3) (Z) is deep ocean temperature
%
% This is a nondimensionalized model.

% Date: 17 July 2014
% Author: Andrew Gallatin

function xprime = sm91(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol);

p = param(1);
q = param(2);
u = param(3);
v = param(4);

r = interp1(parT,R,t,'pchip');
s = interp1(parT,S,t,'pchip');

% Insolation:
f = interp1(insolT,insol,t,'pchip');

% Stochastic Terms:
Wx = interp1(Rt,Rx,t,'pchip');
Wy = interp1(Rt,Ry,t,'pchip');
Wz = interp1(Rt,Rz,t,'pchip');

% Set up of the model
X = x(1);
Y = x(2);
Z = x(3);

Xprime = -X - Y - v*Z - u*f + Wx;
Yprime = -p*Z + r*Y - s*Y^2 - Y^3 + Wy;
Zprime = -q*(X + Z) + Wz;

xprime = [
   Xprime ;
   Yprime ;
   Zprime
];

end

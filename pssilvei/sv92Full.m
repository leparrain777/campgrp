% Note: 
% x(1) (X) is continental ice mass
% x(2) (Y) is atmospheric concentration of CO2
% x(3) (Z) is deep ocean temperature
%
% This is a nondimensionalized model.

% Date: 17 July 2014
% Author: Andrew Gallatin

%need co2events and tectonic

function xprime = sm92(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,Rw,insolT,insol);

p = param(1);
q = param(2);
u = param(3);
v = param(4);

%r = interp1(parT,R,t,'pchip');
%s = interp1(parT,S,t,'pchip');
r = 1.3;
s = 0.6;

% Insolation:
f = interp1(insolT,insol,t,'spline');

% Stochastic Terms:
%Wx = interp1(Rt,Rx,t,'pchip');
%Wy = interp1(Rt,Ry,t,'pchip');
%Wz = interp1(Rt,Rz,t,'pchip');
%Ww = interp1(Rt,Rw,t,'pchip');
Wx = 0;
Wy = 0;
Wz = 0;
Ww = 0;

% Set up of the model
X = x(1);
Y = x(2);
Z = x(3);
W = x(4);

fmultiplier = 1e1;

Xprime = (-400+f*fmultiplier).*-1.034e16-Y.*3.76e15-X.*(1.0./1.0e2)-Z.*4.136e16+((nthroot(X.*3.635041802980734e-4+1.09051254089422e16,5).*(1.0./3.0)<W)&(4.0e2<W)).*((X+3.0e19).*1.0./nthroot(X.*3.635041802980734e-4+1.09051254089422e16,5).*-2.0e3)-4.596964691091411e18;
Yprime = Z.*(-1.4e1./2.5e1)-Y.*(Y.*1.1e-4+Y.^2.*3.6e-6-1.3e1./1.0e3);
Zprime = X.*(-1.2e-21)-Z.*(1.0./4.0e1)-1.2e-2;
Wprime = W.*(-1.0./3.0e2)+nthroot(X+3.0e19,5).*2.279603801209383e-4;



xprime = [
   Xprime ;
   Yprime ;
   Zprime ;
   Wprime
];

end
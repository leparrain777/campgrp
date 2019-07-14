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
f = interp1(insolT,insol,t,'linear');

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

fmultiplier = 40;

Xprime = f*fmultiplier.*-7.7e17-Y.*2.8e17-X-Z.*3.08e18+((nthroot(X.*3.635041802980734e-4+1.09051254089422e16,5).*(1.0./3.0)<W)&(4.0<W)).*((X+3.0e19).*1.0./nthroot(X.*3.635041802980734e-4+1.09051254089422e16,5).*-2.0e5)-3.353271578472327e20;
Yprime = W.*(-1.0./3.0e2)+nthroot(X+3.0e19,5).*2.279603801209383e-4;
Zprime = Z.*-5.6e1-Y.*(Y.*(1.1e1./1.0e3)+Y.^2.*3.6e-4-1.3e1./1.0e1);
Wprime = X.*(-1.2e-19)-Z.*(5.0./2.0)-1.2;
%f.*-7.7e17-Y.*2.8e17-X-Z.*3.08e18+(((X.*3.635041802980734e-4+1.09051254089422e16).^(1.0./5.0).*(1.0./3.0)<W)&(4.0<W)).*((X+3.0e19).*1.0./(X.*3.635041802980734e-4+1.09051254089422e16).^(1.0./5.0).*-2.0e5)-3.353271578472327e20;
%W.*(-1.0./3.0e2)+(X+3.0e19).^(1.0./5.0).*2.279603801209383e-4;
%Z.*-5.6e1-Y.*(Y.*(1.1e1./1.0e3)+Y.^2.*3.6e-4-1.3e1./1.0e1);
%X.*(-1.2e-19)-Z.*(5.0./2.0)-1.2

xprime = [
   Xprime ;
   Yprime ;
   Zprime ;
   Wprime
];

end
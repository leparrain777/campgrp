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
f = interp1(insolT,insol,t,'pchip');

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

Xprime = (f*90-452)*-7.7e+13-Y.*2.8e+13-X./1.0e+4-Z.*3.08e+14+(((X./2.751e+3+1.09051254089422e+16).^(1.0./5.0)./3.0<W)&(4.0<W)).*((X+3.0e+19).*1.0./(X./2.751e+3+1.09051254089422e+16).^(1.0./5.0).*-2.0e+1)-3.353271578472327e+16;
Yprime = Z.*(-5.6e-3)-Y.*(Y.*1.1e-6+Y.^2.*3.6e-8-1.3e-4);
Zprime = X.*(-1.2e-23)-Z./4.0e+3-1.2e-4;
Wprime =W.*(-3.333333333333333e-5)+(X+3.0e+19).^(1.0./5.0).*2.279603801209383e-6;
%F.*-7.7e+13-Y.*2.8e+13-X./1.0e+4-Z.*3.08e+14+(((X./2.751e+3+1.09051254089422e+16).^(1.0./5.0)./3.0<W)&(4.0<W)).*((X+3.0e+19).*1.0./(X./2.751e+3+1.09051254089422e+16).^(1.0./5.0).*-2.0e+1)-3.353271578472327e+16;W.*(-3.333333333333333e-5)+(X+3.0e+19).^(1.0./5.0).*2.279603801209383e-6;Z.*(-5.6e-3)-Y.*(Y.*1.1e-6+Y.^2.*3.6e-8-1.3e-4);X.*(-1.2e-23)-Z./4.0e+3-1.2e-4]

xprime = [
   Xprime ;
   Yprime ;
   Zprime ;
   Wprime
];

end
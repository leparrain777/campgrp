% Note: 
% x(1) (X) is continental ice mass
% x(2) (Y) is atmospheric concentration of CO2
% x(3) (Z) is deep ocean temperature
%
% This is a nondimensionalized model.

% Date: 17 July 2014
% Author: Andrew Gallatin

%need co2events and tectonic

function xprime = sm92(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,Rw,insolT,insol,timescale);

p = param(1);
q = param(2);
u = param(3);
v = param(4);

%r = interp1(parT,R,t,'pchip');
%s = interp1(parT,S,t,'pchip');
r = 1.3;
s = 0.6;

% Insolation:
Rprime = 30*interp1(insolT,insol,t,'spline');

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
psi = x(1);
D = x(2);
muprime = x(3);
thetaprime = x(4);


functiongeneratorforsm92
if psi<=0
    psideriv = max(0,equation11);
else
    psideriv = equation11;
end    
Dderiv = equation12;
muprimederiv = equation13;
thetaprimederiv = equation14;




xprime = [
   psideriv ;
   Dderiv ;
   muprimederiv ;
   thetaprimederiv
];

end
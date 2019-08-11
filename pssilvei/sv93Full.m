% Note: 
% x(1) (X) is continental ice mass
% x(2) (Y) is atmospheric concentration of CO2
% x(3) (Z) is deep ocean temperature
%
% This is a nondimensionalized model.

% Date: 17 July 2014
% Author: Andrew Gallatin

%need co2events and tectonic

function xprime = sv93(t,x,params);

% p = param(1);
% q = param(2);
% u = param(3);
% v = param(4);

%r = interp1(parT,R,t,'pchip');
%s = interp1(parT,S,t,'pchip');
% r = 1.3;
% s = 0.6;



% Stochastic Terms:
%Wx = interp1(Rt,Rx,t,'pchip');
%Wy = interp1(Rt,Ry,t,'pchip');
%Wz = interp1(Rt,Rz,t,'pchip');
%Ww = interp1(Rt,Rw,t,'pchip');
% Wx = 0;
% Wy = 0;
% Wz = 0;
% Ww = 0;

if params.mutildestar == 0
psi = max(1e-10,x(1));
D = max(1e-10,x(2));
xi = x(3);
upsilon = x(4);
mutilde = params.mutildestar + (5e6/params.timescale-t) * params.mutildedot;
Z = params.Znot + params.Jpsi * psi; %? + params.Jtheta * (params.theta - params.thetastar);
Rprime = params.standarddeviationmultiplier * ppval(params.Rprime,t);
R = params.Rnot + Rprime;
H = nthroot(params.zeta^4 * psi / 2 /  params.icedensity,5);
Dnot = 1/3 * H; 
C = -params.alphafour * psi/2 / H; 
Cflag = double((D > Z) & (D > Dnot)); 
alphanot = params.alphanotstar;
kappamu =@(x) params.B / x;
bone =@(x) 2 * params.betathree * x - 3 * params.betafour * x^2 - params.betatwo;
btwo =@(x) 3 * params.betafour * x - params.betathree;


omegapsi = params.omegapsi;
omegamu = params.omegamu;
omegatheta = params.omegatheta;


equation17 = alphanot - params.alphathree * psi + 2 * C*Cflag + omegapsi - params.phitwo * params.kappaR * Rprime;
equation18 = params.eone * nthroot(psi,5) - params.epsilontwo * D;
equation19 = 0;
equation20 = 0;


if psi<=0
    psideriv = max(0,equation17);
else
    psideriv = equation17;
end 
if D<=0
    Dderiv = max(0,equation18);
else
    Dderiv = equation18;
end
xideriv = equation19;
upsilonderiv = equation20;




xprime = [
   psideriv ;
   Dderiv ;
   xideriv ;
   upsilonderiv
];
%disp(xprime)
else
   

% Set up of the model
psi = max(1e-10,x(1));
D = max(1e-10,x(2));
xi = x(3);
upsilon = x(4);
mutilde = params.mutildestar + (5e6/params.timescale-t) * params.mutildedot;
Z = params.Znot + params.Jpsi * psi; %? + params.Jtheta * (params.theta - params.thetastar);
Rprime = params.standarddeviationmultiplier * ppval(params.Rprime,t);
R = params.Rnot + Rprime;
H = nthroot(params.zeta^4 * psi / (2 * params.icedensity),5);
Dnot = 1/3 * H; 
C = -params.alphafour * psi / (H * 2); 
Cflag = double((D > Z) & (D > Dnot)); 
alphanot = params.alphanotstar - params.phitwo * params.B * (mutilde - params.mutildestar)/ params.mutildestar;
kappamu =@(x) params.B / x;
bone =@(x) 2 * params.betathree * x - 3 * params.betafour * x^2 - params.betatwo;
btwo =@(x) 3 * params.betafour * x - params.betathree;


omegapsi = params.omegapsi;
omegamu = params.omegamu;
omegatheta = params.omegatheta;


equation17 = alphanot - params.phitwo * (kappamu(mutilde) * xi + params.kappatheta * upsilon + params.kappaR * Rprime) - params.alphathree * psi + 2 * C*Cflag + omegapsi;
equation18 = params.eone * nthroot(psi,5) - params.epsilontwo * D;
equation19 = (bone(mutilde) - btwo(mutilde) * xi - params.betafour * xi^2) * xi - params.betafive * upsilon + omegamu;
equation20 = params.gammanot - params.gammatwo * psi - params.gammathree * upsilon + omegatheta;


if psi<=1e-10
    psideriv = max(0,equation17);
else
    psideriv = equation17;
end 
if D<=1e-10
    Dderiv = max(0,equation18);
else
    Dderiv = equation18;
end
xideriv = equation19;
upsilonderiv = equation20;




xprime = [
   psideriv ;
   Dderiv ;
   xideriv ;
   upsilonderiv
];
%disp(xprime)
end
end
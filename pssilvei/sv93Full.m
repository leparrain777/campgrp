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



% Set up of the model
psi = x(1);
D = x(2);
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
%matlabFunction(su(equation11))
%creating a version of equation 11 using pieces of equations that we have
%already written.

equation18 = params.eone * nthroot(psi,5) - params.epsilontwo * D;
%matlabFunction(su(equation12))
%creating a version of equation 12 using pieces of equations that we have
%already written.

equation19 = (bone(mutilde) - btwo(mutilde) * xi - params.betafour * xi^2) * xi - params.betafive * upsilon + omegamu;
%matlabFunction(su(equation13))
%creating a version of equation 13 using pieces of equations that we have
%already written.

equation20 = params.gammanot - params.gammatwo * psi - params.gammathree * upsilon + omegatheta;
%matlabFunction(su(equation14))
%creating a version of equation 14 using pieces of equations that we have
%already written.



if psi<=0
    psideriv = max(0,equation17);
else
    psideriv = equation17;
end    
Dderiv = equation18;
xideriv = equation19;
upsilonderiv = equation20;




xprime = [
   psideriv ;
   Dderiv ;
   xideriv ;
   upsilonderiv
];

end
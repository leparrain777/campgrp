% Note: 
% x(1) (X) is continental ice mass
% x(2) (Y) is atmospheric concentration of CO2
% x(3) (Z) is deep ocean temperature
%
% This is a nondimensionalized model.

% Date: 17 July 2014
% Author: Andrew Gallatin

%need co2events and tectonic

function xprime = sv92build(t,x,params);

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
nn1 = x(1);
nn2 = x(2);
%psi = nn1;
%D = nn2;
psi = max(eps,x(1));
D = max(eps,x(2));
muprime = x(3);
thetaprime = x(4);

mu = muprime + params.munot;

 %I=globalicemass;
%make I a short name for globalicemass as of model time

theta= params.thetanot + thetaprime;
%make theta equal to the baseline value plus the drifting value

Rprime = params.standarddeviationmultiplier * ppval(params.Rprime,t);

R = params.Rnot + Rprime;
%make R a short name for high latitude radiation as of model time



%highlatradiation = insol*90;


%Rprime = interp1([0 : 1000 : 5e6],highlatradiation(t) - 452,t,'pchip');
%Rprime = highlatradiation - 452;
%make Rprime equal to the baseline value minus the drifting value


%make alphafour a short nam for the rate of ice destruction




psiprime = psi - params.psinot;
%make psi equal to the baseline value plus the drifting value

%JI =@() 2.67e-18;
%Jtheta=@() 1;
%syms Z; Z = Znotstar + JI * psi+ Znotstar * Jtheta * (theta - thetastar);


H = nthroot(params.zeta^4 * psi / (params.n * params.icedensity),5);
%setting the mean thickness of ice sheets, and creating a short name H


Dnot = 1/3 * H; % epsilonone / epsilontwo basically 1/3 H by paper
% setting the threshold level of bedrock depression for ice calving

%Rprime = R - Rnot;


omegaI = params.omegaI;
omegamu = params.omegamu;
omegatheta = params.omegatheta;


equation11 = params.alphanot - params.alphatwo * (params.c * muprime + params.kappatheta * thetaprime + params.kappaR * Rprime) - params.alphathree * psi + omegaI;
%matlabFunction(su(equation11))
%creating a version of equation 11 using pieces of equations that we have
%already written.

equation12 = params.eone * nthroot(psi,5) - params.epsilontwo * D;
%matlabFunction(su(equation12))
%creating a version of equation 12 using pieces of equations that we have
%already written.

equation13 = muprime * (params.bone - params.btwo * muprime - params.bthree * muprime^2) - params.bfour * thetaprime + omegamu;
%matlabFunction(su(equation13))
%creating a version of equation 13 using pieces of equations that we have
%already written.

equation14 = params.gammanot - params.gammatwo * psi - params.gammathree * thetaprime + omegatheta;
%matlabFunction(su(equation14))
%creating a version of equation 14 using pieces of equations that we have
%already written.



if nn1<=0
    psideriv = max(0,equation11);
else
    psideriv = equation11;
end    
if nn2 <= 0
    Dderiv = max(0,equation12);
else
    Dderiv = equation12;
end
muprimederiv = equation13;
thetaprimederiv = equation14;




xprime = [
   psideriv ;
   Dderiv ;
   muprimederiv ;
   thetaprimederiv
];
%disp(xprime)
xprime = xprime/params.tau;
end
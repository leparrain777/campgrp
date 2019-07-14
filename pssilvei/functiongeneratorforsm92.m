

timescale=100;

sensitivityhighlatsurfacetempone= 18; %18 only
%setting the sensitivity to high latitude surface temp constant one aka b
b = sensitivityhighlatsurfacetempone ;
%make b a short name for snsitivivityhighlatsurfacetempone

sensitivityhighlatsurfacetemptwo= 4e-3; %4e-3 only
%setting the sensitivity to high latitude surface temp constant two aka c
c = sensitivityhighlatsurfacetemptwo ;
%make c a short name for snsitivivityhighlatsurfacetemptwo


highlatradiationpresentvalue= 7;
%the current value of high latitude radiation

%externalforcingcarbondioxide=[1 2 3 4];
%the forcing signal on carbon dioxid for each timestep of the run, should
%be calculated by something else, this is a placeholder

%externalforcingoceantemp=[1 2 3 4];
%the forcing signal on ocean temperature for each timestep of the run, should
%be calculated by something else, this is a placeholder

alphaone= timescale*15.4e15; %13.7e15 or 15.4e15
alphatwo= timescale*9.4e15; %7.0e15 or 9.4e15
alphathree= timescale*1.0e-4; %1.0e-4
rateoficedestruction= timescale*20; %20 or 0 aka alphafour
%setting the rate of ice destruction
%setting alpha rate constants

bone= timescale*1.3e-4; %1.3e-4 or 0 
btwo= timescale*1.1e-6; % 1.1e-6 or 0
bthree= timescale*3.6e-8; % 0 or 3.6e-8
bfour= timescale*5.6e-3; %0 or 5.6e-3
%setting b constants

gammaone= timescale*1.9e-3; %1.9e-3 or 0
gammatwo= timescale*1.2e-23; %0 or 1.2e-23
gammathree= timescale*2.5e-4; %0 or 2.5e-4
%setting gamma rate constants

kappaR= 1.1e-2; %.7e-2 or 1.1e-2 or 1.7e-2
kappatheta= 4.4e-2; %3.3e-2 or 4.4e-2
%setting kappa constants

Kmu= 0;%2e-18; %2e-18 or possibly 0?
Ktheta= 0;%4.8e-20; %4.8e-20 or possibly 0?
%setting K constants for pollard paper emulation

munotstar= 253; %253 or 250 or 215
thetanotstar= 5.2; %5.2 or 4.8
%setting current atmosphere averages

presentvalueglobalicemass= 3e19; %3e19 or 3.3e19
%setting the present value of global ice mass


Z= 4e2; %4e2 or 0 or 6.4e2
%Znot=Znotstar;
%setting the baseline value of tectonic crust equilibrium to be the modern tectonic crust equilibrium?

epsilontwo= timescale*1/(30e3); %1/(3e3) or 1/(30e3)
%setting epsilon 2. It is often stated by its inverse in the paper.

epsilonone = epsilontwo * 1/3; %this should be epsilonone *1/3 as they use a 
%constant in the paper for epsilon one divided by epsilon two with value one third

zeta= 1; %1 or .5
%setting zeta constant

icedensity= 917; %917 given in paper
%set ice density, seen as rho with an i subscript

numberoficesheets= 3; %look up
%set number of ice sheets to consider 

stochasticforcingofatmosphericcarbondioxideconcentration = 0; %0 in the paper
%set the forcing term for mu

stochasticforcingofdeepoceantemperature = 0; %0 in the paper
%set the forcing term for theta

stochasticforcingofglobalicemass = 0; %0 in paper when not explicityly stated otherwise
%set the forcing term for I/phi

format long e
%set our outputs to have some more decimals and a seperate magnitude
%multiplier

equilibriumatmosphericcarbondioxideconcentration = munotstar;
munot = equilibriumatmosphericcarbondioxideconcentration;

%look up
equilibriumdeepoceantemperature = thetanotstar;
thetanot = equilibriumdeepoceantemperature;

%look up
equilibriumicemass = presentvalueglobalicemass;
psinot = equilibriumicemass; 
%look up
equilibriumhighlatradiation = 452;
Rnot = equilibriumhighlatradiation;
%look up
%setting some placeholder values for testing to be replaced later








mu = muprime + munot;

 %I=globalicemass;
%make I a short name for globalicemass as of model time

theta= thetanot + thetaprime;
%make theta equal to the baseline value plus the drifting value

R = Rnot + Rprime;
%make R a short name for high latitude radiation as of model time

Rstar = highlatradiationpresentvalue;
%make Rstar a short name for high latitude radiation present value

%highlatradiation = insol*90;


%Rprime = interp1([0 : 1000 : 5e6],highlatradiation(t) - 452,t,'pchip');
%Rprime = highlatradiation - 452;
%make Rprime equal to the baseline value minus the drifting value

alphafour = rateoficedestruction;
%make alphafour a short nam for the rate of ice destruction

Istar = presentvalueglobalicemass;
%make Istar a short name for the present value of global ice mass


psiprime = psi - psinot;
%make psi equal to the baseline value plus the drifting value

%JI =@() 2.67e-18;
%Jtheta=@() 1;
%syms Z; Z = Znotstar + JI * psi+ Znotstar * Jtheta * (theta - thetastar);

alphanot = alphaone - alphatwo * tanh(c * munot) + kappatheta * thetanot + kappaR * (Rnot - Rstar) - alphathree * Istar;
%computes the value of alphanot from other items that are given

n = numberoficesheets;
%makes n a short name for the number of ice sheets under consideration

eone= epsilonone * nthroot(zeta^4/(icedensity * n),5);
%computes the value of eone from other items that are given

icesheetmeanthickness = nthroot(zeta^4 * psi / (n * icedensity),5);
H = icesheetmeanthickness; 
%setting the mean thickness of ice sheets, and creating a short name H

omegamu = stochasticforcingofatmosphericcarbondioxideconcentration; %0 in the paper
%set the forcing term for mu

omegatheta = stochasticforcingofdeepoceantemperature; %0 in the paper
%set the forcing term for theta

omegaI = stochasticforcingofglobalicemass; %0 in paper when not explicityly stated otherwise
%set the forcing term for I/phi

Dnot = epsilonone / epsilontwo * H; %basically 1/3 H by paper
% setting the threshold level of bedrock depression for ice calving

%Rprime = R - Rnot;

gammanot = gammaone - gammatwo * Istar - gammathree * thetanot;
%??? = gammatwo * phinot = gammatwo * alphanot / alphathree as phinot = alphnot / alphathree if muprime = thetaprime = 0;

C = -alphafour * psi / (H * n); %C = matlabFunction(piecewise(D < Z | D < Dnot, 0, D > Z & D > Dnot, -alphafour * psi / (H * n)));
%computes the value of C from other items that should be given in the
%differential equation

Cflag = double((D > Z) & (D > Dnot)); %this is our alternative to a piecewise function
%and is a result of the function being zero if certain conditions are or are not met.





equation11 = alphanot - alphatwo * (c * muprime + kappatheta * thetaprime + kappaR * Rprime) - alphathree * psi + n * C*Cflag + omegaI;
%matlabFunction(su(equation11))
%creating a version of equation 11 using pieces of equations that we have
%already written.

equation12 = eone * nthroot(psi,5) - epsilontwo * D;
%matlabFunction(su(equation12))
%creating a version of equation 12 using pieces of equations that we have
%already written.

equation13 = muprime * (bone - btwo * muprime - bthree * muprime^2) - bfour * thetaprime + omegamu;
%matlabFunction(su(equation13))
%creating a version of equation 13 using pieces of equations that we have
%already written.

equation14 = gammanot - gammatwo * psi - gammathree * thetaprime + omegatheta;
%matlabFunction(su(equation14))
%creating a version of equation 14 using pieces of equations that we have
%already written.


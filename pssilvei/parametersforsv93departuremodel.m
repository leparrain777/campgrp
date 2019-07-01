%Declaration of constants and short name setup

timeofrunstart= -2000000;
%Start time of run in years. Should always be negative.

sensitivityhighlatsurfacetempone= 18; %18 only
%setting the sensitivity to high latitude surface temp constant one aka b

sensitivityhighlatsurfacetemptwo= 4 * 10^(-3); %4 * 10^(-3) only
%setting the sensitivity to high latitude surface temp constant two aka c

highlatradiationpresentvalue= 7;
%the current value of high latitude radiation

%externalforcingcarbondioxide=[1 2 3 4];
%the forcing signal on carbon dioxid for each timestep of the run, should
%be calculated by something else, this is a placeholder

%externalforcingoceantemp=[1 2 3 4];
%the forcing signal on ocean temperature for each timestep of the run, should
%be calculated by something else, this is a placeholder

alphaone= 13.7 * 10^15; %13.7 or 15.4 * 10^15
alphatwo= 7.0 * 10^15; %7.0 or 9.4 * 10^15
alphathree= 1.0 * 10^(-4); %1.0 * 10^(-4)
rateoficedestruction= 20; %20 or 0 aka alphafour
%setting the rate of ice destruction
%setting alpha rate constants

bone= 1.3  * 10^(-4); %1.3 * 10^(-4) or 0 
btwo= 1.1; % 1.1 * 1 or 0 
bthree= 3.6 * 10^(-8); % 0 or 3.6 * 10^(-8)
bfour= 5.6 * 10^(-3); %0 or 5.6 * 10^(-3)
%setting b constants

gammaone= 1.9 * 10^(-3); %1.9 * 10^(-3) or 0
gammatwo= 1.2 * 10^(-23); %0 or 1.2 * 10^(-23)
gammathree= 2.5 * 10^(-4); %0 or 2.5 * 10^(-4)
%setting gamma rate constants

kappaR= 1.1 * 10^(-2); %.7 or 1.1 or 1.7 * 10^(-2)
kappatheta= 4.4 * 10^(-2); %3.3 or 4.4 * 10^(-2)
%setting kappa constants

Kmu= 2 * 10^(-18); %2 * 10^(-18) or possibly 0?
Ktheta= 4.8 * 10^(-20); %4.8 * 10^(-20) or possibly 0?
%setting K constants for pollard paper emulation

munotstar= 253; %253 or 250 or 215
thetanotstar= 5.2; %5.2 or 4.8
%setting current atmosphere averages

presentvalueglobalicemass= 3 * 10^19; %3 or 3.3 * 10^19
%setting the present value of global ice mass


Z= 4; %4 or 0 or 6.4
%Znot=Znotstar;
%setting the baseline value of tectonic crust equilibrium to be the modern tectonic crust equilibrium?

epsilontwo= 1/30; %1/3 or 1/30 
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

syms munot equilibriumatmosphericcarbondioxideconcentration;
munot = equilibriumatmosphericcarbondioxideconcentration;
equilibriumatmosphericcarbondioxideconcentration = 1;
%look up
syms thetanot equilibriumdeepoceantemperature;
thetanot = equilibriumdeepoceantemperature;
equilibriumdeepoceantemperature = 1;
%look up
syms psinot equilibriumicemass;
psinot = equilibriumicemass; equilibriumicemass = 1;
%look up
syms Rnot equilibriumhighlatradiation; 
Rnot = equilibriumhighlatradiation; equilibriumhighlatradiation = 1;
%look up
%setting some placeholder values for testing to be replaced later

global timefromrunstart;
timefromrunstart=0;
%Should always be 0 here, and we change it in other scripts.

su=@(x) subs(subs(subs(subs(subs(subs(subs(subs(subs(subs(x))))))))));

syms t; %t = timefromrunstart;
%Make t a short name for timefromrunstart.

syms b; b = sensitivityhighlatsurfacetempone ;
%make b a short name for snsitivivityhighlatsurfacetempone

syms c; c = sensitivityhighlatsurfacetemptwo ;
%make c a short name for snsitivivityhighlatsurfacetemptwo

syms D bedrockdepression(t); D = bedrockdepression(t); 
%make D a short name for bedrockdepression(t) as of model time

syms mu atmosphericcarbondioxideconcentration; mu = atmosphericcarbondioxideconcentration;
%make mu a short name for atmosphericcarbondioxideconcentration as of model
%time

syms muprime(t);atmosphericcarbondioxideconcentration = munot + muprime(t);
%make mu equal to the baseline value plus the drifting value

syms I globalicemass; I=globalicemass;
%make I a short name for globalicemass as of model time

syms theta deepoceantemperature; theta=deepoceantemperature;
%make theta a short name for deepoceantemperature as of model time

syms thetaprime(t); deepoceantemperature = thetanot + thetaprime(t);
%make theta equal to the baseline value plus the drifting value

syms R highlatradiation; R = highlatradiation;
%make R a short name for high latitude radiation as of model time

syms Rstar; Rstar = highlatradiationpresentvalue;
%make R a short name for high latitude radiation present value

syms Rprime; highlatradiation = Rnot + Rprime;
%make R equal to the baseline value plus the drifting value

syms alphafour; alphafour = rateoficedestruction;
%make alphafour a short nam for the rate of ice destruction

syms Istar; Istar = presentvalueglobalicemass;
%make Istar a short name for the present value of global ice mass

syms psi deviationinicemassfrompresent; psi = deviationinicemassfrompresent;
%make psi a short name for the deviation in ice mass from the present

syms psiprime(t); deviationinicemassfrompresent = psinot + psiprime(t);
%make psi equal to the baseline value plus the drifting value

%JI =@() 2.67*10^(-18);
%Jtheta=@() 1;
%syms Z; Z = Znotstar + JI * psi+ Znotstar * Jtheta * (theta - thetastar);

syms alphanot; alphanot = alphaone - alphatwo * eval(tanh(c * munot) + kappatheta * thetanot + kappaR * (Rnot - Rstar)) - alphathree * Istar;
%computes the value of alphanot from other items that are given

syms n; n = numberoficesheets;
%makes n a short name for the number of ice sheets under consideration

syms eone; eone= epsilonone * (zeta^4/(icedensity * n))^(1/5);
%computes the value of eone from other items that are given

syms H; icesheetmeanthickness = (zeta^4 * psi / (n * icedensity))^(1/5); H = icesheetmeanthickness; 
%setting the mean thickness of ice sheets, and creating a short name H

syms omegamu; omegamu = stochasticforcingofatmosphericcarbondioxideconcentration; %0 in the paper
%set the forcing term for mu

syms omegatheta; omegatheta = stochasticforcingofdeepoceantemperature; %0 in the paper
%set the forcing term for theta

syms omegaI; omegaI = stochasticforcingofglobalicemass; %0 in paper when not explicityly stated otherwise
%set the forcing term for I/phi

syms Dnot; Dnot = epsilonone / epsilontwo * H; %basically 1/3 H by paper
% setting the threshold level of bedrock depression for ice calving

syms Rprime; Rprime = R - Rnot;

syms gammanot; gammanot = gammaone - gammatwo * Istar - gammathree * thetanot;
%??? = gammatwo * phinot = gammatwo * alphanot / alphathree as phinot = alphnot / alphathree if muprime(t) = thetaprime(t) = 0;

syms C; C = -alphafour * psi / (H * n); %C = matlabFunction(piecewise(D < Z | D < Dnot, 0, D > Z & D > Dnot, -alphafour * psi / (H * n)));
%computes the value of C from other items that should be given in the
%differential equation

syms Cflag(t); Cflag(t) = su(D > Z & D > Dnot)

Rprime = 1; %TESTING PURPOSES ONLY, comment this out when you have insolation data

syms equation11; equation11 = su(alphanot - alphatwo * (c * muprime(t) + kappatheta * thetaprime(t) + kappaR * Rprime) - alphathree * psi + n * C*Cflag(t) + omegaI);
matlabFunction(su(equation11))

syms equation12; equation12 = eone * psi^(1/5) - epsilontwo * D;
matlabFunction(su(equation12))

syms equation13; equation13 = muprime(t) * (bone - btwo * muprime(t) - bthree * muprime(t)^2) -bfour * thetaprime(t) + omegamu;
matlabFunction(su(equation13))

syms equation14; equation14 = gammanot - gammatwo * psi - gammathree * thetaprime(t) + omegatheta;
matlabFunction(su(equation14))

system = {matlabFunction(su(equation11),matlabFunction(su(equation12)),matlabFunction(su(equation13)),matlabFunction(su(equation14)))}

x = [psiprime(t);bedrockdepression(t);muprime(t);thetaprime(t)]

[t,x] = ode45(@(t,x) system ,[0 : .1 : 1000],[1 1 1 1])
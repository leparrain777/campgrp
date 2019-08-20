function [value,isterminal,direction] = sv92modelswitch(t,x,params)

psi = max(1e-10,x(1));
D = max(1e-10,x(2));
muprime = x(3);
thetaprime = x(4);

H = nthroot(params.zeta^4 * psi / (params.n * params.icedensity),5);
%setting the mean thickness of ice sheets, and creating a short name H

Dnot = 1/3 * H; % epsilonone / epsilontwo basically 1/3 H by paper

Cflag = double((D > params.Z) & (D > Dnot)); %this is our alternative to a piecewise function
%and is a result of the function being zero if certain conditions are or are not met.
value = Cflag-.5;
isterminal = 1;  % Does terminate when model switches
direction = 0;  % Want both parts of model switch

end
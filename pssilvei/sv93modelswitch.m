function [value,isterminal,direction] = sv93modelswitch(t,x,params)
psi = max(0,x(1));
D = max(0,x(2));

Z = params.Znot + params.Jpsi * psi; %? + params.Jtheta * (params.theta - params.thetastar);
H = nthroot(params.zeta^4 * psi / (2 * params.icedensity),5);
Dnot = 1/3 * H; 
Cflag = double((D > Z) & (D > Dnot)); 

value = Cflag-.5;
isterminal = 1;  % Does terminate when model switches
direction = 0;  % Want both parts of model switch

end
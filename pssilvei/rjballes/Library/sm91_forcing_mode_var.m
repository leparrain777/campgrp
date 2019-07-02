% This function collects data of effects of alterted forcing coefficients/eemd's on model output mode variance ratio
% We are searching between [0.2,1]
tic
addMatlabpath_rjballes
sm91_params

whiteNoise = 0.4; % 40 percent
iterations=(whiteNoise*100)^2;
forcing_coeffs = [0.5:0.01:.6];
IC_vals = rand(5,3);
data_out = [];
ratios = [];
tstart = 1;
tfinal = 800;
filep = '~/campgrp/rjballes/ModelRuns/sm91/ForcingSearch/forcing_variance_stats/';
filen = 'forcing_IC_var_time_fine1.txt';

%for i = .875 %forcing_coeffs
%forcing_coeff = .599;
for i=1:5
   x0 = IC_vals(i,:);
   for u=forcing_coeffs
    options = odeset('Events',@sm91_co2_events);
    param(3) = u;
    
    tic

    % Simulation of Pleistocene departure model:
    [t,xprime,te,ye,ie] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0,options);

    toc
   
    % Re-dimensionalizing the results
    xprime(:,1) = xprime(:,1).*2.0;
    xprime(:,2) = xprime(:,2).*52.5;
    xprime(:,3) = xprime(:,3).*0.9;
   
    ye(:,1) = ye(:,1).*2.0;
    ye(:,2) = ye(:,2).*52.5;
    ye(:,3) = ye(:,3).*0.9;
    
    Vout = flipud(xprime(:,1));
    data=-1*Vout;
    
    %ratios = [tfinal];
    
    %for j = 1:40
    
        derta = data(1:end-1000);
    
        nmodes = eemd(derta, whiteNoise, iterations);
        
        fast = nmodes(:,4) + nmodes(:,5);
        slow = nmodes(:,6) + nmodes(:,7);
        
        vfast = var(fast);
        vslow = var(slow);
        
        variance_ratio = vfast/vslow;
        
        ratios = [ratios;variance_ratio];
        
        %tstart = tstart + 100;
        %tfinal = tfinal + 100;
        
    end % for
end % for

storeData(ratios, filen, filep, 1);
disp('YEET')
toc

exit;
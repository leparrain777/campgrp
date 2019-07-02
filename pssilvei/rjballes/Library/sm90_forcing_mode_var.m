% This function collects data of effects of alterted forcing coefficients/eemd's on model output mode variance ratio
% We are searching between [0.2,1]
tic
addMatlabpath_rjballes
sm90_params

whiteNoise = 0.4; % 40 percent
iterations=(whiteNoise*100)^2;
forcing_coeffs = [.4-0.25:0.05:.4+.25];
data_out = [];
tstart = 1;
tfinal = 800;
filep = '~/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/forcing_variance_stats/';
filen = 'forcing_v_mode_var_time_fine1.txt';

%for i = .875 %forcing_coeffs
%forcing_coeff = .4;
    options = odeset('Events',@sm90_co2_events);
    
    tic
    [t,xprime,te,ye,ie] = ode45(@(t,x) sm90(t,x,param,insolT,insol),[0:0.1:500],x0,options);
    toc
    
    % Re-dimensionalizing the results
    xprime(:,1) = xprime(:,1).*1.3;
    xprime(:,2) = xprime(:,2).*26.3;
    xprime(:,3) = xprime(:,3).*0.7;
       
    %Re-dimensionalizing results at time of events
    ye(:,1) = ye(:,1).*1.3;
    ye(:,2) = ye(:,2).*26.3;
    ye(:,3) = ye(:,3).*0.7;
    
    Vout = flipud(xprime(:,1));
    data=-1*Vout;
    
    ratios = [tfinal];
    
    for j = 1:40
    
        derta = data(tstart:tfinal);
    
        nmodes = eemd(derta, whiteNoise, iterations);
        
        fast = nmodes(:,4)+ nmodes(:,5);
        slow = nmodes(:,6) + nmodes(:,7);
        
        vfast = var(fast);
        vslow = var(slow);
        
        variance_ratio = vfast/vslow;
        
        ratios = [ratios;variance_ratio];
        
        tstart = tstart + 100;
        tfinal = tfinal + 100;
        
    end % for
%end % for

storeData(ratios, filen, filep, 1);
disp('YEET')
toc

exit;
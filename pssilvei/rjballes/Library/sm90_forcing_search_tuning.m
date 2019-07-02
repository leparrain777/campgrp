% This function finds the appropriate forcing coefficient in order to tune the SM90 mode variance ratio to the ratio in empirical data.
% We are searching between [0.2,1]

%addMatlabpath_Branch
addMatlabpath_rjballes
sm90_params

search_array = [0.2:0.001:1];
variance_ratio = 0;
var_ratios = Data_mode_variance; % Data measures for tuning
target_ratio = mean(mean(var_ratios(:,2))) % averaging of 500kyr and 800kyr ratios for all data
% .3769 --> avg of 500kyr - 800 kyr ratios
% .4033 --> avg of 800kyr ratios
% .4410 --> avg of 1000kyr ratios
% .3982 --> avg of 500, 800, 1000 kyr ratios

options = odeset('Events',@sm90_co2_events);

while abs(variance_ratio-target_ratio) >= 0.005

    mdpt = (search_array(1)+search_array(end))/2;
    %mdpt = search_array(floor(end/2));
    param(5) = mdpt;

   % Simulation of Pleistocene departure model:
   [t,xprime,te,ye,ie] = ode45(@(t,x) sm90(t,x,param,insolT,insol),[0:0.1:500],x0,options);
   
   % Re-dimensionalizing the results
   xprime(:,1) = xprime(:,1).*1.3;
   xprime(:,2) = xprime(:,2).*26.3;
   xprime(:,3) = xprime(:,3).*0.7;
      
   %Re-dimensionalizing results at time of events
   ye(:,1) = ye(:,1).*1.3;
   ye(:,2) = ye(:,2).*26.3;
   ye(:,3) = ye(:,3).*0.7;
    
    Vout = flipud(xprime(:,1));
    data=-1*Vout(1:end-1000);

    whiteNoise = 0.4 % 40 percent
    iterations=(whiteNoise*100)^2;
    nmodes = eemd(data,whiteNoise,iterations);
    
    fast = nmodes(:,4) + nmodes(:,5);
    slow = nmodes(:,6) + nmodes(:,7);
    
    vfast = var(fast);
    vslow = var(slow);
    
    variance_ratio = vfast/vslow;
    
    if variance_ratio < target_ratio
        search_array = mdpt:.001:search_array(end);
    else %variance_ratio > target_ratio
        search_array = search_array(1):0.001:mdpt;
    end % if

end % while

disp('Tuned forcing_coefficient')
disp(mdpt)

exit;
    

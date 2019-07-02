% This script runs the forced/unforced SM90 model for various initial conditions
% and plots the trajectories for the warming/cooling
% phase(s) with the unforced limit cycle.
clear

unforcedFlag = 0;
forcedFlag = 1;
randFlag = 0;  %control random ICs
MuIFlag = 0;  %Mu-I Projection
MuThetaFlag = 0;  %Mu-Theta Projection
ThetaIFlag = 1;   %Theta-I Projection
saveFlag = 1;  %save figure(s)


% Finding points on the ydot nullcline curve/surface
syms y z
h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'-k','LineWidth', 1.25);
yvals = h1.XData;
zvals = h1.YData;
close  %close figure

% Restricting data to just get points on curve that limit cycle passes through
id1 = find(zvals >= -1.5);
id2 = find(zvals <= 0.74);
ind = intersect(id1,id2);

yvals = yvals(ind);
zvals = zvals(ind);


% Creating matrix of initial values for warming phase
if randFlag
   ICMat1 = [];
   check1 = find(yvals < -0.7);
   check2 = find(yvals > -2);
   ck1 = intersect(check1,check2);
   for j=1:6:length(ck1)
      t1 = ck1(j);
      %ICMat1 = [ICMat1; rand yvals(t1) zvals(t1)];
      rand_I = 1*rand+0.3328;
      rand_Mu = 1*rand-1.709;
      rand_Theta = 1*rand-1.118;
      ICMat1 = [ICMat1; rand_I rand_Mu rand_Theta];
   end %for
else
   %ICMat1 = [0.3087 -0.7333 -0.4606;
   %          0.5431 -0.9270 -0.5333;
   %          0.8864 -1.1333 -0.5972;
   %          0.3086 -1.3333 -0.6486;
   %          0.4903 -1.5333 -0.6927;
   %          0.9724 -1.7439 -0.7333];
    
    ICMat1 = [0.3374 -0.9341 -0.3007;
             0.4783 -1.5729 -0.2487;
             0.5927 -0.9089 -0.6866;
             0.8217 -1.0849 -0.4389;
             0.9125 -1.1591 -0.9730;
             1.0631 -1.2204 -0.5395;
             1.1362 -1.6485 -0.7187;
             1.2434 -1.5272 -0.8542];
   
    %1.3970 -0.7333 -0.4606
    %0.8258 -1.0000 -0.5566
    %1.0292 -1.3333 -0.6486
    %1.2566 -1.6667 -0.7189
    %0.1933 -0.7333 -0.4606
    %1.6891 -1.0000 -0.5566
    %0.4087 -1.3333 -0.6486
    %0.2634 -1.6667 -0.7189
    %1.5472 -0.7333 -0.4606
    %2.3820 -0.9333 -0.5354
    %1.8094 -1.2000 -0.6151
    %0.0936 -1.4667 -0.6790
    %0.4108 -1.7439 -0.7333
    
    %0.3374 -0.9341 -0.3007
    %1.2015 -1.6246 -0.7182
    %0.5927 -0.9089 -0.6866
    %1.2434 -1.5272 -0.8542
    %0.4783 -1.5729 -0.2487
    %0.9125 -1.1591 -0.9730
    %1.2562 -1.2788 -0.9332
    %1.2377 -0.7293 -0.6791
    %0.4439 -1.4509 -0.7093
    %0.9277 -1.4468 -0.5152
    %1.0631 -1.2204 -0.5395
    %0.5701 -1.2502 -0.1549
    %0.8796 -1.1879 -0.8864
    %0.8217 -1.0849 -0.4389
    %0.3615 -1.2191 -0.9501
    %1.3115 -0.9963 -0.6175
    %0.8039 -1.6494 -0.4360
    %0.3752 -1.6376 -0.5964
    %1.1581 -1.6255 -0.9848
    %0.5062 -1.3181 -0.2866
    %1.1362 -1.6485 -0.7187
    %0.8597 -1.2922 -0.4611
end %if


% Creating matrix of initial values for cooling phase
if randFlag
   ICMat2 = [];
   check1 = find(yvals > 1.9);
   check2 = find(yvals < 3.5);
   ck2 = intersect(check1,check2);    
   for j=1:6:length(ck2)
      t1 = ck2(j);
      rand_I = 1*rand-1.8185;
      rand_Mu = 1*rand+2.2602;
      rand_Theta = 1*rand+0.1980;
      %ICMat2 = [ICMat2; -rand yvals(t1) zvals(t1)];
      ICMat2 = [ICMat2; rand_I rand_Mu rand_Theta];
   end %for
else
   %ICMat2 = [-0.7570 3.4667 0.6992;
   %   -0.1980 3.2000 0.6964;
   %   -0.9918 2.9333 0.6930;
   %   -0.6034 2.6667 0.6889;
   %   -0.2055 2.4000 0.6838;
   %   -0.3897 2.1333 0.6772];
      
   ICMat2 = [-1.2278 2.1690 0.6784
        -1.5824 3.3406 0.6984
        -1.4700 2.6458 0.6889
        -1.5815 3.0888 0.6955
        -1.7003 3.4417 0.6994
        -1.7204 3.5186 0.7002
        -1.8113 3.8533 0.7031
        -1.8413 3.9497 0.7038];
   
   %-2.1634 3.4667 0.6992
   %-1.3520 3.0667 0.6948
   %-2.0753 2.6667 0.6889
   %-0.7428 2.2667 0.6807 
   %-1.4443 3.4667 0.6992
   %-1.2537 3.0667 0.6948
   %-1.4409 2.6667 0.6889
   %-0.7571 2.2667 0.6807
   %-0.7396 3.4667 0.6992
   %-0.3593 3.1333 0.6956
   %-2.0653 2.8000 0.6911
   %-2.6494 2.4667 0.6852
   %-1.2711 2.1333 0.6772
   
   %-0.9655 2.8823 0.5490
   %-1.3053 2.6620 0.2740
   %-1.5786 2.3835 0.3819
   %-1.5785 2.6775 0.2477
   %-0.9158 3.2050 0.6889
   %-1.3292 2.5979 1.0981
   %-1.1073 2.4819 0.3154
   %-1.5218 2.5790 0.6222
   %-1.3106 2.3457 0.4605
   %-1.0175 2.2894 1.1269
   %-1.4230 2.6276 1.1860
   %-1.7808 3.1454 1.1113
   %-1.0223 2.3589 0.4599
   %-1.4831 2.9399 0.3346
   %-1.7218 3.0783 1.0155
   %-1.0961 2.4101 0.8576
   %-1.2999 3.2332 0.8470
   %-1.0182 2.7140 0.6304
   %-1.1905 2.5522 0.6297
   %-1.8030 3.2443 0.3652
   %-1.7123 2.6326 0.3961
   %-1.3288 2.5997 1.1496
   
   %-1.8243 3.8997 0.7034
   %-1.4840 2.9839 0.6941
   %-1.8113 3.8533 0.7031
   %-1.6316 3.2928 0.6979
   %-1.8375 3.9792 0.7040
   %-1.5045 2.9308 0.6934
   %-1.7816 3.7876 0.7025
   %-1.4605 2.7298 0.6903
end %if


% Finding data points for unforced limit cycle
fileName = sprintf('SM90_Unforced_Model.txt');
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Unforced/';
[data_unfor,te_unfor,ye_unfor] = readSM90Data(fileName,filePath,4);
t = data_unfor(:,1);
te = te_unfor(10:end);
ye = ye_unfor(10:end,:);
if ye(1,2) > ye(2,2)
   tmin = te(2:2:end);
   tmax = te(3:2:end);
   yemin = ye(2:2:end,:);
   yemax = ye(3:2:end,:);
else
   tmin = te(1:2:end);
   tmax = te(2:2:end);
   yemin = ye(1:2:end,:);
   yemax = ye(2:2:end,:);
end %if
   
check1 = find(t>=tmin(3) & t<=tmin(4));  %points of unforced limit cycle


if unforcedFlag   %plotting unforced model run(s)
   sm90_unforced_params

   % Running model (warming phase) with different initial conditions
   options = odeset('Events',@sm90_co2_events);

   D1 = [];
   events1 = [];
   figure(1)
   hold on;
   for p = 1:size(ICMat1,1)
      %Simulation of Plesitocene departure model
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm90Unforced(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz),tspan,ICMat1(p,:),options);

      %Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1);  %.*1.3;
      xprime(:,2) = xprime(:,2);  %.*26.3;
      xprime(:,3) = xprime(:,3);  %.*0.7;
      
      % finding time where trajectory reaches ydot curve
      idx = min(find(te > 2));
      tc = min(find(t >= te(idx)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',2)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',2)
      elseif ThetaIFlag
         plot(xprime(1:tc,3),xprime(1:tc,1),'LineWidth',2)
      end %if
      
      % Saving model output in matrix/array
      D1 = [D1; t xprime];
      events1 = [events1; te(idx) ye(idx,:)];

   end %for

   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.5)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
      xlim([-2.5 4])
      ylim([-2.5 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
      xlim([-2 4])
      ylim([-2.5 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
      syms x z   %plotting zdot nullcline curve
      h3 = fimplicit(-2.5*(z+x),'--k','LineWidth', 1.25);
      xlim([-2.5 2.5])
      ylim([-3 2])
      xlabel('Ocean Temp.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      set(gca,'XDir','reverse')
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   if saveFlag
      if MuThetaFlag
         print('sm90_unfor_MuTheta_ICplot_warming','-depsc')
         print('sm90_unfor_MuTheta_ICplot_warming','-djpeg')
      elseif MuIFlag
         print('sm90_unfor_MuI_ICplot_warming','-depsc')
         print('sm90_unfor_MuI_ICplot_warming','-djpeg')
      elseif ThetaIFlag
         print('sm90_unfor_ThetaI_ICplot_warming','-depsc')
         print('sm90_unfor_ThetaI_ICplot_warming','-djpeg')
      end %if
   end %if


   % Running model (cooling phase) with different initial conditions
   figure(2)
   hold on;
   D2 = [];
   events2 = [];
   for p = 1:size(ICMat2,1)
      %Simulation of Plesitocene departure model
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm90Unforced(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz),tspan,ICMat2(p,:),options);

      %Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1);  %.*1.3;
      xprime(:,2) = xprime(:,2);  %.*26.3;
      xprime(:,3) = xprime(:,3);  %.*0.7;
      
      % finding time where trajectory reaches ydot curve
      idx = min(find(te > 5));
      tc = min(find(t >= te(idx)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',2)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',2)
      elseif ThetaIFlag
         plot(xprime(1:tc,3),xprime(1:tc,1),'LineWidth',2)
      end %if
      
      % Saving model output in matrix/array
      D2 = [D2; t xprime];
      events2 = [events2; te(idx) ye(idx,:)];

   end %for

   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.5)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
      xlim([-2 4])
      ylim([-2 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
      xlim([-2 4])
      ylim([-2.5 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
      syms x z   %plotting zdot nullcline curve
      h3 = fimplicit(-2.5*(z+x),'--k','LineWidth', 1.25);
      xlim([-2.5 2.5])
      ylim([-3 2])
      xlabel('Ocean Temp.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      set(gca,'XDir','reverse')
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   %Saving figure
   if saveFlag
      if MuThetaFlag
         print('sm90_unfor_MuTheta_ICplot_cooling','-depsc')
         print('sm90_unfor_MuTheta_ICplot_cooling','-djpeg')
      elseif MuIFlag
         print('sm90_unfor_MuI_ICplot_cooling','-depsc')
         print('sm90_unfor_MuI_ICplot_cooling','-djpeg')
      elseif ThetaIFlag
         print('sm90_unfor_ThetaI_ICplot_cooling','-depsc')
         print('sm90_unfor_ThetaI_ICplot_cooling','-djpeg')
      end %if
   end %if
end %if


if forcedFlag
   sm90_params
   
   % Running model (warming phase) with different initial conditions
   options = odeset('Events',@sm90_co2_events);

   %D3 = [];
   %events3 = [];
   %figure(3)
   %hold on;
   %for p = 1:size(ICMat1,1)
   %   %Simulation of Plesitocene departure model
   %   [t,xprime,te,ye,ie] = ode45(@(t,x) sm90(t,x,param,insolT,insol),[0:0.1:500],ICMat1(p,:),options);

   %   %Re-dimensionalizing the results
   %   xprime(:,1) = xprime(:,1);  %.*1.3;
   %   xprime(:,2) = xprime(:,2);  %.*26.3;
   %   xprime(:,3) = xprime(:,3);  %.*0.7;
   %   
   %   % finding time where trajectory reaches ydot curve
   %   idx = min(find(te > 1.5));
   %   tc = min(find(t >= te(idx)));
   %   
   %   if MuThetaFlag
   %      plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',1.75)
   %   elseif MuIFlag
   %      plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',1.75)
   %   elseif ThetaIFlag
   %      plot(xprime(1:tc,3),xprime(1:tc,1),'LineWidth',1.75)
   %   end %if
   %   
   %   D3 = [D3; t xprime];
   %   events3 = [events3; te(idx) ye(idx,:)];

   %end %for
   
   %% Plotting unforced limit cycle
   %if MuThetaFlag
   %   plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.5)
   %   
   %   syms y z   %plotting ydot nullcline curve
   %   h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
   %   xlim([-3 5.5])
   %   ylim([-2.5 2.5])
   %   xlabel('CO2 conc.','FontSize',12)
   %   ylabel('Ocean Temp.','FontSize',12)
   %elseif MuIFlag
   %   plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
   %   
   %   xlim([-2 4])
   %   ylim([-2 2])
   %   xlabel('CO2 conc.','FontSize',12)
   %   ylabel('Ice Mass','FontSize',12)
   %elseif ThetaIFlag
   %   plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
   %   
   %   syms x z   %plotting zdot nullcline curve
   %   h3 = fimplicit(-2.5*(z+x),'--k','LineWidth', 1.25);
   %   xlim([-2 2])
   %   ylim([-2.5 2])
   %   xlabel('Ocean Temp.','FontSize',12)
   %   ylabel('Ice Mass','FontSize',12)
   %   set(gca,'YDir','reverse')
   %   set(gca,'XDir','reverse')
   %end %if
   %set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   %if saveFlag
   %   if MuThetaFlag
   %      print(sprintf('sm90_%s_MuTheta_ICplot_warming',descr),'-depsc')
   %      print(sprintf('sm90_%s_MuTheta_ICplot_warming',descr),'-djpeg')
   %   elseif MuIFlag
   %      print(sprintf('sm90_%s_MuI_ICplot_warming',descr),'-depsc')
   %      print(sprintf('sm90_%s_MuI_ICplot_warming',descr),'-djpeg')
   %   elseif ThetaIFlag
   %      print(sprintf('sm90_%s_ThetaI_ICplot_warming',descr),'-depsc')
   %      print(sprintf('sm90_%s_ThetaI_ICplot_warming',descr),'-djpeg')
   %   end %if
   %end %if
   
   
   % Running model (cooling phase) with different initial conditions
   D4 = [];
   events4 = [];
   figure(4)
   hold on;
   for p = 1:size(ICMat2,1)
      %Simulation of Plesitocene departure model
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm90(t,x,param,insolT,insol),[0:0.1:500],ICMat2(p,:),options);

      %Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1);  %.*1.3;
      xprime(:,2) = xprime(:,2);  %.*26.3;
      xprime(:,3) = xprime(:,3);  %.*0.7;
      
      % finding time where trajectory reaches ydot curve
      idx = min(find(te > 6.5));
      tc = min(find(t >= te(idx)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',1.75)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',1.75)
      elseif ThetaIFlag
         plot(xprime(1:tc,3),xprime(1:tc,1),'LineWidth',1.75)
      end %if
      
      D4 = [D4; t xprime];
      events4 = [events4; te(idx) ye(idx,:)];

   end %for
   
   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.5)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
      xlim([-2 4])
      ylim([-2 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
      xlim([-2 4])
      ylim([-2.5 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
      syms x z   %plotting zdot nullcline curve
      h3 = fimplicit(-2.5*(z+x),'--k','LineWidth', 1.25);
      xlim([-1.5 2.5])
      ylim([-3 1.5])
      xlabel('Ocean Temp.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      set(gca,'XDir','reverse')
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   if saveFlag
      if MuThetaFlag
         print(sprintf('sm90_%s_MuTheta_ICplot_cooling',descr),'-depsc')
         print(sprintf('sm90_%s_MuTheta_ICplot_cooling',descr),'-djpeg')
      elseif MuIFlag
         print(sprintf('sm90_%s_MuI_ICplot_cooling',descr),'-depsc')
         print(sprintf('sm90_%s_MuI_ICplot_cooling',descr),'-djpeg')
      elseif ThetaIFlag
         print(sprintf('sm90_%s_ThetaI_ICplot_cooling',descr),'-depsc')
         print(sprintf('sm90_%s_ThetaI_ICplot_cooling',descr),'-djpeg')
      end %if
   end %if

end %if
% This script runs the forced/unforced SM91 model for various initial conditions
% and plots the trajectories for the warming/cooling
% phase(s) with the unforced limit cycle.

UnforcedFlag = 0;
forcedFlag = 1;
randFlag = 0;  %control random ICs
MuIFlag = 0;  %Mu-I Projection
MuThetaFlag = 1;  %Mu-Theta Projection
saveFlag = 1;  %save figure(s)


% Finding points on the ydot nullcline curve/surface
syms y z
h1 = fimplicit(-1*z+1.3*y-0.6*y^2-y^3);
yvals = h1.XData;
zvals = h1.YData;
close  %close figure


% Creating matrix of initial values for warming phase
if randFlag
   ICMat1 = [];
   check1 = find(yvals < -0.8);
   check2 = find(yvals > -1.75);
   ck1 = intersect(check1,check2);
   for j=1:7:length(ck1)
      t1 = ck1(j);
      ICMat1 = [ICMat1; rand yvals(t1) zvals(t1)];
   end %for
else
   ICMat1 = [0.5338 -0.8000 -0.9120;
             0.8299 -1.1333 -0.7883;
             0.5682 -1.3166 -0.4667;
             0.4904 -1.4377 -0.1333;
             0.0418 -1.5333 0.2010;
             0.3761 -1.6253 0.6000;
             0.3745 -1.7049 1.0000];
end %if


% Creating matrix of initial values for cooling phase
if randFlag
   ICMat2 = [];
   check1 = find(yvals > 0.35);
   check2 = find(yvals < 1.3);
   ck2 = intersect(check1,check2);    
   for j=1:6:length(ck2)
      t1 = ck2(j);
      ICMat2 = [ICMat2; -1*rand yvals(t1) zvals(t1)];
   end %for
else
   ICMat2 = [-0.1626 1.2889 -1.4667
             -0.8098 1.2214 -1.1333
             -0.3928 1.1446 -0.8000
             -0.3902 1.0667 -0.5096
             -0.1389 0.9625 -0.2000
             -0.1188 0.8433 0.0667
             -0.1224 0.6667 0.3037];
end %if


% Finding data points for unforced limit cycle
fileName = sprintf('SM91_unforced_Model.txt');
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/';
[data_unfor,te_unfor,ye_unfor] = readSM91Data(fileName,filePath,4);
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
   
check1 = find(t>=floor(tmin(3)) & t<=ceil(tmin(4)));  %points of unforced limit cycle

sm91_params
options = odeset('Events',@sm91_co2_events);

if UnforcedFlag   %plotting unforced model run(s)
   % Running model (warming phase) with different initial conditions
   param_unfor = [1.0 2.5 0 0.2];
   
   D1 = [];
   events1 = [];
   figure(1)
   hold on;
   for p = 1:size(ICMat1,1)
      %Simulation of Plesitocene departure model
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm91Full(t,x,param_unfor,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,ICMat1(p,:),options);

      %Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1);  %.*2.0;
      xprime(:,2) = xprime(:,2);  %.*52.5;
      xprime(:,3) = xprime(:,3);  %.*0.9;
      
      % finding time where trajectory reaches ydot curve
      idx = min(find(te > 2));
      tc = min(find(t >= te(idx)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',1.5)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',1.5)
      end %if
      
      % Saving model output in matrix/array
      D1 = [D1; t xprime];
      events1 = [events1; te(idx) ye(idx,:)];

   end %for

   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./52.5,data_unfor(check1,4)./0.9,'k-','LineWidth',1.5)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+1.3*y-0.6*y^2-y^3,'--k','LineWidth', 1.25);
      xlim([-2 1.5])
      ylim([-2.5 2])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./52.5,data_unfor(check1,2)./2,'k-','LineWidth',1.5)
      
      syms x y
      h2 = fimplicit(-y-x+0.2*y,'--k','LineWidth', 1.25);%xdot nullcline curve
      xlim([-2.5 1.5])
      ylim([-2 2])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   if saveFlag
      if MuThetaFlag
         print('sm91_unfor_MuTheta_ICplot1','-depsc')
         print('sm91_unfor_MuTheta_ICplot1','-djpeg')
      elseif MuIFlag
         print('sm91_unfor_MuI_ICplot1','-depsc')
         print('sm91_unfor_MuI_ICplot1','-djpeg')
      end %if
   end %if


   % Running model (cooling phase) with different initial conditions
   figure(2)
   hold on;
   D2 = [];
   events2 = [];
   for p = 1:size(ICMat2,1)
      %Simulation of Plesitocene departure model
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm91Full(t,x,param_unfor,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,ICMat2(p,:),options);

      %Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1);  %.*1.3;
      xprime(:,2) = xprime(:,2);  %.*26.3;
      xprime(:,3) = xprime(:,3);  %.*0.7;
      
      % finding time where trajectory reaches ydot curve
      idx = min(find(te > 3));
      tc = min(find(t >= te(idx)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',1.5)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',1.5)
      end %if
      
      % Saving model output in matrix/array
      D2 = [D2; t xprime];
      events2 = [events2; te(idx) ye(idx,:)];

   end %for

   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./52.5,data_unfor(check1,4)./0.9,'k-','LineWidth',1.5)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+1.3*y-0.6*y^2-y^3,'--k','LineWidth', 1.25);
      xlim([-2 1.5])
      ylim([-2 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./52.5,data_unfor(check1,2)./2,'k-','LineWidth',1.5)
      
      syms x y
      h2 = fimplicit(-y-x+0.2*y,'--k','LineWidth', 1.25);%xdot nullcline curve
      xlim([-2 2])
      ylim([-2 2])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   %Saving figure
   if saveFlag
      if MuThetaFlag
         print('sm91_unfor_MuTheta_ICplot2','-depsc')
         print('sm91_unfor_MuTheta_ICplot2','-djpeg')
      elseif MuIFlag
         print('sm91_unfor_MuI_ICplot2','-depsc')
         print('sm91_unfor_MuI_ICplot2','-djpeg')
      end %if
   end %if
end %if


if forcedFlag
   % Running model (warming phase) with different initial conditions
   D3 = [];
   events3 = [];
   figure(3)
   hold on;
   for p = 1:size(ICMat1,1)
      %Simulation of Plesitocene departure model
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,ICMat1(p,:),options);

      %Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1);
      xprime(:,2) = xprime(:,2);
      xprime(:,3) = xprime(:,3);

      % finding time where trajectory reaches ydot curve
      idx = min(find(te > 2));
      tc = min(find(t >= te(idx)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',1.5)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',1.5)
      end %if
      
      D3 = [D3; t xprime];
      events3 = [events3; te(idx) ye(idx,:)];

   end %for
   
   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./52.5,data_unfor(check1,4)./0.9,'k-','LineWidth',1.5)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+1.3*y-0.6*y^2-y^3,'--k','LineWidth', 1.25);
      xlim([-2.5 1.5])
      ylim([-2 2])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./52.5,data_unfor(check1,2)./2,'k-','LineWidth',1.5)
      
      syms x y
      h2 = fimplicit(-y-x+0.2*y,'--k','LineWidth', 1.25);%xdot nullcline curve
      %xlim([-2 4])
      %ylim([-2.5 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   if saveFlag
      if MuThetaFlag
         print('sm91_forced_MuTheta_ICplot1','-depsc')
         print('sm91_forced_MuTheta_ICplot1','-djpeg')
      elseif MuIFlag
         print('sm91_forced_MuI_ICplot1','-depsc')
         print('sm91_forced_MuI_ICplot1','-djpeg')
      end %if
   end %if
   
   
   % Running model (cooling phase) with different initial conditions
   D4 = [];
   events4 = [];
   figure(4)
   hold on;
   for p = 1:size(ICMat2,1)
      %Simulation of Plesitocene departure model
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,ICMat2(p,:),options);

      %Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1);
      xprime(:,2) = xprime(:,2);
      xprime(:,3) = xprime(:,3);

      % finding time where trajectory reaches ydot curve
      idx = min(find(te > 3));
      tc = min(find(t >= te(idx)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',1.5)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',1.5)
      end %if
      
      D4 = [D4; t xprime];
      events4 = [events4; te(idx) ye(idx,:)];

   end %for
   
   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./52.5,data_unfor(check1,4)./0.9,'k-','LineWidth',1.5)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+1.3*y-0.6*y^2-y^3,'--k','LineWidth', 1.25);
      %xlim([-2 4])
      %ylim([-2.5 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./52.5,data_unfor(check1,2)./2,'k-','LineWidth',1.5)
      
      syms x y
      h2 = fimplicit(-y-x+0.2*y,'--k','LineWidth', 1.25);%xdot nullcline curve
      %xlim([-2 4])
      %ylim([-2.5 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   if saveFlag
      if MuThetaFlag
         print('sm91_forced_MuTheta_ICplot2','-depsc')
         print('sm91_forced_MuTheta_ICplot2','-djpeg')
      elseif MuIFlag
         print('sm91_forced_MuI_ICplot2','-depsc')
         print('sm91_forced_MuI_ICplot2','-djpeg')
      end %if
   end %if

end %if
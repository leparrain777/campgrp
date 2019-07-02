% This script produces plots of trajectories of SM90 model based
% on extreme values of ice.

unforcedFlag = 0;
forcedFlag = 1;
randFlag = 0;  %control random ICs

warmFlag = 0;  %plot warming phases
coolFlag = 1;  %plot cooling phases

MuIFlag = 1;  %Mu-I Projection
ThetaIFlag = 0;   %Theta-I Projection
MuThetaFlag = 0;  %Mu-Theta Projection
saveFlag = 1;  %save figure(s)


%insolLaskar
%ICMat1 = [0.6490 -0.3562 -0.5340;
%         1.0971 -0.7542 -0.9340;
%         0.9526 -0.4470 -0.7408;
%         1.3267 -0.8595 -1.0987;
%         0.8917 -0.2241 -0.8049;
%         1.4868 -0.2624 -1.3317;
%         0.7109 -0.2536 -0.5370];
         
ICMat1 = [0.6490 -0.3562 -0.5340;
         0.5919 -0.1947 -0.4665;
         1.0940 -0.3143 -0.9392;
         1.0971 -0.7542 -0.9340;
         0.9526 -0.4470 -0.7408;
         1.3267 -0.8595 -1.0987;
         1.4868 -0.2624 -1.3317];

%ICMat1 = [1.2662 -0.5624 -1.1241;
%         1.0072 -0.2554 -0.9240;
%         0.9015 -0.2646 -0.7324;
%         1.4351 -0.6697 -1.2099;
%         0.5787 -0.4571 -0.4278;
%         0.8421 -0.2207 -0.6725;
%         0.5024 -0.1346 -0.4073];

ICMat2 = [-1.7220 0.7034 1.4889;
         -1.1286 0.7213 1.0048;
         -2.2403 1.2183 1.7792;
         -1.3954 1.3595 1.2413;
         -1.4974 0.9496 1.3221;
         -2.0394 1.1614 1.7317;
         -2.7607 1.0155 2.3112];
         
%ICMat2 = [-1.7925 1.7919 1.4808;
%         -1.5051 1.6714 1.2564;
%         -1.6611 0.9798 1.4311;
%         -2.6784 1.1185 2.1959;
%         -1.6907 0.6689 1.4930;
%         -1.1556 1.1616 0.9846;
%         -1.5369 0.7159 1.3820];


% Finding data points for unforced limit cycle
fileName= sprintf('SM90_Unforced_Model.txt');
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


if forcedFlag
   sm90_params

   [data_forced,fullMat,iceMat,eventsMat] = sm90_find_cycles(fileName,filePath);
      
   %Non-dimensionalizing the solution(s)
   data_forced(:,2) = data_forced(:,2)./1.3;
   data_forced(:,3) = data_forced(:,3)./26.3;
   data_forced(:,4) = data_forced(:,4)./0.7;

   % Finding indices of max/min ice values
   maxI = [iceMat(1)];
   minI = iceMat(:,2);
   for k = 1:length(minI)-1
      t1 = minI(k);
      t2 = minI(k+1);
      check = data_forced(t1:t2,2);
      mx = find(check==max(check));
      maxI = [maxI; mx+t1];
   end %for
   
   if warmFlag
   D3 = [];
   figure(3)
   clf
   hold on;
   %for p = 1:size(fullMat,1)-1   %all trajectories
   %for p = [26 29 30 32 38 43 45]   %insolLaskar run
   for p = [26 27 28 29 30 32 43]
   %for p = [18 20 25 33 36 39 46]   %insolHuybersIntegrated run
      %Setting indices for plotting
      t1 = maxI(p);
      t2 = minI(p);
      
      D3 = [D3; data_forced(t1,2:4) data_forced(t2,2:4)];
 
      if MuThetaFlag
         plot(data_forced(t1:t2,3),data_forced(t1:t2,4),'LineWidth',2)
      elseif MuIFlag
         plot(data_forced(t1:t2,3),data_forced(t1:t2,2),'LineWidth',2)
      elseif ThetaIFlag
         plot(data_forced(t1:t2,4),data_forced(t1:t2,2),'LineWidth',2)
      end %if

   end %for
   
   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.75)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
      xlim([-3 5.5])
      ylim([-2.5 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.75)
      
      %xlim([-2 4.5])
      %ylim([-2.5 2])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      %set(gca,'XDir','reverse')
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.75)
      
      %syms x z   %plotting zdot nullcline curve
      %h3 = fimplicit(-2.5*(z+x),'--k','LineWidth', 1.25);
      %xlim([-2 2])
      %ylim([-2.5 2])
      xlabel('Ocean Temp.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      set(gca,'XDir','reverse')
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   if saveFlag
      if MuThetaFlag
         print(sprintf('sm90_%s_MuTheta_iceICplot_warming',descr),'-depsc')
         print(sprintf('sm90_%s_MuTheta_iceICplot_warming',descr),'-djpeg')
      elseif MuIFlag
         print(sprintf('sm90_%s_MuI_iceICplot_warming',descr),'-depsc')
         print(sprintf('sm90_%s_MuI_iceICplot_warming',descr),'-djpeg')
      elseif ThetaIFlag
         print(sprintf('sm90_%s_ThetaI_iceICplot_warming',descr),'-depsc')
         print(sprintf('sm90_%s_ThetaI_iceICplot_warming',descr),'-djpeg')
      end %if
   end %if
   end %if
   
   
   % Running model (cooling phase) with different initial conditions
   if coolFlag
   D4 = [];
   figure(4)
   clf
   hold on;
   %for p = 1:size(fullMat,1)-2   %all trajectories
   %for p = [26 29 30 32 38 43 45]
   for p = [26 27 28 29 30 32 43]
   %for p = [12 17 20 33 34 36 43]   %insolLaskar run
   %for p = [18 20 25 33 36 39 46]   %insolHuybersIntegrated run
      %Setting indices for plotting
      t1 = minI(p);
      t2 = maxI(p+1);
   %   
      D4 = [D4; data_forced(t1,2:4) data_forced(t2,2:4)];
   %
      if MuThetaFlag
         plot(data_forced(t1:t2,3),data_forced(t1:t2,4),'LineWidth',2)
      elseif MuIFlag
         plot(data_forced(t1:t2,3),data_forced(t1:t2,2),'LineWidth',2)
      elseif ThetaIFlag
         plot(data_forced(t1:t2,4),data_forced(t1:t2,2),'LineWidth',2)
      end %if
   %   
   end %for
   
   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.75)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
      xlim([-2 4])
      ylim([-2 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.75)
      
      %xlim([-1.5 4.5])
      %ylim([-3 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      %set(gca,'XDir','reverse')
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.75)
      
      %syms x z   %plotting zdot nullcline curve
      %h3 = fimplicit(-2.5*(z+x),'--k','LineWidth', 1.25);
      %xlim([-1.5 2.5])
      %ylim([-3 1.5])
      xlabel('Ocean Temp.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      set(gca,'XDir','reverse')
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   if saveFlag
      if MuThetaFlag
         print(sprintf('sm90_%s_MuTheta_iceICplot_cooling',descr),'-depsc')
         print(sprintf('sm90_%s_MuTheta_iceICplot_cooling',descr),'-djpeg')
      elseif MuIFlag
         print(sprintf('sm90_%s_MuI_iceICplot_cooling',descr),'-depsc')
         print(sprintf('sm90_%s_MuI_iceICplot_cooling',descr),'-djpeg')
      elseif ThetaIFlag
         print(sprintf('sm90_%s_ThetaI_iceICplot_cooling',descr),'-depsc')
         print(sprintf('sm90_%s_ThetaI_iceICplot_cooling',descr),'-djpeg')
      end %if
   end %if
   end %if
   
end %if


if unforcedFlag   %plotting unforced model run(s)
   %sm90_params
   sm90_unforced_params

   % Running model (warming phase) with different initial conditions
   options = odeset('Events',@sm90_co2_events);

   if warmFlag
   D1 = [];
   events1 = [];
   figure(1)
   clf
   hold on;
   for p = 1:size(ICMat1,1)
      %Simulation of Plesitocene departure model
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm90Unforced(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz),tspan,ICMat1(p,:),options);

      %Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1);  %.*1.3;
      xprime(:,2) = xprime(:,2);  %.*26.3;
      xprime(:,3) = xprime(:,3);  %.*0.7;
      
      % finding time where trajectory reaches ydot curve
      val1 = round(te(1),1);
      val2 = round(te(2),1);
      t1 = find(abs(t-val1) < 0.001);
      t2 = find(abs(t-val2) < 0.001);
      %tc = find(xprime(t1:t2,1)==min(xprime(t1:t2,1)));
      tc = find(xprime(1:t2,1)==min(xprime(1:t2,1)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',2)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',2)
      elseif ThetaIFlag
         plot(xprime(1:tc,3),xprime(1:tc,1),'LineWidth',2)
      end %if
      
      % Saving model output in matrix/array
      D1 = [D1; t xprime];
      events1 = [events1; te(idx:idx+1) ye(idx:idx+1,:)];

   end %for

   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.75)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
      xlim([-2.5 4])
      ylim([-2.5 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.75)
      
      %xlim([-2 4])
      %ylim([-2.5 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      %set(gca,'XDir','reverse')
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.75)
      
      %syms x z   %plotting zdot nullcline curve
      %h3 = fimplicit(-2.5*(z+x),'--k','LineWidth', 1.25);
      %xlim([-1.5 2])
      %ylim([-3 2.5])
      xlabel('Ocean Temp.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      set(gca,'XDir','reverse')
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   % Saving figure
   if saveFlag
      if MuThetaFlag
         print(sprintf('sm90_unfor_MuTheta_ICplot_%s_warming',descr),'-depsc')
         print(sprintf('sm90_unfor_MuTheta_ICplot_%s_warming',descr),'-djpeg')
      elseif MuIFlag
         print(sprintf('sm90_unfor_MuI_ICplot_%s_warming',descr),'-depsc')
         print(sprintf('sm90_unfor_MuI_ICplot_%s_warming',descr),'-djpeg')
      elseif ThetaIFlag
         print(sprintf('sm90_unfor_ThetaI_ICplot_%s_warming',descr),'-depsc')
         print(sprintf('sm90_unfor_ThetaI_ICplot_%s_warming',descr),'-djpeg')
      end %if
   end %if
   end %if


   % Running model (cooling phase) with different initial conditions
   if coolFlag
   figure(2)
   clf
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
      val1 = round(te(1),1);
      val2 = round(te(2),1);
      t1 = find(abs(t-val1) < 0.001);
      t2 = find(abs(t-val2) < 0.001);
      tc = find(xprime(1:t2,1) == max(xprime(1:t2,1)));
      
      if MuThetaFlag
         plot(xprime(1:tc,2),xprime(1:tc,3),'LineWidth',2)
      elseif MuIFlag
         plot(xprime(1:tc,2),xprime(1:tc,1),'LineWidth',2)
      elseif ThetaIFlag
         plot(xprime(1:tc,3),xprime(1:tc,1),'LineWidth',2)
      end %if
      
      % Saving model output in matrix/array
      D2 = [D2; t xprime];
      events2 = [events2; te(1:2) ye(1:2,:)];

   end %for

   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.75)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
      xlim([-2 4])
      ylim([-2 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.75)
      
      %xlim([-1.5 4.5])
      %ylim([-3 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      %set(gca,'XDir','reverse')
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.75)
      
      %syms x z   %plotting zdot nullcline curve
      %h3 = fimplicit(-2.5*(z+x),'--k','LineWidth', 1.25);
      %xlim([-2.5 2.5])
      %ylim([-3 2])
      xlabel('Ocean Temp.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      set(gca,'XDir','reverse')
   end %if
   set(gca,'LineWidth',1.5,'FontSize',12)
   
   %Saving figure
   if saveFlag
      if MuThetaFlag
         print(sprintf('sm90_unfor_MuTheta_iceICplot_%s_cooling',descr),'-depsc')
         print(sprintf('sm90_unfor_MuTheta_iceICplot_%s_cooling',descr),'-djpeg')
      elseif MuIFlag
         print(sprintf('sm90_unfor_MuI_iceICplot_%s_cooling',descr),'-depsc')
         print(sprintf('sm90_unfor_MuI_iceICplot_%s_cooling',descr),'-djpeg')
      elseif ThetaIFlag
         print(sprintf('sm90_unfor_ThetaI_iceICplot_%s_cooling',descr),'-depsc')
         print(sprintf('sm90_unfor_ThetaI_iceICplot_%s_cooling',descr),'-djpeg')
      end %if
   end %if
   end %if
   
end %if


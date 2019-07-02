% This script runs the forced/unforced SM90 model for various initial conditions
% and plots the trajectories for the warming/cooling
% phase(s) with the unforced limit cycle.
clear

unforcedFlag = 0;
forcedFlag = 1;
randFlag = 0;  %control random ICs

warmFlag = 1;  %plot warming phases
coolFlag = 0;  %plot cooling phases

MuIFlag = 0;  %Mu-I Projection
ThetaIFlag = 1;   %Theta-I Projection
MuThetaFlag = 0;  %Mu-Theta Projection
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
   ICMat1 = [0.8620 -0.8504 -0.4579;
             0.5660 -0.4954 -0.3293;
             1.0259 -1.1746 -0.6114;
             0.9212 -1.0469 -0.5505;
             1.0150 -1.1772 -0.6530;
             1.1877 -1.4376 -0.7051;
             1.1817 -1.5531 -0.7130];
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
      ICMat2 = [ICMat2; rand_I rand_Mu rand_Theta];
   end %for
else
   ICMat2 = [-1.4802 2.7713 0.7256;
            -1.2688 1.8806 0.6793;
            -1.0243 1.9143 0.6996;
            -1.6983 3.3664 0.6583;
            -1.1111 1.8334 0.6470;
            -2.0931 3.9040 0.8276;
            -1.8205 3.9908 0.6771];
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


if forcedFlag
   sm90_params
   
   %[data_forced,te_forced,ye_forced] = readSM90Data(fileName,filePath,4);
   [data_forced,fullMat,iceMat,eventsMat] = sm90_find_cycles(fileName,filePath);
   
   %Non-dimensionalizing the solution(s)
   data_forced(:,2) = data_forced(:,2)./1.3;
   data_forced(:,3) = data_forced(:,3)./26.3;
   data_forced(:,4) = data_forced(:,4)./0.7;

   if warmFlag
   D3 = [];
   figure(3)
   hold on;
   %for p = 1:size(fullMat,1)-1   %all trajectories
   %for p = [12 17 20 33 34 36 43]   %insolLaskar run
   for p = [11 16 20 25 33 34 43]   %insolHuybersIntegrated run
      %Setting indices for plotting
      t1 = fullMat(p,1);
      t2 = fullMat(p,2);
      
      D3 = [D3; data_forced(t1,2:4) data_forced(t2,2:4)];
 
      if MuThetaFlag
         plot(data_forced(t1:t2,3),data_forced(t1:t2,4),'LineWidth',1.75)
      elseif MuIFlag
         plot(data_forced(t1:t2,3),data_forced(t1:t2,2),'LineWidth',1.75)
      elseif ThetaIFlag
         plot(data_forced(t1:t2,4),data_forced(t1:t2,2),'LineWidth',1.75)
      end %if

   end %for
   
   % Plotting unforced limit cycle
   if MuThetaFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,4)./0.7,'k-','LineWidth',1.5)
      
      syms y z   %plotting ydot nullcline curve
      h1 = fimplicit(-1*z+0.9*y+z^2-0.5*y*z-y*z^2,'--k','LineWidth', 1.25);
      xlim([-3 5.5])
      ylim([-2.5 2.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ocean Temp.','FontSize',12)
   elseif MuIFlag
      plot(data_unfor(check1,3)./26.3,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
      %xlim([-2 4.5])
      %ylim([-2.5 2])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      %set(gca,'XDir','reverse')
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
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
         print(sprintf('sm90_%s_MuTheta_ICplot_warming',descr),'-depsc')
         print(sprintf('sm90_%s_MuTheta_ICplot_warming',descr),'-djpeg')
      elseif MuIFlag
         print(sprintf('sm90_%s_MuI_ICplot_warming',descr),'-depsc')
         print(sprintf('sm90_%s_MuI_ICplot_warming',descr),'-djpeg')
      elseif ThetaIFlag
         print(sprintf('sm90_%s_ThetaI_ICplot_warming',descr),'-depsc')
         print(sprintf('sm90_%s_ThetaI_ICplot_warming',descr),'-djpeg')
      end %if
   end %if
   end %if
   
   
   % Running model (cooling phase) with different initial conditions
   if coolFlag
   D4 = [];
   figure(4)
   hold on;
   %for p = 1:size(fullMat,1)-1   %all trajectories
   %for p = [12 17 20 33 34 36 43]   %insolLaskar run
   for p = [11 16 20 25 33 34 43]   %insolHuybersIntegrated run
      %Setting indices for plotting
      t1 = fullMat(p,2);
      t2 = fullMat(p+1,1);
   %   
      D4 = [D4; data_forced(t1,2:4) data_forced(t2,2:4)];
   %
      if MuThetaFlag
         plot(data_forced(t1:t2,3),data_forced(t1:t2,4),'LineWidth',1.75)
      elseif MuIFlag
         plot(data_forced(t1:t2,3),data_forced(t1:t2,2),'LineWidth',1.75)
      elseif ThetaIFlag
         plot(data_forced(t1:t2,4),data_forced(t1:t2,2),'LineWidth',1.75)
      end %if
   %   
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
      
      %xlim([-1.5 4.5])
      %ylim([-3 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      %set(gca,'XDir','reverse')
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
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

end %if


if unforcedFlag   %plotting unforced model run(s)
   sm90_params
   sm90_unforced_params

   % Running model (warming phase) with different initial conditions
   options = odeset('Events',@sm90_co2_events);

   if warmFlag
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
      
      %xlim([-2 4])
      %ylim([-2.5 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      %set(gca,'XDir','reverse')
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
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
      
      %xlim([-1.5 4.5])
      %ylim([-3 1.5])
      xlabel('CO2 conc.','FontSize',12)
      ylabel('Ice Mass','FontSize',12)
      set(gca,'YDir','reverse')
      %set(gca,'XDir','reverse')
   elseif ThetaIFlag
      plot(data_unfor(check1,4)./0.7,data_unfor(check1,2)./1.3,'k-','LineWidth',1.5)
      
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
         print(sprintf('sm90_unfor_MuTheta_ICplot_%s_cooling',descr),'-depsc')
         print(sprintf('sm90_unfor_MuTheta_ICplot_%s_cooling',descr),'-djpeg')
      elseif MuIFlag
         print(sprintf('sm90_unfor_MuI_ICplot_%s_cooling',descr),'-depsc')
         print(sprintf('sm90_unfor_MuI_ICplot_%s_cooling',descr),'-djpeg')
      elseif ThetaIFlag
         print(sprintf('sm90_unfor_ThetaI_ICplot_%s_cooling',descr),'-depsc')
         print(sprintf('sm90_unfor_ThetaI_ICplot_%s_cooling',descr),'-djpeg')
      end %if
   end %if
   end %if
   
end %if


% This script runs the SM90 Model for various strengths of forcing.
% This script needs to have access to the following functions:
% 	sm91Full.m
% 	sm91_params.m
% 	sm91_c02_events.m

% Date: 19 October 2018
% Author: Raymart Ballesteros

clear
sm91_params

plotFlag = 0;  %control 3D plot of solutions
timeFlag = 0;   %control temporal plots

tic

options = odeset('Events',@sm91_co2_events);

D = [];
evtD = [];
%u_vals = [0.2 0.5 1 1.5 2 5];
%u_vals = [0.7 1.2 3 4 7 8];
%u_vals = [0.85 0.9 0.95 1.05 1.1 1.15];
sm91_u_vals = 0.54:0.003:0.57;
sm91_runs = [];

for u=sm91_u_vals
   param(3) = u;

   % Simulation of Pleistocene departure model:
   [t,xprime,te,ye,ie] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0,options);

   % Re-dimensionalizing the results
   xprime(:,1) = xprime(:,1).*2.0;
   xprime(:,2) = xprime(:,2).*52.5;
   xprime(:,3) = xprime(:,3).*0.9;
   
   ye(:,1) = ye(:,1).*2.0;
   ye(:,2) = ye(:,2).*52.5;
   ye(:,3) = ye(:,3).*0.9;
      

   %evtD = [evtD; te ye];
   D = [D;te ye; t xprime];
   te = 10.*te;
   t = 10.*t;  %flipud(t);
   
   % Saving data as a txt file
   fileName = sprintf('SM91_%s_%d_forcing_Model.txt',descr,runID);
   filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/ForcingSearch/';
   storeData([te ye; t xprime],fileName,filePath,4);
   sm91_runs = [sm91_runs runID];


   if timeFlag
      figure
      clf
      t = 10.*flipud(t);
      subplot(4,1,1)
      plot(t,-xprime(:,1),'-')
      %set(gca,'xdir','reverse')
      title(strcat('SM91',descr,' (u=',num2str(param(3)),', p=',num2str(param(1)),')'));
      ylabel('global ice mass')
      subplot(4,1,2)
      plot(t,xprime(:,2),'-')
      %set(gca,'xdir','reverse')
      ylabel('CO2 concentration')
      subplot(4,1,3)
      plot(t,xprime(:,3),'-')
      %set(gca,'xdir','reverse')
      ylabel('global mean ocean temp')
      subplot(4,1,4)
      plot(t,param(3).*insol,'-')
      %set(gca,'xdir','reverse')
      ylabel('forcing')
      xlabel('time (kya)')
   
      % Save temporal plots
      print(gcf,'-djpeg',strcat('SM91_',num2str(runID),'_',descr, '_forcing','_u=',num2str(param(3))))
   end %if
   
   runID = runID+1;

end %for

toc
   
% Saving data as a txt file
%fileName = sprintf('SM91_%s_%d_forcing_Model.txt',descr,runID);
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/ForcingSearch/';
%storeData(D,fileName,filePath,4);



%The following plots are for the solutions without the tectonic solution
%3-D plot of the solutions
if plotFlag
   X = [min(I):0.1:max(I)];
   Y = [min(Mu):0.1:max(Mu)];
   Z = [min(Theta):0.1:max(Theta)];
   figure(1);
   clf
   hold on;
   plot3(I,Mu,Theta,'-')
   %plot3(40.*ones(length(I),1),Mu,Theta,'-')
   %plot3(I,100.*ones(length(I),1),Theta,'-')
   %plot3(I,Mu,-1.*ones(length(I),1),'-')
   plot3(-X-Y-0.2.*Z,-Z + 0.9.*Y + Z.^2 - 0.5.*Y.*Z - (Z.^2).*Y,-2.5.*(X+Z),'k-');
   xlabel('I')
   ylabel('Mu')
   zlabel('theta')
end %if
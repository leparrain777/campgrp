% This script runs the SM90 Model for various strengths of forcing.
% This script needs to have access to the following functions:
% 	sm90.m
% 	sm90_params.m
% 	sm90_c02_events.m

% Date: 18 October 2018
% Author: Raymart Ballesteros

clear
sm90_params

plotflag = 0;  %control 3D plot of solutions
timeflag = 0;   %control temporal plots

tic

options = odeset('Events',@sm90_co2_events);

D = [];
evtD = [];
%u_vals = [0 0.3 0.6 1 1.5 2 5 10];
%u_vals = [0.4 1.3 3 4 6 8];
%u_vals = [0.75 0.8 0.85 0.9 1.05 1.15];
sm90_u_vals = 0.3:0.01:0.4;
IC_vals = rand(5,3);
sm90_runs = [];

for i=1:5
   x0 = IC_vals(i,:);
   for u=sm90_u_vals
      param(5) = u;

      % Simulation of Pleistocene departure model:
      %[t,xprime] = ode45(@(t,x) sm90(t,x,param,insolT,insol),tspan,x0);
      %[t,xprime] = ode45(@(t,x) sm90(t,x,param,insolT,insol),[0:0.1:500],x0);
      [t,xprime,te,ye,ie] = ode45(@(t,x) sm90(t,x,param,insolT,insol),[0:0.1:500],x0,options);

         
      % Re-dimensionalizing the results
      xprime(:,1) = xprime(:,1).*1.3;
      xprime(:,2) = xprime(:,2).*26.3;
      xprime(:,3) = xprime(:,3).*0.7;
         
      %Re-dimensionalizing results at time of events
      ye(:,1) = ye(:,1).*1.3;
      ye(:,2) = ye(:,2).*26.3;
      ye(:,3) = ye(:,3).*0.7;
         

      %evtD = [evtD; te ye];
      D = [D;te ye; t xprime];
      te = 10.*te;
      t = 10.*t;  %flipud(t);
      
      % Saving data as a txt file
      fileName = sprintf('SM90_%s_%d_forcing_Model.txt',descr,runID);
      filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/';
      storeData([te ye; t xprime],fileName,filePath,4);
      sm90_runs = [sm90_runs runID];


      if timeflag
         figure
         clf
         t = 10.*flipud(t);
         subplot(4,1,1)
         plot(t,-xprime(:,1),'-')
         %set(gca,'xdir','reverse')
         title(strcat('SM90',descr,' (u=',num2str(param(5)),', p=',num2str(param(1)),')'));
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
         plot(t,param(5).*insol,'-')
         %set(gca,'xdir','reverse')
         ylabel('forcing')
         xlabel('time (kya)')
      
         % Save temporal plots
         print(gcf,'-djpeg',strcat('SM90_',num2str(runID),'_',descr, '_forcing','_u=',num2str(param(5))))
      
      end %if
      runID = runID+1;

   end %for
end %for

toc
   
% Saving data as a txt file
%fileName = sprintf('SM90_%s_%d_forcing_Model.txt',descr,runID);
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/';
%storeData(D,fileName,filePath,4);



%The following plots are for the solutions without the tectonic solution
%3-D plot of the solutions
if plotflag
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

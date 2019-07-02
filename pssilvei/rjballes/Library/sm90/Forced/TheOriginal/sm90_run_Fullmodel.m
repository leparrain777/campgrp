% Run this script in matlab to produce the simulation and graphs for the Saltzman 90 forced model from the research paper in section 4.2.
% This script needs to have access to the following functions:
% 	sm90.m
% 	sm90_params.m
% 	sm90_c02_events.m

% Date: 7 August 2018
% Author: Raymart Ballesteros

%addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));
addpath(genpath('/nfsbigdata1/campgrp/brknight/Lib/Matlab'));

plotflag = 0;  %control 3D plot of solutions
timeflag = 0;   %control temporal plots

sm90Full_params

tic

options = odeset('Events',@sm90_co2_events);

% Simulation of Pleistocene departure model:
[t,xprime,te,ye,ie] = ode45(@(t,x) sm90Full(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0,options);

% Re-dimensionalizing the results
xprime(:,1) = xprime(:,1).*1.3;
xprime(:,2) = xprime(:,2).*26.3;
xprime(:,3) = xprime(:,3).*0.7;

%Re-dimensionalizing results at time of events
ye(:,1) = ye(:,1).*1.3;
ye(:,2) = ye(:,2).*26.3;
ye(:,3) = ye(:,3).*0.7;

% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
x = [3,Inf];

for i = 1:size(t)
   tectsol = sm90Tectonic(t(i));
   x(1,i) = xprime(i,1) + tectsol(1);
   x(2,i) = xprime(i,2) + tectsol(2);
   x(3,i) = xprime(i,3) + tectsol(3);
end

x = x';
D = [te ye;t x];

% Saving data as a txt file
storeData(D,fileName,filePath,4);

% Separating out solutions
I = squeeze(x(:,1));
Mu = squeeze(x(:,2));
Theta = squeeze(x(:,3));


%The following plots are for the solutions without the tectonic solution
%3-D plot of the solutions
if plotflag
   X = [min(I):0.1:max(I)];
   Y = [min(Mu):0.1:max(Mu)];
   Z = [min(Theta):0.1:max(Theta)];
   figure;
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

if timeflag
   figure;
   subplot(3,1,1)
   plot(t,I,'-')
   %set(gca,'xdir','reverse')
   title(strcat('SM90',descr,' (u=',num2str(param(5)),', p=',num2str(param(1)),')'));
   ylabel('global ice mass')
   subplot(3,1,2)
   plot(t,Mu,'-')
   %set(gca,'xdir','reverse')
   ylabel('CO2 concentration')
   subplot(3,1,3)
   plot(t,theta,'-')
   %set(gca,'xdir','reverse')
   ylabel('global mean ocean temp')
   xlabel('time (10 ka)')
     
   % Save temporal plots
   %print(gcf,'-djpeg','sm90_tempplot_laskarInsol');
   %print(gcf,'-djpeg','sm90_tempplot3_integinsol');
   %print(gcf,'-djpeg',strcat('SM90_',num2str(runID),' ',descr, 'tempplot'))

end %if
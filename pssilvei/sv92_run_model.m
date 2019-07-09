% Calculates the output of Saltzman and Maasch's 1991 climate model.
% Need the following to run:
%   sv92Full.m
%   sv92_params.m

% Date: 7 August 2018
% Author: Raymart Ballesteros

addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));
%addpath(genpath('/nfsbigdata1/campgrp/brknight/Lib/Matlab'));

sm91_params

tic

options = odeset('Events',@sm91_co2_events);

% Simulation of Pleistocene departure model:
%[t,xprime] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0);
[t,xprime,te,ye,ie] = ode45(@(t,x) sv92Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,Rw,insolT,insol),tspan,x0,options);

% Re-dimensionalizing the results
xprime(:,1) = xprime(:,1).*2.0;
xprime(:,2) = xprime(:,2).*52.5;
xprime(:,3) = xprime(:,3).*0.9;

ye(:,1) = ye(:,1).*2.0;
ye(:,2) = ye(:,2).*52.5;
ye(:,3) = ye(:,3).*0.9;

% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
x = [3,Inf];
xfull = [3,Inf];

for i = 1:size(t)
   tectsol = sm91Tectonic(t(i));
   x(1,i) = xprime(i,1);
   x(2,i) = xprime(i,2);
   x(3,i) = xprime(i,3);
   
   xfull(1,i) = xprime(i,1) + tectsol(1);
   xfull(2,i) = xprime(i,2) + tectsol(2);
   xfull(3,i) = xprime(i,3) + tectsol(3);
end

% Separate out solutions.
%t = tphys;
I = squeeze(x(1,:))';
Mu = squeeze(x(2,:))';
Theta = squeeze(x(3,:))';


xfull = xfull';
D = [te ye;t I Mu Theta];
%Dfull = [t xfull];

%storeData(D,fileName,filePath,4);
%storeData(Dfull,fileName2,filePath,4);

toc


figure(1)
clf
t = 10.*flipud(t);
subplot(4,1,1)
plot(t,-xprime(:,1),'-')
%set(gca,'xdir','reverse')
title(strcat('SM91',descr,' (u=',num2str(param(3)),', p=',num2str(param(1)),')'));
ylabel('ice mass')
subplot(4,1,2)
plot(t,xprime(:,2),'-')
%set(gca,'xdir','reverse')
ylabel('CO2')
subplot(4,1,3)
plot(t,xprime(:,3),'-')
%set(gca,'xdir','reverse')
ylabel('ocean temp')
subplot(4,1,4)
plot(t,param(3).*insol,'-')
%set(gca,'xdir','reverse')
ylabel('forcing')
xlabel('time (kya)')
   
% Save temporal plots
%print(gcf,'-djpeg',strcat('SM91_',num2str(runID),'_',descr, '_forcing','_u=',num2str(param(3))))


% Plotting in phase space
%figure;
%hold on;
%plot(Mu./52.5,Theta./0.9,'k-')
%syms y z
%fimplicit(-z + 1.3*y - 0.6*y^2 - y^3)
%xlabel('Mu')
%ylabel('Theta')

%figure;
%hold on;
%plot3(Mu./52.5,Theta./0.9,I./2,'k-')
%plot3(Mu,Theta,I,'k-')
%syms x y z
%h1 = fimplicit3(-z + 1.3*y - 0.6*y^2 - y^3);
%h2 = fimplicit3(-x-y-0.2*z);
%h3 = fimplicit3(-2.5*(x+z));
%h1.FaceAlpha = 0.5;
%h2.FaceAlpha = 0.35;
%h3.FaceAlpha = 0.5;
%ylabel('Theta')
%xlabel('Mu')
%zlabel('I')
%view(50,50)
%view(0,0)
%view(0,90)
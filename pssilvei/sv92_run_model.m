% Calculates the output of Saltzman and Maasch's 1991 climate model.
% Need the following to run:
%   sv92Full.m
%   sv92_params.m

% Date: 7 August 2018
% Author: Raymart Ballesteros

addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));
addpath(genpath('/nfsbigdata1/campgrp/Data'));
addpath(genpath('C:\Users\Perrin\Documents\Gitprojects\campgrp\Data'));
addpath(genpath('C:\Users\perri\Documents\Gitprojects\campgrp\Data'));


%addpath(genpath('/nfsbigdata1/campgrp/brknight/Lib/Matlab'));

sv92_params

tic

%options = odeset('Events',@sm91_co2_events);
options=odeset('OutputFcn',@odeprog,'Events',@odeabort,'RelTol',1e-5);

% Simulation of Pleistocene departure model:
%[t,xprime] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0);
[t,xprime,te,ye,ie] = ode45(@(t,x) sv92Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,Rw,insolT,insol),tspan,x0,options);

% Re-dimensionalizing the results
%xprime(:,1) = xprime(:,1).*2.0;
%xprime(:,2) = xprime(:,2).*52.5;
%xprime(:,3) = xprime(:,3).*0.9;
%xprime(:,4) = xprime(:,4).*1.0;

%ye(:,1) = ye(:,1).*2.0;
%ye(:,2) = ye(:,2).*52.5;
%ye(:,3) = ye(:,3).*0.9;
%ye(:,4) = ye(:,4).*1.0;


% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
x = [3,Inf];
xfull = [3,Inf];

for i = 1:size(t)
   tectsol = sm91Tectonic(t(i));
   x(1,i) = xprime(i,1);
   x(2,i) = xprime(i,2);
   x(3,i) = xprime(i,3);
   x(4,i) = xprime(i,4);
   
   xfull(1,i) = xprime(i,1) + tectsol(1);
   xfull(2,i) = xprime(i,2) + tectsol(2);
   xfull(3,i) = xprime(i,3) + tectsol(3);
   %xfull(4,i) = xprime(i,4) + tectsol(4);
end

% Separate out solutions.
%t = tphys;
I = squeeze(x(1,:))';
Mu = squeeze(x(2,:))';
Theta = squeeze(x(3,:))';
D = squeeze(x(4,:))';

xfull = xfull';
Data = [te ye;t I Mu Theta D];
%Datafull = [t xfull];

%storeData(Data,fileName,filePath,4);
%storeData(Datafull,fileName2,filePath,4);

toc

cutoff = 5e4;

figure(1)
clf
t = 10.*flipud(t);
subplot(5,1,1)
plot(t,-xprime(:,1),'-')
%set(gca,'xdir','reverse')
title(strcat('SM91',descr,' (u=',num2str(param(3)),', p=',num2str(param(1)),')'));
ylabel('ice mass')
subplot(5,1,2)
plot(t,xprime(:,2),'-')
%set(gca,'xdir','reverse')
ylabel('CO2')
subplot(5,1,3)
plot(t,xprime(:,3),'-')
%set(gca,'xdir','reverse')
ylabel('ocean temp')
subplot(5,1,4)
plot(t,xprime(:,4),'-')
%set(gca,'xdir','reverse')
ylabel('bedrock depression')
%subplot(5,1,5)
%plot(t,param(3).*insol,'-')
%set(gca,'xdir','reverse')
%ylabel('forcing')
   
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
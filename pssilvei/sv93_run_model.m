% Calculates the output of Saltzman and Maasch's 1991 climate model.
% Need the following to run:
%   sv92Full.m
%   sv92_params.m

% Date: 7 August 2018
% Author: Raymart Ballesteros

function outputs = sv93_run_model(override);
addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));
addpath(genpath('/nfsbigdata1/campgrp/Data'));
addpath(genpath('C:\Users\Perrin\Documents\Gitprojects\campgrp\Data'));
addpath(genpath('C:\Users\perri\Documents\Gitprojects\campgrp\Data'));
% addpath(genpath('C:\Users\Perrin\Documents\Gitprojects\campgrp\pssilvei\rjballes\Library\sm91\IntegratedParamSearch\'));
% addpath(genpath('C:\Users\perri\Documents\Gitprojects\campgrp\pssilvei\rjballes\Library\sm91\IntegratedParamSearch\'));


%addpath(genpath('/nfsbigdata1/campgrp/brknight/Lib/Matlab'));
if nargin > 0
    params = sv93_params(override);
else
    params = sv93_params();
end
    


%tic

%options = odeset('Events',@sm91_co2_events);
%options=odeset('OutputFcn',@odeprog,'Events',@odeabort,'RelTol',1e-4);%Do not use this on dirac, only locally. Progress bar for ode.
options = odeset('RelTol',1e-4);%Use this on dirac instead

% Simulation of Pleistocene departure model:
%[t,xprime] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0);
[t,xprime] = ode45(@(t,x) sv93Full(t,x,params),params.tspan,params.x0,options);

% Re-dimensionalizing the results
xprime(:,1) = xprime(:,1).*params.massscale;
xprime(:,2) = xprime(:,2).*params.distancescale;
xprime(:,3) = xprime(:,3).*params.co2scale + params.mutildestar + transpose([5e3:-1e0:0]*params.mutildedot);
xprime(:,4) = xprime(:,4).*params.tempscale;

%ye(:,1) = ye(:,1).*2.0;
%ye(:,2) = ye(:,2).*52.5;
%ye(:,3) = ye(:,3).*0.9;
%ye(:,4) = ye(:,4).*1.0;


% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
% x = [3,Inf];
% xfull = [3,Inf];
% 
 for i = 1:size(t)
    tectsol = sm91Tectonic(t(i));
    xprime(1,i) = xprime(i,1) ;%+ tectsol(1);
    xprime(2,i) = xprime(i,2);
    xprime(3,i) = xprime(i,3);% + tectsol(2);
    xprime(4,i) = xprime(i,4) ;%+ tectsol(3);

    

 end

% Separate out solutions.
%t = tphys;
% I = squeeze(xprime(:,1))';
% D = squeeze(xprime(:,2))';
% Mu = squeeze(xprime(:,3))';
% Theta = squeeze(xprime(:,4))';

I = squeeze(xprime(1,:))';
D = squeeze(xprime(2,:))';
Mu = squeeze(xprime(3,:))';
Theta = squeeze(xprime(4,:))';

%xfull = xfull';
%Data = [te ye;t I Mu Theta D];
%Datafull = [t xfull];

%storeData(Data,fileName,filePath,4);
%storeData(Datafull,fileName2,filePath,4);

%toc
t = params.timescale.*flipud(t);
outputs = [I,D,Mu,Theta,t];
end
% %figure(1)
% %clf
% subplot(5,1,1)
% plot(t,xprime(:,1),'-')
% %set(gca,'xdir','reverse')
% title(strcat('SV92','Unforced'));
% ylabel('Ice mass')
% subplot(5,1,2)
% plot(t,xprime(:,2),'-')
% %set(gca,'xdir','reverse')
% ylabel('Bedrock depression')
% subplot(5,1,3)
% plot(t,-xprime(:,3),'-')
% %set(gca,'xdir','reverse')
% ylabel('CO2')
% subplot(5,1,4)
% plot(t,xprime(:,4),'-')
% %set(gca,'xdir','reverse')
% ylabel('Ocean temp')
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
% Calculates the output of Saltzman and Maasch's 1991 climate model.
% Need the following to run:
%   sv92Full.m
%   sv92_params.m

% Date: 7 August 2018
% Author: Raymart Ballesteros

function outputs = sv92_run_model(override);
addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));
addpath(genpath('/nfsbigdata1/campgrp/Data'));
addpath(genpath('C:\Users\Perrin\Documents\Gitprojects\campgrp\Data'));
addpath(genpath('C:\Users\perri\Documents\Gitprojects\campgrp\Data'));
format long e

%addpath(genpath('/nfsbigdata1/campgrp/brknight/Lib/Matlab'));
if nargin > 0
    params = sv92_params(override);
else
    params = sv92_params();
end
    


%tic
%options = odeset('Events',@sm91_co2_events);
%options = odeset('Events',@(T,Y) sm91_ice_events(T,Y,param));
%options=odeset('OutputFcn',@odeprog,'Events',@odeabort,'RelTol',1e-4);%Do not use this on dirac, only locally. Progress bar for ode.
options = odeset('RelTol',1e-4,'Events',@(t,x) sv92modelswitch(t,x,params));%Use this on dirac instead

% Simulation of Pleistocene departure model:
%[t,xprime] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0);
[t,xprime,te,ye,ie] = ode45(@(t,x) sv92Full(t,x,params),params.tspan,params.x0,options);
t = t(1:end-1); xprime = xprime(1:end-1,:);
while t(end)< params.tspan(end-1)
    holder = [t,xprime];holder2 = [te,ye,ie];
    %disp([holder2(end,1) params.tspan(length(t)+1:end)])
    %disp(holder2(end,2:5))
    [t,xprime,te,ye,ie] = ode45(@(t,x) sv92Full(t,x,params),[holder2(end,1) params.tspan(length(t)+1:end)],holder2(end,2:5),options);
    newstuff1 = [t,xprime];newstuff2=[te,ye,ie];
    %disp(newstuff1)
    %disp(newstuff2)
    full = [holder;newstuff1(2:end-1,:)];
    full2 = [holder2;newstuff2];
    t = full(:,1);
    xprime = full(:,2:5);
    te = full2(:,1);
    ye = full2(:,2:5);
    ie = full2(:,6);
end


% Re-dimensionalizing the results
xprime(:,1) = xprime(:,1).*params.massscale;
xprime(:,2) = xprime(:,2).*params.distancescale;
xprime(:,3) = xprime(:,3).*params.co2scale;
xprime(:,4) = xprime(:,4).*params.tempscale;
te = te.*params.timescale;
if ismatrix(ye)
ye(:,1) = ye(:,1).*params.massscale;
ye(:,2) = ye(:,2).*params.distancescale;
ye(:,3) = ye(:,3).*params.co2scale;
ye(:,4) = ye(:,4).*params.tempscale;
end
if isvector(ye)
ye(:,1) = ye(1).*params.massscale;
ye(:,2) = ye(2).*params.distancescale;
ye(:,3) = ye(3).*params.co2scale;
ye(:,4) = ye(4).*params.tempscale;
end
% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
% x = [3,Inf];
% xfull = [3,Inf];
% 
 cyclemark = [1:1:size(t)];
 for i = 1:size(t)

%    tectsol = sm91Tectonic(t(i));
    if i >= size(t)-1
        cyclemark(i) = 0;
    elseif xprime(i,1) - xprime(i+1,1) > 1*params.massscale
     cyclemark(i) = 1;
    else
        cyclemark(i) = 0;
    end
    x(1,i) = xprime(i,1);
    x(2,i) = xprime(i,2);
    x(3,i) = xprime(i,3);
    x(4,i) = xprime(i,4);
%    
%    xfull(1,i) = xprime(i,1) + tectsol(1);
%    xfull(2,i) = xprime(i,2) + tectsol(2);
%    xfull(3,i) = xprime(i,3) + tectsol(3);
%    %xfull(4,i) = xprime(i,4) + tectsol(4);
 end

% Separate out solutions.
%t = tphys;
I = squeeze(x(1,:))';
D = squeeze(x(2,:))';
Mu = squeeze(x(3,:))';
Theta = squeeze(x(4,:))';

%xfull = xfull';
%Data = [te ye;t I Mu Theta D];
%Datafull = [t xfull];

%storeData(Data,fileName,filePath,4);
%storeData(Datafull,fileName2,filePath,4);

%toc
t = params.timescale.*flipud(t);
cyclemark = transpose(cyclemark);
outputs = padconcatenation([I,D,Mu,Theta,t,cyclemark],[5000*params.timescale-te,ye(:,1),ye(:,2),ye(:,3),ye(:,4)],2);
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
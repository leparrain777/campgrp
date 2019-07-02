% This script plots the solutions against time
% Need:
%   I := output of ice mass
%   Mu := output of co2
%   Theta := output of ocean temperature
%   t := vector of time span

% Setting values/params for reading data from model run
runID = 77;
%descr = 'solsticeLaskar';
%descr = 'insolHuybersIntegrated';
descr = 'insolLaskar';
%descr = 'Unforced';

u = 0.599;
p = 1;

fileName = sprintf('SM91_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/';

[D,te,ye] = readSM91Data(fileName,filePath,4);

% Separating variables
t = D(:,1);
%te = flipud(te);
I = D(:,2);
Mu = D(:,3);
Theta = D(:,4);

figure;
subplot(3,1,1)
hold on;
plot(t,-I,'k-')
plot(te(1:2:end),-ye(1:2:end,1),'r.','MarkerSize',9)
plot(te(2:2:end),-ye(2:2:end,1),'b.','MarkerSize',9)
%set(gca,'xdir','reverse')
title(strcat('SM91,',descr,' (u=',num2str(u),', p=',num2str(p),')'));
ylabel('global ice mass')
subplot(3,1,2)
hold on;
plot(t,Mu,'k-')
plot(te(1:2:end),ye(1:2:end,2),'r.','MarkerSize',9)
plot(te(2:2:end),ye(2:2:end,2),'b.','MarkerSize',9)
%set(gca,'xdir','reverse')
ylabel('CO2 concentration')
subplot(3,1,3)
hold on;
plot(t,Theta,'k-')
plot(te(1:2:end),ye(1:2:end,3),'r.','MarkerSize',9)
plot(te(2:2:end),ye(2:2:end,3),'b.','MarkerSize',9)
%set(gca,'xdir','reverse')
ylabel('global mean ocean temp')
xlabel('time (10 ka)')
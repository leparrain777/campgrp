% This script plots the solutions against time
% Need:
%   I := output of ice mass
%   Mu := output of co2
%   Theta := output of ocean temperature
%   t := vector of time span

% Setting values/params for reading data from model run
runID = 114;
%descr = 'solsticeLaskar';
%descr = 'insolHuybersIntegrated';
descr = 'insolLaskar';
%descr = 'unforced';

u = 0.374;
p = 1;

saveFlag = 1;

%fileName = sprintf('SM90_%s_%d_forcing_Model.txt',descr,runID);
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/';
fileName = sprintf('SM90_%s_%d_Model.txt',descr, runID);
filePath = '~/campgrp/rjballes/ModelRuns/sm90/Forced/';

[D,te,ye] = readSM90Data(fileName,filePath,4);

% Separating variables
%t = flipud(D(:,1));
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
%set(gca,'XDir','reverse')
title(strcat('SM90,',descr,' (u=',num2str(u),', p=',num2str(p),')'));
%ylabel('global ice mass')
ylabel('I')
subplot(3,1,2)
hold on;
plot(t,Mu,'k-')
plot(te(1:2:end),ye(1:2:end,2),'r.','MarkerSize',9)
plot(te(2:2:end),ye(2:2:end,2),'b.','MarkerSize',9)
%set(gca,'XDir','reverse')
%ylabel('CO2 concentration')
ylabel('Mu')
subplot(3,1,3)
hold on;
plot(t,Theta,'k-')
plot(te(1:2:end),ye(1:2:end,3),'r.','MarkerSize',9)
plot(te(2:2:end),ye(2:2:end,3),'b.','MarkerSize',9)
%set(gca,'XDir','reverse')
%ylabel('global mean ocean temp')
ylabel('Theta')
xlabel('time (10 ka)')

if saveFlag
   fname = sprintf('sm90_run%d_tempplot',runID);
   %fname = sprintf('sm90Full_%s_sols',descr);
   print(fname,'-djpeg')
end %if
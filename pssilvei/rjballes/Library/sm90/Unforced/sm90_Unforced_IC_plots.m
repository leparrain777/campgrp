% This script reads through the data for varying initial conditions and 
% produces temporal plots of solutions and plot for clustering in phase space

%descr = 'insolHuybersIntegrated';
%descr = 'insolLaskar';
descr = 'Unforced';

filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/Unforced/';

figure;
hold on;
for k=1:25:100
   fileName = sprintf('SM90_%s_IC%d_Model.txt',descr,k);
   filePath = '/nfsbigdata1/campgrp/rjballes/ICRuns/sm90/Unforced/';
   D = readData(fileName,filePath,4);

   t = flipud(D(2:end,1));
   I = D(2:end,2);
   Mu = D(2:end,3);
   Theta = D(2:end,4);
   
   %subplot(3,1,1)
   plot(t,-I,'-')
   %subplot(3,1,2)
   %plot(t,Mu,'-')
   %subplot(3,1,3)
   %plot(t,Theta,'-')
   
   
end %for
hold off;

%figure;
%subplot(2,3,1)
%hold on;
%for k=1:100
%   fileName = sprintf('SM90_%s_IC%d_Model.txt',descr,k);
%   %filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/Unforced/';
%   D = readSM90Data(fileName,filePath,4);

%   t = flipud(D(2:end,1));
%   I = D(2:end,2);
%   Mu = D(2:end,3);
%   Theta = D(2:end,4);
%   
%   plot(Mu(1),I(1),'o')
%end %for
%title('SM90 Unforced Model (100 iterations), t=0')
%xlabel('co2 concentration')
%ylabel('global ice mass')
%hold off;

%subplot(2,3,2)
%hold on;
%for k=1:100
%   fileName = sprintf('SM90_%s_IC%d_Model.txt',descr,k);
%   %filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/Unforced/';
%   D = readSM90Data(fileName,filePath,4);

%   t = flipud(D(2:end,1));
%   I = D(2:end,2);
%   Mu = D(2:end,3);
%   Theta = D(2:end,4);
%   
%   plot(Mu(1001),I(1001),'o')
%end %for
%sm90_plotLimitCycle
%title('t=1000(ky)')
%xlabel('co2 concentration')
%ylabel('global ice mass')
%hold off;

%subplot(2,3,3)
%hold on;
%for k=1:100
%   fileName = sprintf('SM90_%s_IC%d_Model.txt',descr,k);
%   %filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/08062018/';
%   D = readSM90Data(fileName,filePath,4);

%   t = flipud(D(2:end,1));
%   I = D(2:end,2);
%   Mu = D(2:end,3);
%   Theta = D(2:end,4);
%   
%   plot(Mu(2001),I(2001),'o')
%end %for
%sm90_plotLimitCycle
%title('t=2000(ky)')
%xlabel('co2 concentration')
%ylabel('global ice mass')
%hold off;

%subplot(2,3,4)
%hold on;
%for k=1:100
%   fileName = sprintf('SM90_%s_IC%d_Model.txt',descr,k);
%   %filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/08062018/';
%   D = readSM90Data(fileName,filePath,4);

%   t = flipud(D(2:end,1));
%   I = D(2:end,2);
%   Mu = D(2:end,3);
%   Theta = D(2:end,4);
%   
%   plot(Mu(3001),I(3001),'o')
%end %for
%sm90_plotLimitCycle
%title('t=3000(ky)')
%xlabel('co2 concentration')
%ylabel('global ice mass')
%hold off;

%subplot(2,3,5)
%hold on;
%for k=1:100
%   fileName = sprintf('SM90_%s_IC%d_Model.txt',descr,k);
%   %filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/08062018/';
%   D = readSM90Data(fileName,filePath,4);

%   t = flipud(D(2:end,1));
%   I = D(2:end,2);
%   Mu = D(2:end,3);
%   Theta = D(2:end,4);
%   
%   plot(Mu(4001),I(4001),'o')
%end %for
%sm90_plotLimitCycle
%title('t=4000(ky), SM90 Unforced')
%xlabel('co2 concentration')
%ylabel('global ice mass')
%hold off;

%subplot(2,3,6)
%hold on;
%for k=1:50
%   fileName = sprintf('SM90_%s_IC%d_Model.txt',descr,k);
%   %filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/08062018/';
%   D = readSM90Data(fileName,filePath,4);

%   t = flipud(D(2:end,1));
%   I = D(2:end,2);
%   Mu = D(2:end,3);
%   Theta = D(2:end,4);
%   
%   plot(Mu(5001),I(5001),'o')
%end %for
%sm90_plotLimitCycle
%title('t=5000(ky), SM90 Unforced')
%xlabel('co2 concentration')
%ylabel('global ice mass')
%hold off;
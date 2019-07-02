% Calculates the output of Saltzman and Maasch's 1991 climate model.

% Date: 17 August 2014
% Author: Andrew Gallatin

params

% Simulation of Pleistocene departure model:
[t,xprime] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0);

% Re-dimensionalizing the results
xprime(:,1) = xprime(:,1).*2.0;
xprime(:,2) = xprime(:,2).*52.5;
xprime(:,3) = xprime(:,3).*0.9;

% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
x = [3,Inf];

for i = 1:size(t)
   tectsol = sm91Tectonic(t(i));
   x(1,i) = xprime(i,1) + tectsol(1);
   x(2,i) = xprime(i,2) + tectsol(2);
   x(3,i) = xprime(i,3) + tectsol(3);
end

% Separate out solutions.
t = tphys;
I = squeeze(x(1,:))';
Mu = squeeze(x(2,:))';
Theta = squeeze(x(3,:))';

I_trim = I(3000:5001);

      [eemdFig,nmodes] = PlotEEMD(I_trim,0.5,2000,6);

      preccLate = nmodes(1501:2001,4);
      preccEarly = nmodes(1:501,4);

      obliqEarly = nmodes(1:501,5);
      obliqLate = nmodes(1501:2001,5);

      eccentLate = nmodes(1501:2001,6);
      eccentEarly = nmodes(1:501,6);
      
      roughEccLatePeriod = size(crossing(eccentLate),2)/2/500;

      variance(1) = param(3);
      variance(2) = var(obliqEarly)/var(eccentLate);
      variance(3) = var(preccLate)/var(obliqLate);
      variance(4) = var(preccEarly)/var(obliqEarly);
      variance(5) = var(obliqLate);
      variance(6) = var(obliqEarly);
      variance(7) = var(eccentLate);
      variance(8) = var(eccentEarly);
      variance(9) = param(1);
      variance(10) = roughEccLatePeriod;
      
      eemdFig = PlotEEMDDataTrend(nmodes,3,7);
      title(strcat('SM91 EEMD (u=',num2str(variance(1)),', p=',num2str(variance(9)),')'));
      print(gcf,'-dpdf',strcat('SM91_u=',num2str(variance(1)),'_p=',num2str(variance(9)),'EEMD'));

      fid = fopen('/nfsbigdata1/campgrp/agallati/sm91/TheAllTuned/statisticsOut_ver2.txt','a');
      fprintf(fid,'%1$f %9$f %2$f %10$f %3$f %4$f %5$f %6$f %7$f %8$f\r\n',variance(1),variance(2),variance(3),variance(4),variance(5),variance(6),variance(7),variance(8),variance(9),variance(10));
      fclose(fid);

storeData(nmodes,'SM91_EEMD_Data.txt','/nfsbigdata1/campgrp/agallati/sm91/TheAllTuned/',size(nmodes,2));

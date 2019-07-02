addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));

tic

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
tspan = [0:0.1:500];

% Initial conditions are chosen arbitrarily based loosely on the Saltzman 1991 paper.
x0 = [0 0 0];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := p
%	param(2) := q
%	param(3) := u
%	param(4) := v
% The rest of the parameters that show up in the model are dealt with as 
% functions of time to achieve the bifurcation or stochastic modelling.  
uspan = 0.6:-0.02:0.4;
pspan = 0.9:0.02:1.2;


% Set up the changing parameters:
parT = [0:0.1:500]';
U = -35*(parT/100) + 425;
R = (2*2.6*10^(-5).*U - 3*3.6*10^(-8)*(U.^2) - 6.3*10^(-3)) / (1*10^(-4)) + 2;
S = (3*3.6*10^(-8).*U - 2.6*10^(-5)) / (sqrt(1*10^(-4)*3.6*10^(-8))); 

% Set up the stochastic terms:
Rt = [0:0.1:500]';
Rx = -0.025 + 0.05.*rand(5001,1);
Ry = -0.025 + 0.05.*rand(5001,1);
Rz = -0.025 + 0.05.*rand(5001,1);

% Set up the insolation forcing:
[insolT,insol] = integratedInsolation(0,5000);

insolT = [0:0.1:500];

insol = (insol - mean(insol))/std(insol);
insol = insol(end:-1:1);


for k = 1:1:size(uspan,2)
   for l = 1:1:size(pspan,2)
      param = [pspan(l) 2.5 uspan(k) 0.2];
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
      end %for

      I = squeeze(x(1,:))';
      Mu = squeeze(x(2,:))';
      Theta = squeeze(x(3,:))';

      I_trim = I(3000:5001);

      [eemdFig,nmodes] = PlotEEMD(I_trim,0.5,2000,6);

      obliqEarly = nmodes(1:751,5);

      eccentLate = nmodes(1501:2001,6);
	  
	  varTune = var(obliqEarly)/var(eccentLate);
      
      roughEccLatePeriod = size(crossing(eccentLate),2)/2/500;

	  
      
      eemdFig = PlotEEMDDataTrend(nmodes,6,8);
      title(strcat('SM91 EEMD (u=',num2str(uspan(k)),', p=',num2str(pspan(l)),')'));
      print(gcf,'-dpdf',strcat('SM91_u=',num2str(uspan(k)),'_p=',num2str(pspan(l)),'EEMD'));
	  
	  storeData(nmodes,strcat('SM91_u=',num2str(uspan(k)),'_p=',num2str(pspan(l)),'EEMD_Data.txt'),'/nfsbigdata1/campgrp/agallati/sm91/IntegratedParamSearch_442016/Data/',size(nmodes,2));

      fid = fopen('/nfsbigdata1/campgrp/agallati/sm91/IntegratedParamSearch_442016/statisticsOut.txt','a');
      fprintf(fid,'%1$f %2$f %3$f %4$f\r\n',uspan(k),pspan(l),varTune,roughEccLatePeriod);
      fclose(fid);
   end %for pspan
end %for uspan


toc

exit

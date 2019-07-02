% This script reads through the data for varying initial conditions and 
% produces temporal plots of solutions and plot for clustering in phase space

run_num = 5;
num_runs = 200;

%descr = 'insolHuybersIntegrated';
%descr = 'insolLaskar';
descr = 'solsticeLaskar';
%descr = 'Unforced';

temporalFlag = 1;
projFlag = 0;

fileName = sprintf('SM90_ICRun%d_%d.txt',run_num,num_runs);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/';

%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/Unforced/';
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/HuybersIntegrated_p=1_u=0.6/08162018/';
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/HuybersIntegrated_p=1.14_u=1.36/08162018/';
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/LaskarAstronomical_p=1_u=0.6/08072018/';
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/solsticeLaskar_p=1_u=0.6/08092018/';

[t,Iout,Muout,Thetaout,insol,IC] = readSM90_IC(run_num,num_runs);

if temporalFlag
   figure;
   hold on;
   t1 = 1;
   t2 = 5001;
   for k=1:num_runs
      %fileName = sprintf('SM90_%s_IC%d_Model.txt',descr,k);
      
      %D = readData(fileName,filePath,4);
   
      %t = flipud(D(2:end,1));
      %I = D(2:end,2);
      %Mu = D(2:end,3);
      %Theta = D(2:end,4);
      %plot3(t,Mu,I,'-')
      
      plot3(t(5001:-1:1),Muout(t1:t2),-Iout(t1:t2),'-')
      t1 = t1+5001;
      t2 = t2+5001;
      
            
   end %for
   hold off;
   zlabel('ice mass')
   ylabel('co2')
   xlabel('time (ky)')
   title(['SM90, ',descr,', ', num2str(num_runs),' ICs'])
   view(20,20)
   
end %if

if projFlag
   % Producing a plot of the points at each time interval in Mu-I space
   time_steps = 0:100:500;
   figure;
   for j=1:length(time_steps)
      index = find(t==time_steps(j));
      subplot(2,3,j)
      hold on;
      plot(Muout(index),Iout(index),'.','MarkerSize',7)
      if j > 1
         sm90_plotLimitCycle
      end %if
      title(sprintf('Varying IC Solutions at t = %d', time_steps(j)));
      xlabel('co2 concentration')
      ylabel('global ice mass')
      hold off;
   end %for
   
   hold on;
   suptitle(sprintf('Run #%d, %d IC clustering,%s Forcing', run_num, num_runs,descr))


end %if
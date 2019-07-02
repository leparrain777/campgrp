% This scripts reads the unforced model output data for the SM90 model with varying
% values for the parameter p.  Then finds the length of full cycles.

% Finding period of limit cycle in various unforced runs with varying p
runID = 41;
avg_unfor_period = [0];
for p=1:0.2:1.4
   fileName = sprintf('SM90_unforced_%d_Model.txt',runID);
   filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';

   [D,te,ye] = readSM90Data(fileName,filePath,4);

   % Separating variables
   %t = D(:,1);
   %I = D(:,2);
   %Mu = D(:,3);
   %Theta = D(:,4);
   
   if ye(1,2) < ye(2,2)
      tmin = te(7:2:end);
      tmax = te(8:2:end);
   else
      tmin = te(8:2:end);
      tmax = te(9:2:end);
   end %if
   
   full_times = tmin(2:end) - tmin(1:end-1);
   avg_unfor_period = [avg_unfor_period 10*mean(full_times)];
   
   runID = runID+1;

end %for


% Producing figure of distribution of full cycle times and finding avg period of cycle
figure
hold on;
run_num = 24:35;
paramMat = [0.8 0.6; 0.8 1; 0.8 1.4; 1 0.6; 1 1; 1 1.4; 1.2 0.6; 1.2 1; 1.2 1.4; 1.4 0.6; 1.4 1; 1.4 1.4];
full_avg = [];
for k=1:length(run_num)
   fileName = sprintf('SM90_insolHuybersIntegrated_%d_Model.txt',run_num(k));
   filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';

   [data,fullMat,iceMat,eventsMat] = sm90_find_cycles(fileName,filePath);
   tmin = eventsMat(:,1);
   tmax = eventsMat(:,5);
   
   full_times = [];
   for j = 1:length(tmin)-1
      full = tmin(j+1) - tmin(j);
      full_times = [full_times full*10];
   end %for
   
   full_avg = [full_avg mean(full_times)];
   
   subplot(4,3,k)
   histogram(full_times, 'BinMethod', 'integers')
   xlabel('Length of Cycle (kyr)')
   ylabel('Number of Cycles')
   title(sprintf('Run %g with p=%g, u=%g',run_num(k),paramMat(k,1),paramMat(k,2)))
   
end %for


% Producing a table of the average periods of cycle(s)
p = 0.8:0.2:1.4;
u = 0.6:0.4:1.4;
varNames = {'p','Unforced','Weak','Medium','Strong'};
T = table(p',avg_unfor_period',full_avg(1:3:end)',full_avg(2:3:end)',full_avg(3:3:end)','VariableNames',varNames)


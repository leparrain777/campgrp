% This script runs the SM90 model for a set of varying initial conditions
addpath(genpath('/nfsbigdata1/campgrp/Lib/Matlab'));
%addpath(genpath('/nfsbigdata1/campgrp/brknight/Lib/Matlab'));

sm90_IC_params

tic

% Creating an array of the initial conditions
seed_num = 1;
seed = rng(seed_num);
IC = rand(num_runs,3);

% Creating file structure for printing
%storeData(D,fileName,filePath,4);
fileName = sprintf('SM90_ICRun%d_%d.txt',run_num,num_runs);
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/HuybersIntegrated_p=1.14_u=1.36/08162018/';
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/HuybersIntegrated_p=1_u=0.6/08162018/';
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/solsticeLaskar_p=1_u=0.6/08092018/';
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ICRuns/';

file = strcat(filePath, fileName);
fid = fopen(file,'w');

% data formatting
x = '%20.16f';
fmt = ' ';
for i=1:2
    fmt = sprintf('%s %s',fmt,x);
    fmt = strcat(fmt);
end
fmt = strcat(fmt,'\n');


% .txt file header/comment block
fprintf(fid, sprintf('Saltzman and Maasch 1990 Data Block for Varying Initial Conditions, %s forcing, run # %d\n\n',...
                                                                                                        descr,run_num));
fprintf(fid, sprintf('%d Random Initial Condition Model Outputs\n', num_runs));
fprintf(fid, sprintf('%s Forcing, p = %f, u = %f\n', descr,param(1),param(5)));
fprintf(fid, sprintf('seed = rng(%d), random call = rand(3, %d)\n\n',seed_num,num_runs));
fprintf(fid, 'See readSM90_IC.m to read Data\n\n');
fprintf(fid,'Data Structure:\n\n');
fprintf(fid,'First 5000 time steps: %s forcing data.\n\n',descr); 
fprintf(fid,'%d Initial Conditions.\n\n',num_runs); 
fprintf(fid,'Following Data: in ascending order, model output data for each set of randomized initial conditions;\n');
fprintf(fid,'time, I, Mu, Theta.\n\n\n');

% print forcing parameters
fprintf(fid, fmt, [insolT',insol]');

% add another column
fmt = strcat(x,fmt);

% print initial conditions
fprintf(fid, fmt, IC');

% add another column
fmt = strcat(x,fmt);

for k=1:num_runs
   % Setting initial conditions; called from earlier array
   x0 = IC(k,:);
   
   % Simulation of Pleistocene departure model:
   [t,xprime] = ode45(@(t,x) sm90(t,x,param,insolT,insol),tspan,x0);
   
   % Re-dimensionalizing the results
   xprime(:,1) = xprime(:,1).*1.3;
   xprime(:,2) = xprime(:,2).*26.3;
   xprime(:,3) = xprime(:,3).*0.7;

   data = [4,Inf];

   for i=1:size(t)
      data(1,i) = t(i);
      data(2,i) = xprime(i,1);
      data(3,i) = xprime(i,2);
      data(4,i) = xprime(i,3);
   end %for

   % print data to file   
    fprintf(fid, fmt, data);
    
end % for

fclose(fid);
   
   %storeData(nmodes,strcat('SM91_u=',num2str(uspan(k)),'_p=',num2str(pspan(l)),'EEMD_Data.txt'),'/nfsbigdata1/campgrp/agallati/sm91/IntegratedParamSearch_442016/Data/',size(nmodes,2));  


toc
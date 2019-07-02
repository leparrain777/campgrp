% This script reads in the EEMD run, and calculates the ratio between modes 3+4 with modes 5+6.

sm91_params

figFlag = 1;
scaleFlag = 0;

%fileName = sprintf('SM91_%s_%d_forcing_Model.txt',descr, runID);
%filePath = '~/campgrp/rjballes/ModelRuns/sm91/ForcingSearch/';

%forcing = [0 0.7 1.2 3 4 10 0.3 0.6 1 1.5 2 5 0.85 0.9 0.95 1.05 1.1 1.15];
%var_ratio = [];
%for i=15:19
%   runID = i;
%   sm91_readeemd

%   fast = sum(nmodes(:,4:5),2);
%   slow = sum(nmodes(:,6:7),2);

%   varFast = var(fast);
%   varSlow = var(slow);

%   out_ratio = varFast/varSlow;
%   
%   var_ratio = [var_ratio out_ratio];
%   
%end %for

%for i=22:34
%   runID = i;
%   sm91_readeemd

%   fast = sum(nmodes(:,4:5),2);
%   slow = sum(nmodes(:,6:7),2);

%   varFast = var(fast);
%   varSlow = var(slow);

%   out_ratio = varFast/varSlow;
%   
%   var_ratio = [var_ratio out_ratio];
%   
%end %for

%forcing = [0 0.7 1.2 0.2 0.5 1 1.5 2 0.85 0.9 0.95 1.05 1.1 1.15];
%run_num = [15 16 17 23 24 25 26 27 29 30 31 32 33 34];
forcing = 0.54:0.003:0.57;
run_num = 64:74;

var_ratio = [];
%for i=run_num
%   runID = i;
%   sm91_readeemd
%
%   fast = sum(nmodes(:,4:5),2);
%   slow = sum(nmodes(:,6:7),2);
%
%   varFast = var(fast);
%   varSlow = var(slow);
%
%   out_ratio = varFast/varSlow;
%   
%   var_ratio = [var_ratio out_ratio];
%   
%end %for

runID = 77;
sm91_readeemd
tstart = 1;
tend = 800;
for k=1:32
   fast = sum(nmodes(tstart:tend,4:5),2);
   slow = sum(nmodes(tstart:tend,6:7),2);
   
   varFast = var(fast);
   varSlow = var(slow);
   
   out_ratio = varFast/varSlow;
   
   var_ratio = [var_ratio out_ratio];
   
   tstart = tstart+100;
   tend = tend+100;
   
end %for

if figFlag
   figure
   clf
   hold on;
   grid on;
   %scatter(forcing,var_ratio)
   scatter([1:length(var_ratio)],var_ratio,30,'filled')
   %xlabel('forcing strength')
   xticks(8:8:32)
   ylabel('fast/slow ratio')
   title('SM91 Fast/Slow Variance Ratio vs Strength of Forcing')
   % Save plots
   print(gcf,'-djpeg',strcat('SM91_variance5_',descr, '_forcing'))
end %for

if scaleFlag
   figure;
   clf
   subplot(2,2,1)
   scatter(forcing,var_ratio)
   xlabel('forcing strength')
   ylabel('fast/slow ratio')
   title('linear linear')

   subplot(2,2,2)
   scatter(log(forcing),var_ratio)
   xlabel('forcing strength')
   ylabel('fast/slow ratio')
   title('linear log')

   subplot(2,2,3)
   scatter(forcing,log(var_ratio))
   xlabel('forcing strength')
   ylabel('fast/slow ratio')
   title('log linear')

   subplot(2,2,4)
   scatter(log(forcing),log(var_ratio))
   xlabel('forcing strength')
   ylabel('fast/slow ratio')
   title('log log')
   title('SM91 Fast/Slow Variance Ratio vs Strength of Forcing')
   % Save plots
   print(gcf,'-djpeg',strcat('SM91_','variance2','_',descr, '_forcing'))
end %for

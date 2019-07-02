% This script reads in the EEMD run, and calculates the ratio between modes 3+4 with modes 5+6.

sm90_params

figFlag = 1;
scaleFlag = 0;

fileName = sprintf('SM90_%s_%d_forcing_Model.txt',descr, runID);
filePath = '~/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/';

%forcing_vals = [0 0.3 0.6 1 1.5 2 5 10 0.4 1.3 3 4 6 8 0.75 0.8 0.85 0.9 1.05 1.15];
%forcing_vals = [0 0.3 0.6 1 1.5 2 0.4 1.3 0.75 0.8 0.85 0.9 1.05 1.15];
%run_num = [47 48 49 50 51 52 55 56 62 63 64 65 66 67];
forcing_vals = 0.3:0.01:0.4;
run_num = 116:170;

var_ratio = [];
%for i=47:60
%   runID = i;
%   sm90_readeemd

%   fast = sum(nmodes(:,4:5),2);
%   slow = sum(nmodes(:,6:7),2);

%   varFast = var(fast);
%   varSlow = var(slow);

%   out_ratio = varFast/varSlow;
%   
%   var_ratio = [var_ratio out_ratio];
%   
%end %for

%for i=62:67
%   runID = i;
%   sm90_readeemd

%   fast = sum(nmodes(:,4:5),2);
%   slow = sum(nmodes(:,6:7),2);

%   varFast = var(fast);
%   varSlow = var(slow);

%   out_ratio = varFast/varSlow;
%   
%   var_ratio = [var_ratio out_ratio];
%   
%end %for

%for i=run_num
%   runID = i;
%   sm90_readeemd

%   fast = sum(nmodes(:,4:5),2);
%   slow = sum(nmodes(:,6:7),2);

%   varFast = var(fast);
%   varSlow = var(slow);

%   out_ratio = varFast/varSlow;
%   
%   var_ratio = [var_ratio out_ratio];
%   
%end %for

% Finding ratio in 800 kyr blocks from present to past

runID = 115;
sm90_readeemd
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
   figure;
   clf
   hold on;
   grid on
   i_start = 1;
   i_end = 11;
   %for k=1:5
      %scatter(forcing_vals,var_ratio(i_start:i_end),20,'filled')
      scatter([1:length(var_ratio)], var_ratio, 30, 'filled')
      %i_start = i_start+11;
      %i_end = i_end+11;
   %end %for
   %xlabel('forcing strength')
   xticks(8:8:32)
   ylabel('fast/slow ratio')
   title('SM90 Fast/Slow Variance Ratio vs Strength of Forcing')
   % Save plots
   %print(gcf,'-deps',strcat('SM90_','variance1','_','insolLasker', '_forcing'))
   print(gcf,'-djpeg',strcat('SM90_variance5_insolLasker_forcing'))
end %for

if scaleFlag
   figure;
   clf
   subplot(2,2,1)
   scatter(forcing_vals,var_ratio)
   xlabel('forcing strength')
   ylabel('fast/slow ratio')
   title('linear linear')

   subplot(2,2,2)
   scatter(log(forcing_vals),var_ratio)
   xlabel('forcing strength')
   ylabel('fast/slow ratio')
   title('linear log')

   subplot(2,2,3)
   scatter(forcing_vals,log(var_ratio))
   xlabel('forcing strength')
   ylabel('fast/slow ratio')
   title('log linear')

   subplot(2,2,4)
   scatter(log(forcing_vals),log(var_ratio))
   xlabel('forcing strength')
   ylabel('fast/slow ratio')
   title('log log')
   %title('SM90 Fast/Slow Variance Ratio vs Strength of Forcing')
   % Save plots
   %print(gcf,'-deps',strcat('SM90_','variance2','_','insolLasker', '_forcing'))
end %for

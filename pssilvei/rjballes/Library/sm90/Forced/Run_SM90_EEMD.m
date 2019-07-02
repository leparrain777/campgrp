clc
clear all
% You'll need to create a EEMD Param file to store white noise percentage, flags, forcing, and file path names
% for reading/writing, run numbers, etc.. For reference check out '~/campgrp/brknight/Lib/Matlab/PP04_Branch/PP04_Params_EEMD'

% edit these next two lines to correspond to your path struct and Param file
%addMatlabpath_rjballes
sm90_params
%sm90Full_params
SM90_params_EEMD
    
[Data,~,~] = readSM90Data(fileReadName,fileReadPath,4); % Edit the 7 for the number of columns in your output, this will just read each column

x1 = Data(:,2); 
% I am assuming here that Global Ice Mass is the first column of your output, if not, change Data(:,1)
% *NOTE*: this can also be used for analysis of deep ocean temp for comparison with Toby's Temp Data Analysis, might be more interesting?
    
tviews=0;
%tviewf = size(Data,1)-1;
tviewf=5000; % however long of a run you are doing (kyrs)
data=-1.*x1(1:tviewf+1); % Negative sign may or may not be necessary, depedning on your data's orientation?

% --------------------------------
% For EEMD scripts, add '~/campgrp/Lib/Matlab/EEMD' as a general path to your current structure
nmodes = eemd(data,whiteNoise,iterations);
fileName = sprintf('SM90_Run%d_EEMD.txt',run_num); % edit for whatever variable stores your run number 
storeData(nmodes,fileName,filePath,size(nmodes,2));% Assuming you already have access to this script

if EEMDFigFlag == 1
   sm90_plot_eemd(nmodes,[1:size(nmodes,2)],1);
end

% -----------------------------------

disp('done')
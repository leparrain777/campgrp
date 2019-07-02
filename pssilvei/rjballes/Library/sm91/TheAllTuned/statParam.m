%readModelDatascript
%HuybersAvgScript
%nmodesModel = readData('DO18Run4wn.5Modes.txt','/nfsbigdata1/campgrp/rsmith49/Data/',11);
%nmodesModel = nmodesAvg; % must be already interpolated, with time running  
               % forward as indices increase
%nmodesModel = readData('HuybersInsolEEMD.txt','/nfsbigdata1/campgrp/rsmith49/Data/',11);
%nmodesModel = readData('Saltzman_eemd_2000kya.txt','/nfsbigdata1/campgrp/rsmith49/Data/',11);
nmodesModel = readData('SM91_u=0.64_p=1.1EEMD_Data.txt','/nfsbigdata1/campgrp/agallati/sm91/TheAllTuned/',11);
nmodesModel = nmodesModel(2:end,:);

StatFlag = 1; % if you want the stats output to the command line
FigFlag = 1; % if you want the figures plotted
FileSaveFlag = 1; % if you want the stats saved based on the file names/paths
FileSaveFlag2 = 0; % for use with Huybers averaging
FigSaveFlag = 1; % if you want the figures saved as pdf's

statFileName = 'SM91_AllTuned_Stats.txt';
statFilePath = '/nfsbigdata1/campgrp/agallati/sm91/TheAllTuned/';
statFigPath = '/nfsbigdata1/campgrp/agallati/sm91/TheAllTuned/';
FigFileName1 = 'SFigure1_DO18_2.pdf';
FigFileName2 = 'SFigure2_DO18_2.pdf';
FigFileName3 = 'SFigure3_DO18_2.pdf';
FigFileName4 = 'SFigure4_DO18_2.pdf';
FigFileName5 = 'SFigure5_DO18_2.pdf';
%ModelName = '\delta^{18}O Anomally';
ModelName = 'Saltzman and Maasch';

TimeScale = 2000; %length of model - 1
distBetweenModes = 3; % for displaying the eemd output
oblCutoffE = 750; % length of cross correlation with obliquity early and late
oblCutoffL = 900;
EccCutoff = 900; % length of cross correlation with modified eccentricity late
imfnumObl = 5; % obliquity imf
imfnumEcc1 = 6; % ecc imf 1
imfnumEcc2 = 7; % ecc imf 2
imfnumRayleighs = [5 6 7]'; % IMF's to use in calculating Rayleighs R (smoother)
cpsdIntv = 750; % length of time used in cross spectral density

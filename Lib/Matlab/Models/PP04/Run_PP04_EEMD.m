clc
clear all
addMatlabpath
PP04_Params_EEMD
    
Data = readData(fileReadName,fileReadPath,7);
Vout=Data(:,2);
    
tviews=0;
tviewf=2000;
data=-1*Vout(1:tviewf+1);

% --------------------------------

nmodes = eemd(data,whiteNoise,iterations);
fileName = sprintf('PP04_Run%d_EEMD.txt',run_num);
storeData(nmodes,fileName,filePath,size(nmodes,2));

if EEMDFigFlag == 1
    figure
    Only_Plot_EEMD(nmodes,[1:size(nmodes,2)]);
end

% -----------------------------------

disp('done')
function nmodes = PP04_Read_EEMD(run_num)
%This function takes the run number and gets the EEMD data
%This only forks for nmodes being 11 columns
%

fileName = sprintf('PP04_Run%d_EEMD.txt',run_num);
filePath = '~/campgrp/Lib/Matlab/Models/PP04/EEMD_Runs/';
nmodes= readData(fileName,filePath,11);
end
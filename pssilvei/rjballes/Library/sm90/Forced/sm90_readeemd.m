fileName = sprintf('SM90_Run%d_EEMD.txt',runID);
%fileName = sprintf('SM90_Run%d_EEMD_Params.txt',runID);
%fileName = sprintf('SM90Full_Run%d_EEMD.txt',runID);
%filePath = '~/campgrp/rjballes/EEMDRuns/sm90/';
filePath = '~/campgrp/rjballes/EEMDRuns/sm90/ForcingSearch/';
nmodes= readData(fileName,filePath,13);
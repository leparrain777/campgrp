fileName = sprintf('SM91_Run%d_EEMD.txt',runID);
%fileName = sprintf('SM90Full_Run%d_EEMD.txt',runID);
%filePath = '~/campgrp/rjballes/EEMDRuns/sm91/';
filePath = '~/campgrp/rjballes/EEMDRuns/sm91/ForcingSearch/';
nmodes= readData(fileName,filePath,13);
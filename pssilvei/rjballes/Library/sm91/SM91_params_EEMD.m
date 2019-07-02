% parameters script for running eemd on SM91

% Run number
run_num = 76;

%%EEMD Control
    whiteNoise=0.4;
    iterations=(whiteNoise*100)^2;

%EEMDFigFlag = 1 to output EEMD figure, otherwise 0
    EEMDFigFlag = 1;

%Model Insolation and Run Flags
    %Note, only one flag should be on at a time;
    insolNoneFlag = 0;
    insol1MoFlag = 0;
    insol3MoFlag = 0;
    insol5MoFlag = 0;
    insol7MoFlag = 0;
    insolHuybersIntegratedFlag = 0;
    insolLaskarFlag = 1;
    
    read_run_num = run_num;

%ReadMe Flag
    ReadMeFlag = 1;

% ===================== %

%filePath = '~/campgrp/rjballes/EEMDRuns/sm91/';
filePath = '~/campgrp/rjballes/EEMDRuns/sm91/ForcingSearch/';

if insolNoneFlag == 1
    descr = 'insolNone';
elseif insol1MoFlag == 1
    descr = 'insol1Mo';
elseif insol3MoFlag == 1
    descr = 'insol3Mo';
elseif insol5MoFlag == 1
    descr = 'insol5Mo';
elseif insol7MoFlag == 1
    descr = 'insol7Mo';
elseif insolHuybersIntegratedFlag == 1
    descr = 'insolHuybersIntegrated';
elseif insolLaskarFlag == 1
    descr = 'insolLaskar';
end

fileReadName = sprintf('SM91_%s_%d_Model.txt',descr,read_run_num);
fileReadPath = '~/campgrp/rjballes/ModelRuns/sm91/';
%fileReadName = sprintf('SM91_%s_%d_forcing_Model.txt',descr,read_run_num);
%fileReadPath = '~/campgrp/rjballes/ModelRuns/sm91/ForcingSearch/';

if ReadMeFlag ==1
fileName = sprintf('SM91_Run%d_EEMD_Params.txt',run_num);
fname=strcat(filePath,fileName);
fid = fopen(fname,'w');
fprintf(fid,'SM91_Run%d_EEMD_Params\n',run_num);
fprintf(fid,'\nModel Run Insolation:\n');
fprintf(fid,'%s\n',descr);
fprintf(fid,'ModelRun: %d\n',read_run_num);
fprintf(fid,'u = %g, p = %g\n', param(3),param(1));
fprintf(fid,'\nWhite Noise: %g\n',whiteNoise);
fprintf(fid,'Iterations: %g\n',iterations);
fprintf(fid,'\n\nNotes:\n');
fclose(fid);
end
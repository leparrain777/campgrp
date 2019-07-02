% parameters script for running eemd on SM90

% Run number
run_num = 115;

%%EEMD Control
    whiteNoise=0.4
    iterations=(whiteNoise*100)^2;

%EEMDFigFlag = 1 to output EEMD figure, otherwise 0
    EEMDFigFlag = 0;

%Model Insolation and Run Flags
    %Note, only one flag should be on at a time;
    insolNoneFlag = 0;
    insol1MoFlag = 0;
    insol3MoFlag = 0;
    insol5MoFlag = 0;
    insol7MoFlag = 0;
    insolHuybersIntegratedFlag = 0;
    insolLaskarAstroFlag = 1;
    solsticeFlag = 0;
    
    read_run_num = run_num;

%ReadMe Flag
    ReadMeFlag = 1;

% ===================== %

%filePath = '~/campgrp/rjballes/EEMDRuns/sm90/';
filePath = '~/campgrp/rjballes/EEMDRuns/sm90/ForcingSearch/';

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
elseif insolLaskarAstroFlag
    descr = 'insolLaskar';
elseif solsticeFlag
    descr = 'solsticeLaskar';
end

fileReadName = sprintf('SM90_%s_%d_Model.txt',descr,read_run_num);
fileReadPath = '~/campgrp/rjballes/ModelRuns/sm90/';
%fileReadName = sprintf('SM90Full_%s_%d_Model.txt',descr,read_run_num);
%fileReadName = sprintf('SM90_%s_%d_forcing_Model.txt',descr,read_run_num);
%fileReadPath = '~/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/';

if ReadMeFlag ==1
fileName = sprintf('SM90_Run%d_EEMD_Params.txt',run_num);
%fileName = sprintf('SM90Full_Run%d_EEMD_Params.txt',run_num);
fname=strcat(filePath,fileName);
fid = fopen(fname,'w');
fprintf(fid,'SM90_Run%d_EEMD_Params\n',run_num);
fprintf(fid,'\nModel Run Insolation:\n');
fprintf(fid,'%s\n',descr);
fprintf(fid,'ModelRun: %d\n',read_run_num);
fprintf(fid,'u = %g, p = %g\n', param(5),param(1));
fprintf(fid,'\nWhite Noise: %g\n',whiteNoise);
fprintf(fid,'Iterations: %g\n',iterations);
fprintf(fid,'\n\nNotes:\n');
fclose(fid);
end
%PP04_Params_EEMD

%Run Number
    run_num=1;

%%EEMD Control
    whiteNoise=0.3;
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
    insolHuybersIntegratedFlag = 1;

    read_run_num = run_num;


%ReadMe Flag
    ReadMeFlag = 1;

% ===================== %

filePath = '~/campgrp/Lib/Matlab/Models/PP04/EEMD_Runs/';

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
end

fileReadName = sprintf('PP04_%s_%d_Model.txt',descr,read_run_num);
fileReadPath = '~/campgrp/Lib/Matlab/Models/PP04/Model_Runs/';

if ReadMeFlag ==1
fileName = sprintf('PP04_Run%d_EEMD_Params.txt',run_num);
fname=strcat(filePath,fileName);
fid = fopen(fname,'w');
fprintf(fid,'PP04_Run%d_EEMD_Params\n',run_num);
fprintf(fid,'\nModel Run Insolation:\n');
fprintf(fid,'%s\n',descr);
fprintf(fid,'ModelRun: %d\n',read_run_num);
fprintf(fid,'\nWhite Noise: %g\n',whiteNoise);
fprintf(fid,'Iterations: %g\n',iterations);
fprintf(fid,'\n\nNotes:\n');
fclose(fid);
end
%PP04_Params_EEMD

%Run Number
    run_num=2;

%%EEMD Control
    whiteNoise=0.3;  %0.3
    if whiteNoise == 0
      iterations=1;
    else
      iterations=(whiteNoise*100)^2; 
    end

%EEMDFigFlag = 1 to output EEMD figure, otherwise 0
    EEMDFigFlag = 1;

%Model Insolation and Run Flags
    %Note, only one flag should be on at a time;
    insolNoneFlag = 0;
    insol1MoFlag = 0;
    insol3MoFlag = 0;
    insol5MoFlag = 0;
    insol7MoFlag = 0;
    insolHuybersIntegratedFlag = 1;
    lr04DataFlag = 0;

    read_run_num = run_num;


%ReadMe Flag
    ReadMeFlag = 1;

% ===================== %

filePath = '/nfsbigdata1/campgrp/zgelber/Runs/EEMD/';

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
elseif lr04DataFlag == 1
    descr = 'lr04Data';
end

if lr04DataFlag ~= 1
  fileReadName = sprintf('PP04_%s_%d_Model.txt',descr,read_run_num);
  fileReadPath = '/nfsbigdata1/campgrp/zgelber/Runs/';
else
  readLR04interpolated;
end  

if ReadMeFlag == 1
fileName = sprintf('PP04_Run%d_EEMD_Params.txt',run_num);
fname=strcat(filePath,fileName);
fid = fopen(fname,'w');
fprintf(fid,'PP04_Run%d_EEMD_Params\n',run_num);
fprintf(fid,'\nModel Run Insolation:\n');
fprintf(fid,'%s\n',descr);
fprintf(fid,'ModelRun: %d\n',read_run_num);
fprintf(fid,'\nWhite Noise: %g\n',whiteNoise);
fprintf(fid,'Iterations: %g\n',iterations);
%fprintf(fid,'\n\nNotes:\n');
%fclose(fid);
end

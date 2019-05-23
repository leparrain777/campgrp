%PP04_Params_Model_Run

%This is the main parameter file
%Change params here, this creates PP04_Param_Insol_Run.txt file

%Run Number
run_num = 1;

ratio=5/5;
%%Model Run Control
%Time constants
tV=15;       %15
tC=5;       %5
tA=12;         %12
%Constants
x=1.3;          %1.3
y=0.15*ratio;         %0.5        %.15
z=0.8;          %0.8
al=0.05*ratio;        %0.15       %0.05
be=0.5;         %0.5
ga=0.5;         %0.5
de=0.4;         %0.4        %0.454
a=0.3;          %0.3
b=0.7;          %0.7
c=0.01;         %0.01
d=0.27;         %0.27
k=0*10^-5; %0*10^-5; %8.5*10^-5;
g=0*2*10^-5; %10*10^-5;            %-2.0*10^-5;     %0        
Constants=[tV,tC,tA,x,y,z,al,be,ga,de,a,b,c,d,k,g];

%Insolation Flags
%Note, only one flag should be on at a time;
insolNoneFlag = 0;
insol1MoFlag = 0;
insol3MoFlag = 0;
insol5MoFlag = 0;
insol7MoFlag = 0;
insolHuybersIntegratedFlag = 1;

if insol1MoFlag == 1
    Constants(5)=0.5;
    Constants(7)=0.15;
end

%ReadMe Flag
ReadMeFlag = 1;

%Model Figure Flag
ModelFigFlag = 1;

% ================================ %

filePath = '~/campgrp/brknight/PP04_Data/Model_Runs/';

if insolNoneFlag == 1
    descr = 'insolNone';
    insol = 0;
elseif insol1MoFlag == 1
    descr = 'insol1Mo';
    insol = 1;
elseif insol3MoFlag == 1
    descr = 'insol3Mo';
    insol = 2;
elseif insol5MoFlag == 1
    descr = 'insol5Mo';
    insol = 3;
elseif insol7MoFlag == 1
    descr = 'insol7Mo';
    insol = 4;
elseif insolHuybersIntegratedFlag == 1
    descr = 'insolHuybersIntegrated';
    insol = 5;
end


if ReadMeFlag ==1
    fileName = sprintf('PP04_%s_%d_Params.txt',descr,run_num);
    fname=strcat(filePath,fileName);
    fid = fopen(fname,'w');
    fprintf(fid,'PP04_%s_%d_Params\n',descr,run_num);
    fprintf(fid,'\nModel Run Insolation:\n');
    fprintf(fid,'%s\n',descr);
    fprintf(fid,'\nConstants:\n');
    fprintf(fid,'tV = %g\n',tV);
    fprintf(fid,'tA = %g\n',tA);
    fprintf(fid,'tC = %g\n',tC);
    fprintf(fid,'x  = %g\n',x);
    fprintf(fid,'y  = %g\n',y);
    fprintf(fid,'z  = %g\n',z);
    fprintf(fid,'al = %g\n',al);
    fprintf(fid,'be = %g\n',be);
    fprintf(fid,'ga = %g\n',ga);
    fprintf(fid,'de = %g\n',de);
    fprintf(fid,'a  = %g\n',a);
    fprintf(fid,'b  = %g\n',b);
    fprintf(fid,'c  = %g\n',c);
    fprintf(fid,'d  = %g\n',d);
    fprintf(fid,'k  = %g\n',k);
    fprintf(fid,'g  = %g\n',g);
    fprintf(fid,'\n\nNotes:\n');
    fclose(fid);
end

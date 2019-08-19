function [varA, varB] = compare_EEMD(runA, IMFA, runB, IMFB, tstart, tfinal)
%Input four integers: the first two are the run and what IMF you want to compare, while the second two are the other run and other IMF you want to compare. Then input two more integers for the desired time period to compare.

%Read in the EEMD Data%
%-----------------------------%
time = ['From ', num2str(tstart), ' to ', num2str(tfinal), ' thousand years ago'];

fpath = '/nfsbigdata1/campgrp/zgelber/Runs/EEMD/'; %Change to wherever your EEMD runs are stored.

fileName1 = sprintf('PP04_Run%d_EEMD.txt', runA);
fileName2 = sprintf('PP04_Run%d_EEMD.txt', runB);
fmt = '%g';

fileName1P = sprintf('PP04_Run%d_EEMD_Params.txt', runA);
fileName2P = sprintf('PP04_Run%d_EEMD_Params.txt', runB);
IMF_Line_Number = 10; %This is the line of the parameter file that should have the number of IMFs. 


fname1 = strcat(fpath, fileName1);
fname1P = strcat(fpath, fileName1P);

fname2 = strcat(fpath, fileName2);
fname2P = strcat(fpath, fileName2P);

[fid1P, errormsg1] = fopen(fname1P, 'r');
if fid1P == -1
	disp(errormsg1);
end

IMF1 = textscan(fid1P, '%f', 1, 'Delimiter', '\n', 'headerlines', IMF_Line_Number-1);
IMF1 = IMF1{1,1};
points1 = textscan(fid1P, '%f', 1, 'Delimiter', '\n', 'headerlines', 2-1);
points1 = points1{1,1}; 
fclose(fid1P);

[fid2P, errormsg2] = fopen(fname2P, 'r');
if fid2P == -1
	disp(errormsg2);
end

IMF2 = textscan(fid1P, '%f', 1, 'Delimiter', '\n', 'headerlines', IMF_Line_Number-1); 
IMF2 = IMF2{1,1};
points2 = textscan(fid1P, '%f', 1, 'Delimiter', '\n', 'headerlines', 2-1);
points2 = points2{1,1}; 
fclose(fid2P);


[fid1, errormsg3] = fopen(fname1, 'r');
if fid1 == -1
	disp(errormsg3);
end

temp1 = fscanf(fid1, fmt, [IMF1, points1]);
fclose(fid1);

[fid2, errormsg4] = fopen(fname2, 'r');
if fid2 == -1
	disp(errormsg4);
end

temp2 = fscanf(fid2, fmt, [IMF2, points2]);
fclose(fid2);
%----------------------------------------------%

%Analyze the data%

varA = var(temp1(IMFA+1, tstart+1:tfinal+1));

varB = var(temp2(IMFB+1, tstart+1:tfinal+1));

%Display the results%

disp(time)
dispA = ['Variance of run ', num2str(runA), ' is ', num2str(varA), ' for IMF ', num2str(IMFA)];
dispB = ['Variance of run ', num2str(runB), ' is ', num2str(varB), ' for IMF ', num2str(IMFB)];
disp(dispA)
disp(dispB)


end

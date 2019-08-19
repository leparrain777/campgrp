%this reads the LR04 untuned/non-interpolated data for EEMD, obliquity pacing, asymmetry analysis, and partial melt analysis
function [hTime, hData] = read_LR04_untuned
fname = '/nfsbigdata1/campgrp/Data/Paleo/LR04_untuned_Lisiecki2010.txt';
%fname = strcat(fpath,'LR04_untuned_Lisiecki2010.txt');

fmt = '%g %g\n';
fid = fopen(fname,'r');

for i=1:3
    fgets(fid);
end

lrdata = fscanf(fid,fmt,[2,Inf]);             %Scan the data into a 2xInf array
fclose(fid);
lrdata = lrdata';
hTime = lrdata(:,1);
hData = lrdata(:,2);
end


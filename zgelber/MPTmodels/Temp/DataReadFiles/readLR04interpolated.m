%this reads the LR04 untuned AND interpolated data for EEMD, 
%   obliquity pacing, asymmetry analysis, and partial melt analysis

fname = '/nfsbigdata1/campgrp/Data/Paleo/lr04_interp_data.txt';
%fname = strcat(fpath,'LR04_untuned_Lisiecki2010.txt');

fmt = '%g %g\n';
fid = fopen(fname,'r');

for i=1:6
    fgets(fid);
end

lrdata = fscanf(fid,fmt,[2,Inf]);             %Scan the data into a 2xInf array
fclose(fid);


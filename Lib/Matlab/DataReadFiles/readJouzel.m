%this reads the LR04 untuned/non-interpolated data for EEMD, obliquity pacing, asymmetry analysis, and partial melt analysis

fname = '/nfsbigdata1/campgrp/Data/Paleo/jouzel_interp.txt';

fmt = '%g %g\n';
fid = fopen(fname,'r');


jouzeldata = fscanf(fid,fmt,[2,Inf]);             %Scan the data into a 2xInf array
fclose(fid);


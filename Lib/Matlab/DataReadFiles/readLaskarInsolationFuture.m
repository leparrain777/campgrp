function [time, insol] = readLaskarInsolation(tstart, tend)
% function [time, insol] = readLaskarInsolation(month, tstart, tend)
% Inputs:
%	tstart: the earliest time wanted for the insolation data. (Ex. 0 = present)
%	tend: the latest time wanted for the insolation data. (Ex. 0 = present day, 1000 = 1 My)
%	
%	Ensure: 0 <= tstart < tend <= 20
%
% Outputs:
%	time: time listed from tstart to tend in thousands of years 
%	insol: the insolation corresponding to the time.  This is non-normalized.
%
% Date: 28 July 2014
% Author: Andrew Gallatin

fileName = 'insol_Jul_65N_La2004_future.txt';

fpath = '/nfsbigdata1/campgrp/Data/Milankovich/Laskar/';
fname = strcat(fpath,fileName);

fmt = '%g %g';

fid = fopen(fname,'r');

% Move the cursor through the comment block
for j=1:7,
   comment = fgets(fid);
end

% Read the file into a 2xInf array
temp = fscanf(fid,fmt,[2,Inf]);

fclose(fid);

% Time is returned in thousands of years.  Data reads from tstart (present) to tend (Ky). 
time=squeeze(temp(1,:))';
insol = squeeze(temp(2,:))';


% Filter out the time according to user input.
time = time(tstart+1:1:tend+1);
insol = insol(tstart+1:1:tend+1);

end

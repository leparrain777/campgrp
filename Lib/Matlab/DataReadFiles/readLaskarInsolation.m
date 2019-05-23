function [time, insol] = readLaskarInsolation(month, tstart, tend)
% function [time, insol] = readLaskarInsolation(month, tstart, tend)
% Inputs:
%	month: taken as a number to indicate which month to gather the data from. 
%		(Eg. June = 6, July = 7)
%	tstart: the earliest time wanted for the insolation data. 
%		(Ex. 20000 = 20 Ma, 10500 = 10.5 Ma)
%	tend: the latest time wanted for the insolation data. 
%		(Ex. 0 = present day, 1000 = 1 Ma)
%	
%	Ensure: 0 <= tend < tstart <= 20000
%
% Outputs:
%	time: time listed from tend to tstart in thousands of years ago
%	insol: the insolation corresponding to the time.  This is non-normalized.
%
% Date: 7 July 2014
% Author: Andrew Gallatin

if month == 6
   fileName = 'insol_Jun_65N_La2004.txt';
elseif month == 7
   fileName = 'insol_Jul_65N_La2004.txt';
elseif month == 8
   fileName = 'insol_Aug_65N_La2004.txt';
end

fpath = '/nfsbigdata1/campgrp/Data/Milankovich/Laskar/';
fname = strcat(fpath,fileName);

fmt = '%g %g';

fid = fopen(fname,'r');

% Move the cursor through the comment block
for j=1:7,
   comment = fgets(fid);
end

% Read the file into a 5xInf array
temp = fscanf(fid,fmt,[2,Inf]);

fclose(fid);

% Time is returned in thousands of years ago.  
% Data reads from tend (present) to tstart (Ka). 
time=squeeze(temp(1,:))'*-1;
time = time(end:-1:1);

insol = squeeze(temp(2,:))';
insol = insol(end:-1:1);

% Filter out the time according to user input.
time = time(tend+1:1:tstart+1);
insol = insol(tend+1:1:tstart+1);

end

function [time, ecc, prec, obl] = readLaskarOrbital(tstart, tend)
% function [time, ecc, prec, obl] = readLaskarOrbital(tstart, tend)
% Inputs:
%       tstart: the earliest time wanted for the insolation data. 
%		(Ex. 20000 = 20 Ma, 10500 = 10.5 Ma)
%       tend: the latest time wanted for the insolation data. 
%		(Ex. 0 = present day, 1000 = 1 Ma)
%
%       Ensure: 0 <= tend < tstart <= 20000
%
% Outputs:
%       time: time listed from tend to tstart in thousands of years ago
%       ecc: eccentricity
%	prec: precession
%	obl: obliquity

% Date: 7 July 2014
% Author: Andrew Gallatin

fpath = '/nfsbigdata1/campgrp/Data/Milankovich/Laskar/';
fname = strcat(fpath,'orbital_La2004.txt');

fmt = '%g %g %g %g';
    
fid = fopen(fname,'r');

% Move the cursor through the comment block
for j=1:7,
   comment = fgets(fid);
end 

% Read the file into a 5xInf array
temp = fscanf(fid,fmt,[4,Inf]);

fclose(fid);

% Time is returned in thousands of years ago.  
%Data reads from tend (present) to tstart (Ka). 
time = squeeze(temp(1,:))'*-1;
time = time(end:-1:1);

ecc = squeeze(temp(2,:))';
ecc = ecc(end:-1:1);

prec = squeeze(temp(3,:))';
prec = prec(end:-1:1);

obl = squeeze(temp(4,:))';
obl = obl(end:-1:1);

% Filter out the time according to user input.
time = time(tend+1:1:tstart+1);
ecc = ecc(tend+1:1:tstart+1);
prec = prec(tend+1:1:tstart+1);
obl = obl(tend+1:1:tstart+1);

end

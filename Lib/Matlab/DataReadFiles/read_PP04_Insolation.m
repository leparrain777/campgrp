function [time, insol] = read_PP04_Insolation(str,tstart,tend)
%Similar format to Andrew Gallatin readLaskarInsolation

fpath = '~/campgrp/brknight/Data/';
fname = strcat(fpath,str);
fmt = '%g %g';
[fid,errormsg] = fopen(fname,'r');
if fid == -1
  disp(errormsg);
end

% Read the file into a 2xInf array
temp = fscanf(fid,fmt,[2,Inf]);
fclose(fid);

% Time is returned in thousands of years ago.  
% Data reads from tend (present) to tstart (Ka).

time=squeeze(temp(1,:))'*-1;
time = time(end:-1:1);

insol = squeeze(temp(2,:))';
insol = insol(end:-1:1);

A=find(tstart==time);
B=find(tend==time);

% Filter out the time according to user input.
time = time(A:1:B);
insol = insol(A:1:B);

end

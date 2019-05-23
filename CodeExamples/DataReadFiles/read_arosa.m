function [time, ozone] = read_arosa
% Syntax:
%	 [time, ozone] = read_arosa
%
% Reads column ozone abundances from Arosa, Switzerland.
%	Uses Aug,1931 - Dec., 2002 data
%	Cubic spline fit for missing data
%
% Returns	time		1D array
%		ozone(t)	1D array
%
fpath = '/Volumes/BootHD/Data/Arosa/';
fname = strcat(fpath,'arosa_o3.dat');
;
fmt = '%g %g';
fid = fopen(fname,'r');
for i=1:2 aline = fgets(fid); end;
temp = fscanf(fid,fmt,[2,inf]);
fclose(fid);
;
time  = squeeze(temp(1,:))';
ozone = squeeze(temp(2,:))';

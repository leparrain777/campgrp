function [time, ecc, obl, prec, NorthF] = readBergerAstronomical(tstart, tend)
% readIntegratedInsolation.m reads the integratedInsolation.txt 
% data set created via Huybers insolatedIntegration.m script
% This data set goes back 5 million years (5000 kyr) up until the present
% To call a read for time t1 to t2:
%        [time, ecc, obl, prec, NorthF] = readBergerAstronomical(t1,t2)
% To call a read for the whole data file:
%        [time, ecc, obl, prec, NorthF] = readBergerAstronomical(0,5000)
%
% Author: Brian Knight
% Created: 08/09/18
% Last Edit: 08/09/18

fname = 'BergerAstronomical5000.txt';
fpath = '~/campgrp/Data/Paleo/';
file = strcat(fpath,fname);

x = '%g'; %'%12.16';
y = '';
for i=1:5
    y = sprintf('%s %s',y,x);
end
fid = fopen(file,'r');
for i = 1:16
    fgets(fid);
end% for

Data = fscanf(fid,y,[5,inf]);            %Scan the data into a colxInf array

fclose(fid);

%Data(Data == -99999) = NaN;
Data = Data';

%data = readData(fname, fpath, 5);

time = Data(tstart+1:tend+1,1);
ecc = Data(tstart+1:tend+1,2);
obl = Data(tstart+1:tend+1,3);
prec = Data(tstart+1:tend+1,4);
NorthF = Data(tstart+1:tend+1,5);

end
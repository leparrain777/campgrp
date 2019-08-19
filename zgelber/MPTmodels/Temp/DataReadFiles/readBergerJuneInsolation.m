function [time,N90,N60,N30,N0,S30,S60,S90] = readBergerJuneInsolation

fpath = '/nfsbigdata1/campgrp/Data/Paleo/';
fname = strcat(fpath,'insol91.jun');

fmt = '%g';
fid = fopen(fname,'r');

for i=1:3
    fgets(fid);
end

temp = fscanf(fid,fmt,[8,inf]);              %Scan the data into a 4xInf array
fclose(fid);

temp(temp == -99999) = NaN;

time = temp(1,:)';
N90 = temp(2,:)';
N60 = temp(3,:)';
N30 = temp(4,:)';
N0 = temp(5,:)';
S30 = temp(6,:)';
S60 = temp(7,:)';
S90 = temp(8,:)';
end

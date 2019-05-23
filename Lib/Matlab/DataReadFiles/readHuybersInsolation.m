function [time, ecc, prec, obl] = readHuybersInsolation
% function [time, ecc, prec, obl] = readHuybersInsolation

fpath = '/nfsbigdata1/campgrp/Data/Milankovich/';
fname = strcat(fpath,'insolaout_huybers.txt');
;
fmt = '%g %g %g %g';
fid = fopen(fname,'r');

temp = fscanf(fid,fmt,[4,Inf]);              %Scan the data into a 4xInf array
fclose(fid);

temp(temp == -99999) = NaN;

time=squeeze(temp(1,:))'*-1000;
time=time(end:-1:1);

ecc=squeeze(temp(2,:))';
ecc=ecc(end:-1:1);

prec=squeeze(temp(3,:))';
prec=prec(end:-1:1);

obl=squeeze(temp(4,:))';
obl=obl(end:-1:1);

end

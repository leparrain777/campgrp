function [time, obl] = readHuybersObliquity
% function [time, ecc, prec, obl] = readHuybersObliquity

fpath = '/nfsbigdata1/campgrp/rsmith49/Data/';
fname = strcat(fpath,'insolaoutaFqENW');

fmt = '%g %g';
fid = fopen(fname,'r');

temp = fscanf(fid,fmt,[2,inf]);              %Scan the data into a 4xInf array
fclose(fid);

temp(temp == -99999) = NaN;

time=squeeze(temp(1,:))'*-1000;
%time=time(end:-1:1);

obl=squeeze(temp(2,:))';
%obl=obl(end:-1:1);

end

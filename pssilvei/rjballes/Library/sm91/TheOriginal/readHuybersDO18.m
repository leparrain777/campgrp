function [age,sigma,avg,benthic,planktic] = readHuybersDO18

fpath = '/nfsbigdata1/campgrp/Data/Paleo/';
fname = strcat(fpath,'huybers2006.txt');

fmt = '%g %g %g %g %g';
fid = fopen(fname,'r');

for i=1:144
    fgets(fid);
end

temp = fscanf(fid,fmt,[5,2001]);              %Scan the data into a 4xInf array
fclose(fid);

temp(temp == -99999) = NaN;

age=squeeze(temp(1,:))';
age=age(end:-1:1);

sigma=squeeze(temp(2,:))';
sigma=sigma(end:-1:1);

avg=squeeze(temp(3,:))';
avg=avg(end:-1:1);

benthic=squeeze(temp(4,:))';
benthic=benthic(end:-1:1);

planktic=squeeze(temp(5,:))';
planktic=planktic(end:-1:1);

end

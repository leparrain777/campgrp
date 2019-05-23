function insol_cf = get_integrated_insol(lat, threshold, tshift);
%  function [age, insol_n, insol_cf] = get_integrated_insol(threshold);
% 
% Returns the piecewise-polynomial coefficients of the cubic-spline
%   (not-a-knot) interpolant for normalized integrated summer insolation at
%   latitude 65 north with forward time (kyr, not ka)
%   For use in model integrations, hence forward time array.
%
% Input
%   threshold: insolation threshold, element of {0:25:600} W/m^2
%   default value for 65 North from Huybers, 2006:  threshold=275 W/m^2
%   tshift: initial time for synthetic time array (kyr)
%       allows for negative time for transients
%       or shift to later insolation values
%
% Use yy = ppval(insol_cf, tt) to return values insolation values at times
%   given by tt (kyr)
%   IMPORTANT:  times for the interpolant are in kyr (not kyr ago)
%
[age, insol] = readHuybersIntegrated(lat, threshold);
insol_n = normalize_array(insol);
%   synthetic time array (kyr) for interpolant
%       min(time) = tshift corresponds to insolation from 5 Mya
%       max(time) = 5000-tshift corresponds to insolation from present
time =  age(end) - age + tshift;       
%
insol_cf = spline(time, insol_n');
%
end  % function

%%
function [xx] = normalize_array(x)
% function [xx] = normalize_array(x)
%   Given matrix x; returns normalized columens of x

xs = size(x);
if ((xs(2) == 1) | (xs(1) == 1))
    xx = (x-mean(x))/std(x);
else
    nrow = xs(1);
    mu = repmat(mean(x),[nrow,1]);
    sigma = repmat(std(x),[nrow,1]);
    xx = (x-mu)./sigma;
end % if
end % function

%%
function [age, insol] = readHuybersIntegrated(lat, threshold)
% function [age, insol] = readHuybersInsolation(lat, threshold)
%    returns integrated 'summer' insolation at given latitude
%    integrates insolation for days in which insolation > threshold
%    ORIGINAL REFERENCE: 
%       Huybers, P. 2006. 
%       Early Pleistocene Glacial Cycles and the Integrated Summer Insolation Forcing. 
%       Science, v313, p508-511, 10.1126/science.1125249, 28 July 2006.
%   INPUT:
%    lat: latitude [-90:5:90] deg
%    threshold: min insolation [0:25:600] W/m^2
%   OUTPUT:
%    age (kyr)
%    insol (W/m^2):  one column per threshold
%
% last change (CDC) 13/6/2017: set path for local data files
%
fpath = './Insolation/Integrated/';
if (lat < 0)
    fname = sprintf('%sJ_%iSouth.txt',fpath,abs(lat));
else
    fname = sprintf('%sJ_%iNorth.txt',fpath,lat);
end % if
%
nh = 25;        % number of thresholds (0:25:600 W/m^2)
%
fid = fopen(fname,'r');
for i=1:8
    comment = fgets(fid);
end % for
%
fmt = '%g';
temp = fscanf(fid,fmt,[nh+1,Inf]);     %Scan the data into a 4xInf array
fclose(fid);
%
% Index arrays
% thresh = temp(2:end,1);
age = temp(1, 2:end)';
%
j = threshold/25;
insol = temp(j, 2:end)';
%
end % function




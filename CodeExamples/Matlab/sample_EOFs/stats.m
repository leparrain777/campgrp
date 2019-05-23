function [krt, skw, sdev] = stats(D, nt,nlat,nlon)
stats_data = reshape(D,nt,nlat,nlon);
% calculate the statistics
    % kurtosis
krt = kurtosis(stats_data,[],1)-3;
krt = squeeze(krt);
    % skewness
skw = skewness(stats_data,[],1);
skw = squeeze(skw);
    % standard deviation
sdev = sqrt(var(stats_data,[],1));
sdev = squeeze(sdev);
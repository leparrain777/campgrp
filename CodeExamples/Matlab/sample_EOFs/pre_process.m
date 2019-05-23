function [D, lat, trend, seasonal_cycle,nt,nlat,nlon] = pre_process(data, lat, latflag, deseasonalizeflag, detrendflag, order, lat_h, lat_l, time, freq, filterflag)
if (latflag)
    [data, lat] = remove_lat(data, lat, lat_h, lat_l);
end
s = size(data);
nt = s(1);
nlat = s(2);
nlon = s(3);
[D] = fold_matrix(nt, nlat, nlon, data);
if (deseasonalizeflag)
    D_dsn = zeros(nt, nlat*nlon);
    seasonal_cycle = zeros(12, nlat*nlon);
    for a = 1:(nlat*nlon);
        x = D(:,a);
        [x_dsn, cycle] = deseasonalize(x, 12);
        D_dsn(:,a) = x_dsn;
        seasonal_cycle(:,a) = cycle;
    end
    D = D_dsn;
end
if(detrendflag)
    D_dtr = zeros(nt, nlat*nlon);
    trend = zeros(2, nlat*nlon);
    for b = 1:(nlat*nlon);
        x_tr = D(:,b);
        [x_dtr, p] = detrend_miss(x_tr, time, order);
        D_dtr(:,b) = x_dtr;
        trend(:,b) = p;
    end
    D = D_dtr;
end
if (filterflag)
    % filter out the higher frequencies
    D_lowpass = lowpass(D, freq);
    D = D_lowpass;
end
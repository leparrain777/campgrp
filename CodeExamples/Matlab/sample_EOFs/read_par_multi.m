function[lat,lon,lev] = read_par_multi(fname)
nc = netcdf(fname);
lat = nc{'lat'}(:);
lon = nc{'lon'}(:);
lev = nc{'lev'}(:);
close(nc)
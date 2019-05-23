clear all; close all;
display('read parameters')
parameters;
display('read data')
[data, time, lat, lon, lev] = read_data(ti, tf, l1, l2, nameflag, dataflag, fpath, nlevels);
display('pre-process')
[D, lat, trend, seasonal_cycle,nt,nlat,nlon] = pre_process(data, lat, latflag, deseasonalizeflag, detrendflag, order, lat_h, lat_l, time, freq, filterflag);
[krt, skw, sdev] = stats(D, nt,nlat,nlon);
display('SVD')
[D, Dbar, U,S,V, PC, EOF_scaled, rel_var, scaling] = process(D,nt,nlat,nlon,lat, scaleflag);
display('post-process')
[EOF_spatial, seasonal_unf, Dbar_unf] = post_process(nlat, nlon, nEOF, seasonal_cycle, EOF_scaled, scaling, scaleflag, Dbar);
%labels
first_level = findbin(l1,lev,0);
second_level = findbin(l2,lev,0);
if (writeflag)
   write_EOF(EOF_spatial,PC, nEOFwrt, time, lat, lon)
end
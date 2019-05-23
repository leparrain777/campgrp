function [time, level, lat, lon, airnc, nc, offset, scale] = read_ncep_air
%
% Reads data for NCEP Reanalysis Geopotential Heights, Monthly
%
% Returns	time, level, lat, lon		1D arrays
%		airnc(t, level, lat, lon)	4D ncvar object
%		nc				File ID
%	
%	use air = airnc(:,i,:,:) to extract ith level
%	use close(nc) in calling routine to close netCDF file
%		AFTER extracting data from airnc
%
fpath = '/home/cdcamp/Data/NCEP/';
fname = strcat(fpath,'air.mon.mean.nc');
%
nc = netcdf(fname, 'nowrite');
%
t0 = 1948.;
%
lat   = nc{'lat'}(:);
lon   = nc{'lon'}(:);
level = nc{'level'}(:);
time0 = nc{'time'}(:);
%
nt = length(time0);
time = ([0:nt-1]')/12. + t0;
%
airnc = nc{'air'};
%
%       Scale/Offset parameters form netCDF file
offset = 127.65;
scale  = 0.01;


function [time, lat, lon, air, p1] = get_ncep_air(p0, latrng, trng)
%
%	Returns one slice of NCEP Temperatures
%
%	Input: p0	desired pressure level
%	       latrng	desired latitude range [min,max] or single value
%	Output:	time	time array
%		lat	latitude array
%		lon	longitude array
%		p1	pressure level used
%		gph(lat, lon, time)	desired geopotential height data
%		gph(lon, time)	desired geopotential height data
%
[time, level, lat, lon, airnc, nc, offset, scale] = read_ncep_air;
%
ip  =  findbin(p0,level,1);
p1 = level(ip);
%
if length(latrng) > 1
  ilat = find(lat >= latrng(1) & lat <= latrng(2));
else
  ilat = findbin(latrng,lat,0);
end
lat = lat(ilat);
%
it = find(time >= trng(1) & time <= trng(2));
time = time(it);
%
air = squeeze(permute(airnc(it,ip,ilat,:),[4 3 2 1]))*scale + offset;
%
close(nc);		% Close netCDF file

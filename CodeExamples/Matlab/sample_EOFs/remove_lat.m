function [data, lat] = remove_lat(data, lat, lat_h, lat_l)
low_lat_b = findbin(lat_l,lat,1);
high_lat_b = findbin(lat_h,lat,0);
if low_lat_b < high_lat_b
    data = data(:,low_lat_b:high_lat_b,:);
    lat = lat(low_lat_b:high_lat_b);
else
    data = data(:,high_lat_b:low_lat_b,:);
    lat = lat(high_lat_b:low_lat_b);
end
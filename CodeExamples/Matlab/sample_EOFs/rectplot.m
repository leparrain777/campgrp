
function [C,H] = rectplot(Wn, lat, lon, nlat, nlon, fsize)

%LATIDUDE AND LONGITUDE
latm	= repmat(lat,1,nlon);
lonm	= repmat(lon,1,nlat)';

%COAST LINES
coast = load('coast');
lonp = [lon; lon(1:2)+360.];

%MAP COLOR
nc = 16;
colormap('Default');
temp = colormap;
colorindex = round(([1:nc]-.5)*size(temp,1)/nc);
newcolormap = temp(colorindex,:);


%PLOT OF EIGENVECTOR CHOSEN ON GLOBE
colormap(newcolormap);
latlim=[min(lat) max(lat)];
axesm('MapProjection','mercator','MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
 framem('on'); gridm('on')
 tightmap;
 plotm(coast.lat,coast.long);
 [C,H] = contourfm(lat,lon,Wn);
 colorbar('SouthOutside');
 set(gca,'LineWidth',2.0);
 xlabel('Geopotential Height Anomaly (m)');
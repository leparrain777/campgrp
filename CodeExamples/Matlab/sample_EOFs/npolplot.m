
function [C,H] = npolplot(Wn, lat, lon, nlat, nlon, fsize)

%LATIDUDE AND LONGITUDE
latm	= repmat(lat,1,nlon);
lonm	= repmat(lon,1,nlat)';

%COAST LINES
coast = load('coast');
lonp = [lon; lon(1)+360.];

%MAP COLOR
nc = 16;
colormap('Default');
temp = colormap;
colorindex = round(([1:nc]-.5)*size(temp,1)/nc);
newcolormap = temp(colorindex,:);


%FORMATTING OF EIGENVECTOR DATA FOR MAP
Wnp = [Wn, Wn(:,1)];

%PLOT OF EIGENVECTOR CHOSEN ON POLE
colormap(newcolormap);
axesm('MapProjection','ortho','Origin',[90,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
 framem('on'); gridm('on')
 plotm(coast.lat,coast.long);
 [C,H] = contourfm(lat,lonp,Wnp);
 colorbar('SouthOutside');
 set(gca,'LineWidth',2.0);
 xlabel('Geopotential Height Anomaly (m)');
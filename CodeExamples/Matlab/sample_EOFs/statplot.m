
function [C,H] = statplot(sdev, skw, kurt, lat, lon, nlat, nlon, fsize, fignum, plotstr, plotn, printflg, fpath, pname0, Dbar_unf)

%This routine takes care of statistical plots- Center data, Standard
%deviations, Skewness, and Kurtosis. Once again, you have four options for
%the types of plots you would like.

 switch (plotn) 
     case 1;
 		plotyp = 'robinson';
        pname = [pname0, '_statg'];
     case 2;
 		plotyp = 'mercator';
        pname = [pname0, '_statr'];
     case 3;
         plotyp = 'ortho';
         pname = [pname0, '_statn'];
     case 4;
         plotyp = 'ortho';
         pname = [pname0, '_stats'];
end

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
 
 %PLOT OF CENTER DATA
fignum=fignum+2;
figure(fignum);
pname = [pname0, '_mean'];
colormap(newcolormap);
mennp = [Dbar_unf, Dbar_unf(:,1)];
latlim=[min(lat) max(lat)];
   switch(plotn);
     case 1
         axesm('MapProjection',plotyp,'MapLonLimit',[0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 2
         axesm('MapProjection',plotyp,'MapLonLimit',[0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 3
     axesm('MapProjection',plotyp,'Origin',[90,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
     case 4;
     axesm('MapProjection',plotyp,'Origin',[270,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
  end
framem('on'); gridm('on')
tightmap
plotm(coast.lat,coast.long);
[C,H] = contourfm(lat,lonp,mennp);   
colorbar('SouthOutside');
set(gca,'LineWidth',2.0, 'FontSize',fsize);
xlabel('Geopotential Height Anomally (m)');
menstr=cat(2,'MEAN:',plotstr);
  titl=title(menstr);
  set(titl,'FontWeight','bold','FontSize',fsize);
P=get(titl,'position');
P(2)=P(2)+0.05; %pull title up by 5% of the axes height
set(titl,'position',P) %apply
if (printflg)
    fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
end;  


  %PLOT OF STD
fignum=fignum+1;
figure(fignum);
pname = [pname0, '_STDev'];
colormap(newcolormap);
latlim=[min(lat) max(lat)];
sdevnp = [sdev,sdev(:,1)];
   switch(plotn);
     case 1
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 2
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 3
     axesm('MapProjection',plotyp,'Origin',[90,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
     case 4;
     axesm('MapProjection',plotyp,'Origin',[270,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
  end
framem('on'); gridm('on')
  tightmap
  plotm(coast.lat,coast.long);
[C,H] = contourfm(lat,lonp,sdevnp);   
  colorbar('SouthOutside');
set(gca,'LineWidth',2.0,'FontSize',fsize);
  xlabel('Geopotential Height Anomally (m)');
  stdstr=cat(2,'STANDARD DEVIATIONS:',plotstr);
  titl=title(stdstr);
  set(titl,'FontWeight','bold','FontSize',fsize);
P=get(titl,'position');
P(2)=P(2)+0.05; %pull title up by 5% of the axes height
set(titl,'position',P) %apply
if (printflg)
    fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
end;  
  

  %PLOT OF SKEWNESS
fignum=fignum+1;
figure(fignum);
pname = [pname0, '_skew'];
colormap(newcolormap);
latlim=[min(lat) max(lat)];
  skwnp = [skw,skw(:,1)];
   switch(plotn);
     case 1
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 2
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 3
     axesm('MapProjection',plotyp,'Origin',[90,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
     case 4;
     axesm('MapProjection',plotyp,'Origin',[270,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
  end
 framem('on'); gridm('on')
  tightmap
  plotm(coast.lat,coast.long);
  [C,H] = contourfm(lat,lonp,skwnp);
  colorbar('SouthOutside');
set(gca,'LineWidth',2.0,'FontSize',fsize);
  xlabel('Geopotential Height Anomally (m)');
  skwstr=cat(2,'SKEWNESS:',plotstr);
  titl=title(skwstr);
  set(titl,'FontWeight','bold','FontSize',fsize);
P=get(titl,'position');
P(2)=P(2)+0.05; %pull title up by 10% of the axes height
set(titl,'position',P) %apply
    if (printflg)
   fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
    end

  %PLOT OF KURTOSIS
fignum=fignum+1;
figure(fignum);
pname = [pname0, '_kurtosis'];
colormap(newcolormap);
latlim=[min(lat) max(lat)];
  krtnp = [kurt,kurt(:,1)];
 switch(plotn);
     case 1
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 2
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 3
     axesm('MapProjection',plotyp,'Origin',[90,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
     case 4;
     axesm('MapProjection',plotyp,'Origin',[270,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
  end
  framem('on'); gridm('on')
  tightmap
  plotm(coast.lat,coast.long);
  [C,H] = contourfm(lat,lonp,krtnp);
  colorbar('SouthOutside');
set(gca,'LineWidth',2.0,'FontSize',fsize);
  xlabel('Geopotential Height Anomally (m)');
  kurtstr=cat(2,'KURTOSIS:',plotstr);
  titl=title(kurtstr);
  set(titl,'FontWeight','bold','FontSize',fsize);
P=get(titl,'position');
P(2)=P(2)+0.05; %pull title up by 5% of the axes height
set(titl,'position',P) %apply
    if (printflg)
   fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname ,'.eps']); %Color EPS file
    end

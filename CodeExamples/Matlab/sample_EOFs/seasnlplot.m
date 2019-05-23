
function [C,H] = seasnlplot(SeasnlUnf, lat, lon, nlat, nlon, fsize, plotn, plotstr, fignum, pname0, printflg, fpath)


switch (plotn) 
     case 1;
 		plotyp = 'robinson';
        pname = [pname0, '_seasonsg'];
     case 2;
 		plotyp = 'mercator';
        pname = [pname0, '_seasonsr'];
     case 3;
         plotyp = 'ortho';
         pname = [pname0, '_seasonsn'];
     case 4;
         plotyp = 'ortho';
         pname = [pname0, '_seasonss'];
end

%LATIDUDE AND LONGITUDE
latm	= repmat(lat,1,nlon);
lonm	= repmat(lon,1,nlat)';

%COAST LINES
coast = load('coast');
lonp = [lon; lon(1)+360.];

%MAP COLOR
nc = 16;
J=squeeze(SeasnlUnf(1,:,:));
colormap('Default');
temp = colormap;
colorindex = round(([1:nc]-.5)*size(temp,1)/nc);
newcolormap = temp(colorindex,:);


%PLOT OF EIGENVECTOR CHOSEN ON GLOBE
 
%SEASONAL CYCLE PICTURE
fignum=fignum+1;
figure(fignum);
plotstr=cat(2,'SEASONAL CYCLE:',plotstr);
titl=suptitle(plotstr);
set(titl,'FontWeight','bold');
P=get(titl,'position');
P(2)=P(2)+0.02; %pull title up by 2% of the axes height
set(titl,'position',P) %apply

    M=squeeze(SeasnlUnf(1,:,:));
    x0=min(M(:));
    x1=max(M(:));
    delta_xc=(x1-x0)/(nc);
    xc_values= [0:nc-1].*delta_xc+x0;
    caxis([xc_values(1) xc_values(end)]);
  
   latlim=[min(lat) max(lat)];   
    
  %January
  colormap(newcolormap);
  ax(1) = subplot(4,1,1);
  J=squeeze(SeasnlUnf(1,:,:));
  Jnp = [J, J(:,1)];
   switch(plotn);
     case 1
     axesm('MapProjection',plotyp,'MapLatLimit',latlim,'MapLonLimit',[0 360], 'MeridianLabel','on','ParallelLabel','on', 'MLabelLocation',180,'PLabelLocation',60,'FontSize',fsize);
     case 2
     axesm('MapProjection',plotyp,'MapLatLimit',latlim,'MapLonLimit',[0 360],'MeridianLabel','on','ParallelLabel','on', 'MLabelLocation',180,'PLabelLocation',60,'FontSize',fsize);
     case 3
     axesm('MapProjection',plotyp,'Origin',[90,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
     case 4;
     axesm('MapProjection',plotyp,'Origin',[270,0,0],'FontSize',fsize,'ParallelLabel','on','PLabelLocation',30);
   end
   framem('on'); gridm('on')
         tightmap
        plotm(coast.lat,coast.long); 
  [C,H] = contourfm(lat,lonp,Jnp);
  caxis([xc_values(1) xc_values(end)]);
  set(gca,'LineWidth',3.0,'FontSize',fsize);
  set(ax(1),'position',[0.1300 0.7673, 0.5482, 0.1577]);
  titl=title(['January']);
      P=get(titl,'position');
P(2)=P(2)+0.01; %pull title up by 1% of the axes height
set(titl,'position',P) %apply
  imagesc(magic(5));
  

  
  %April
  ax(2) = subplot(4,1,2);
  A=squeeze(SeasnlUnf(4,:,:));
  Anp = [A, A(:,1)];
   switch(plotn);
     case 1
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 2
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
     case 3
     axesm('MapProjection',plotyp,'Origin',[90,0,0],'FontSize',fsiz,'ParallelLabel','on','PLabelLocation',30);
     case 4;
     axesm('MapProjection',plotyp,'Origin',[270,0,0],'FontSize',fsiz,'ParallelLabel','on','PLabelLocation',30);
   end
   framem('on'); gridm('on')
         tightmap
        plotm(coast.lat,coast.long); 
    [C,H] = contourfm(lat,lonp,Anp);
    caxis([xc_values(1) xc_values(end)]);
  set(gca,'LineWidth',3.0,'FontSize',fsize);
  set(ax(2),'position',[0.1300 0.5482, 0.7750, 0.1577]);
  titl=title(['April']);
    P=get(titl,'position');
P(2)=P(2)+0.01; %pull title up by 1% of the axes height
set(titl,'position',P) %apply
  imagesc(magic(6));
  
  

  
  %July
  ax(3) = subplot(4,1,3);
  Ju=squeeze(SeasnlUnf(7,:,:));
  Junp = [Ju, Ju(:,1)];
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
  [C,H] = contourfm(lat,lonp,Junp);
  caxis([xc_values(1) xc_values(end)]);
  set(gca,'LineWidth',3.0,'FontSize',fsize);
   set(ax(3),'position',[0.1300 0.3291, 0.7750, 0.1577]);
  titl=title(['July']);
    P=get(titl,'position');
P(2)=P(2)+0.01; %pull title up by 1% of the axes height
set(titl,'position',P) %apply
  imagesc(magic(7));

  
  %October
  ax(4) = subplot(4,1,4);
  O=squeeze(SeasnlUnf(10,:,:));
  Onp = [O, O(:,1)];
   switch(plotn);
     case 1
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
       case 2
         axesm('MapProjection',plotyp,'MapLonLimit',[-0 360],'MapLatLimit',latlim,'MeridianLabel','on','ParallelLabel','on','MLabelLocation',90,'PLabelLocation',60,'FontSize',fsize);
       case 3
     axesm('MapProjection',plotyp,'Origin',[90,0,0],'FontSize',fsiz,'ParallelLabel','on','PLabelLocation',30);
     case 4;
     axesm('MapProjection',plotyp,'Origin',[270,0,0],'FontSize',fsiz,'ParallelLabel','on','PLabelLocation',30);
   end
  framem('on'); gridm('on')
         tightmap
        plotm(coast.lat,coast.long); 
  [C,H] = contourfm(lat,lonp,Onp);
  caxis([xc_values(1) xc_values(end)]);
  set(gca,'LineWidth',3.0,'FontSize',fsize);
   set(ax(4),'position',[0.1300 0.1100, 0.7750, 0.1577]);
  titl=title(['October']);
    P=get(titl,'position');
P(2)=P(2)+0.01; %pull title up by 1% of the axes height
set(titl,'position',P) %apply


  
h=colorbar;
caxis([xc_values(1) xc_values(end)]);
set(get(h,'ylabel'),'string','Geopotential Height (m)','FontSize',fsize);
set(h, 'Position', [.8314 .11 .0581 .8150]);
for i=1:4
    pos=get(ax(i), 'Position');
    axes(ax(i));
    set(ax(i), 'Position', [pos(1) pos(2) .6626 pos(4)])
end
if (printflg)
    fname=sprintf('%s%s',fpathb,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
end; 
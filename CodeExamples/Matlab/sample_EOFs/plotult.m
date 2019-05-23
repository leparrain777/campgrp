%function [] = plotult(W,n_eof)
%This plotting program reads in data from the run_EOF.m program written by
%M. Werber.
%Choose the plot, and then 

close all;
W = EOF_spatial; %Data set you make the plots for


clf reset;
fignum = 0;						% Initialize plot number counter
printflg = 1;					% set to 1 for output to file
fpath = 'Figures/';
% FILENAME-SPECS
pname0 = ['level.',num2str(l1), '_' ,num2str(l2)]	;	% base filename



%PLOTTING-SPECS
n_eof=4; %number of eofs
glob=1; %global plot
npol=0; %north pole plot
spol=0; %south pole plot
rect=0; %rectangular plot


plotn=1; %Plotn is the projection type for stat and seasonal plots. 1=robinson,2=mercator,3=ortho (north polar), 4=ortho (south polar)
%Still need to fix the polar seasonal plots.
seasnl=0;
stat=1;

%AESTHETICS
fsize=10; %font size









for n= 1:n_eof; %Eigenvector set you want to look at.
Wn = W(:,:,n);
Perc=floor(100.*rel_var(n));
titlestr=['EOF ', num2str(n), '    Percent Variance Captured: ', num2str(Perc) ,'%   ' num2str(floor(ti)) ' to ' num2str(floor(tf)) ' Lats: ' ,num2str(floor(lat(1))), ' ' ,num2str(floor(lat(end)))];

%Global Plot
if (glob);
fignum=fignum+1;
figure(fignum);
pname = [pname0, '_eofg',num2str(n)];
    globplot(Wn, lat, lon, nlat, nlon, fsize);
titl=title(titlestr);
set(titl,'FontWeight','bold','FontSize',fsize);
P=get(titl,'position');
P(2)=P(2)+0.05; %pull title up by 5% of the axes height
    if (printflg);
    fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
end;
end;


%Rectangular Plot
if (rect);
fignum=fignum+1;
figure(fignum);
pname = [pname0, '_eofr',num2str(n)];
   rectplot(Wn, lat, lon, nlat, nlon, fsize);
titl=title(titlestr);
set(titl,'FontWeight','bold','FontSize',fsize);
P=get(titl,'position');
P(2)=P(2)+0.05; %pull title up by 5% of the axes height
    if (printflg);
    fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
end;
end;

%North Pole Plot
if (npol);
fignum=fignum+1;
figure(fignum);
pname = [pname0, '_eofn',num2str(n)];
   npolplot(Wn, lat, lon, nlat, nlon, fsize);
titl=title(titlestr);
set(titl,'FontWeight','bold','FontSize',fsize);
P=get(titl,'position');
P(2)=P(2)+0.05; %pull title up by 5% of the axes height
    if (printflg);
    fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
end;
end;

%South Pole Plot
if (spol);
fignum=fignum+1;
figure(fignum);
pname = [pname0, '_eofs',num2str(n)];
   spolplot(Wn, lat, lon, nlat, nlon, fsize);
titl=title(titlestr);
set(titl,'FontWeight','bold','FontSize',fsize);
P=get(titl,'position');
P(2)=P(2)+0.05; %pull title up by 5% of the axes height
set(titl,'position',P) %apply
    if (printflg);
    fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
end;
end;

% PRINCIPAL COMPONENT
fignum=fignum+1;
figure(fignum);
pname = [pname0, '_PC',num2str(n)];
titl=suptitle(titlestr);
set(titl,'FontWeight','bold');
P=get(titl,'position');
P(2)=P(2)+0.00; %pull title up by 0% of the axes height
set(titl,'position',P) %apply
%PLOT TIME SERIES
haxes = subplot(2,1,1);	
time_series = PC(:,n);
H=plot(time,PC(:,n));
title(['PC']);
set(gca,'LineWidth',2.0,'FontSize', fsize);
xl1=xlabel('Year');
yl1=ylabel('Normalized Amplitude');

% PLOT PWELCH
haxes = subplot(2,1,2);
[pw freq] = pwelch(time_series,floor(length(time_series)./2),[],[],1);
semilogx(freq, pw)
set(gca,'LineWidth',2.0,'FontSize', fsize);
xlabel(['Frequency (Months^{-1})'] )
ylabel('Power')
title('Welch Spectrum-3 Windows')
    if (printflg);
    fname=sprintf('%s%s',fpath,pname);
    print('-dpsc2',[fname,'.ps']); %color PS file
    print('-depsc2',[fname,'.eps']); %Color EPS file
end;
end

plotstr= ['   ', num2str(first_level),'-',num2str(second_level),'hPa   ' num2str(ti) '-' num2str(tf) '    Lats: ' ,num2str(lat(1)), '  ', num2str(lat(end))];
SeasnlUnf=seasonal_unf;
%Seasonal Plot
if (seasnl);
 seasnlplot(SeasnlUnf, lat, lon, nlat, nlon,fsize, plotn, plotstr, fignum, pname0, printflg, fpath);
end;


%Statistical Plots
if (stat);
    statplot(sdev, skw, krt, lat, lon, nlat, nlon, fsize, fignum, plotstr, plotn, printflg, fpath, pname0, Dbar_unf);
end;
    
    

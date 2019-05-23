clear; close all; clf
!\rm -f Output/z.dat Output/x.dat Output/model-accumulation-ablation-temperature.eps 
!\rm -f Output/model-results-variable-T-deep-ocean.eps

% compile and run:
! cd ~/SIS_bifurcation; pwd; make; time Output/SIS_bifurcation.exe

% temperature and ice area timeseries:
subplot('Position',[0.1 0.4 0.8 0.18]) % ('Position',[left bottom width height])
load Output/z.dat; 
h=plot(z(:,1),z(:,2))
set(h,'LineStyle','-','LineWidth',1.0,'Color',[0 0 0])
% [haxes,hline1,hline2]=plotyy(z(:,1),z(:,2),z(:,1),z(:,3)); 
% set(haxes(1),'XLim',[-1400 0],'YLim',[-0.1 0.5],'YColor',[0 0 0])
% set(haxes(2),'XLim',[-1400 0],'YLim',[-25 20],'YColor',[0 0 0])
% set(hline1,'LineStyle','-','LineWidth',1.0,'Color',[0 0 0])
% set(hline2,'LineStyle',':','LineWidth',1.0,'Color',[0 0 0])
title('Land ice area (solid); Temperature (dots)')
% comparison to specmap:
%hold on; load specmap.dat; zz=specmap; plot(-zz(:,1),0.23+0.09*(zz(:,2)-mean(zz(:,2))),'r');
xlabel('time (kyr)')

% ablation and precipitation timeseries:
%subplot('Position',[0.1 0.1 0.8 0.18]) % ('Position',[left bottom width height])
%h=plot(z(:,1),z(:,4),'k-',z(:,1),z(:,5),'k:');
%set(h,'LineWidth',1.0)
%V = axis;
%axis([-1400 0 0.00 0.17])
%title('Precipitation (solid); Ablation (dots)')
%xlabel('time (kyr)')

print -depsc Output/model-results-variable-T-deep-ocean.eps 
refresh


% sensitivity of ablation and precipitation to temperature:
figure(2)
subplot('Position',[0.1 0.5 0.5 0.3]) % ('Position',[left bottom width height])
load Output/x.dat; 
h=plot(x(:,1),x(:,2),'-k',x(:,1),x(:,3),'--k',x(:,1),x(:,4),'-.k'); %,x(:,1),x(:,5),'b'); 
set(h,'LineWidth',2.0)
V = axis;
axis([-15 5 0 0.15])
title('P_{init} (solid); P_{final} (dash); Ablation (dash-dot)')
xlabel('Atm Temperature')
print -depsc Output/model-accumulation-ablation-temperature.eps
refresh

h=figure(1);
set(h,'Position',[400 50 840 630])

figure(4)
%
color2 = [0.7 0 0];
%
cutoffTime = 1500000;
shift = 10000;
ind1a = find((shift <= ndxTime) & (ndxTime < cutoffTime));
ind1b = find(hTime < cutoffTime);
%
data = modeEcc(ind1b) + hModes(ind1b, 7);
index = ndxEcc100(ind1a)
scale = std(data)/std(index);
mu_Ecc = mean(index);
mu_data = mean(data);
%
h1=plot((ndxTime(ind1a)-shift)./10^6, (index-mu_Ecc)*scale+mu_data, 'Color', color2);
hold on;
h2=plot(hTime(hTime < cutoffTime)./10^6, -1.*data, 'k', 'LineWidth', 1.5);
plot(hTime(hTime < cutoffTime)./10^6, data*0.0, 'k--');
%
%plot(hTime(hTime < cutoffTime)./10^6*0.0+1.25, data, 'b', 'LineWidth', 1.1)
%
hold off;
%
xlabel('Time (Myr ago)', 'FontWeight', 'bold');
%legend('Ecc Index', 'IMF 5');
%set(gca,'ytick',[])
xlim([-0.05, 1.55]);
ylim([-0.7 0.7]);
%
% Set Right side axes
%
ax1 = gca;
set(ax1, 'Box', 'off', 'YColor', 'k','FontWeight','bold','LineWidth',1.5);
temp = [0.6 0.4 0.2 0 -0.2 -0.4 -0.6];
set(ax1, 'YTickLabel', temp);
ylabel(ax1,'\delta^{18}O Anomaly');
ax2 = axes('Position',get(ax1,'Position'),...
           'XAxisLocation','top',...
           'YAxisLocation','right',...
           'Color','none',...
           'Box','off',...
           'XTick',get(ax1,'XTick'),...
           'XTickLabel',[],...
           'YColor',color2,...
           'FontWeight','bold',...
           'LineWidth',1.1)
ylabel(ax2,'Eccentricity (100 kyr component)');
ylim2 = ylim(ax1)./scale+mu_Ecc;
ylim(ax2, ylim2);
%
% Annotate
%
annotation('arrow',[.76 .76], [.35 .45],'LineWidth',2.0);

% Print to file

if (printflg)
    fpath = './';
    fname0 = 'Fig4';
    fname = strcat(fpath,fname0,'.eps')
    print('-depsc', fname)
    fname = strcat(fpath,fname0,'.pdf')
    print( '-dpdf', fname)
end

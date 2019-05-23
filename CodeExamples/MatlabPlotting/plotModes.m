maxStd = 0;
offSet = 100;

for ndx = 2 : 11 maxStd = max(maxStd, std(hModes(:,ndx))); end

nt1 = findbin(2.*10^6, hTime,1);
%
%   Construct trend using last "ntrend" IMFs + residual
ntrend = 3;
trend = sum(hModes(1:nt1, end-ntrend:end),2);

figure(2);
hold on

% dummy axes for the box and background color
%ax0 = axes;
%set (ax0, 'Box', 'on', 'Color', 'white', 'XTick', [], 'YTick', []);

% first axes for left y-axis
%ax1 = axes ('Position', get (ax0, 'Position'));
%set (ax1, 'Box', 'off', 'Color', 'none', 'YAxisLocation', 'left');

% second axes for right y-axis assuming common x-axis controlled by ax1
%ax2 = axes ('Position', get (ax0, 'Position'));
%set (ax2, 'Box', 'off', 'Color', 'none', 'XTick', [], 'YAxisLocation', 'right');

leftTicks = [];
leftTickLabels = [];
rightTicks = [];
rightTickLabels = [];

ax = plotyy(0,0,0,0);

top = offSet + 6 * maxStd;
color2 = [0.7 0 0];


for ndx = 1 : 12 
   H=plot(hTime(1:nt1)./10^6, -1*hModes(1:nt1, ndx)*0.0 + offSet, 'k--','LineWidth',0.5);
   plot(hTime(1:nt1)./10^6, -1*hModes(1:nt1, ndx) + offSet, 'k', 'LineWidth', 1.2);
   switch ndx
       case 1
           plot(hTime(1:nt1)./10^6, -1*trend+offSet, 'r','LineWidth',0.5);
           text(-0.07, offSet, 'D', 'Units', 'Data', 'FontWeight', 'bold')
       case 12
           text(-0.07, offSet, 'R', 'Units', 'Data', 'FontWeight', 'bold');
       otherwise
           text(-0.07, offSet, num2str(ndx-1), 'Units', 'Data', 'FontWeight', 'bold');       
   end
   %if ndx == 6
    %  plot(hTime*0.0+.8, hModes(:, ndx) + offSet, 'r')
   %end
   
   %tickR = max([maxStd, 2 * std(hModes(:, ndx))]);
   tickR = 0.25;
   ticks = [-tickR, 0 , tickR] + offSet;
   tickLabel = [tickR, 0, -tickR]; 
   tickLabel = roundn(tickLabel, floor(log10(tickR) - 1));

   if (~mod(ndx, 2))
      leftTicks = [ticks, leftTicks];
      leftTickLabels = [leftTickLabels, tickLabel];
   else
      rightTicks = [ticks, rightTicks];
      rightTickLabels = [rightTickLabels, tickLabel];
   end

   offSet = offSet - 5 * maxStd; 
end

bottom = offSet;
xlabel(ax(1),'Time (Myr ago)','FontWeight','bold','FontSize',10);

set(ax(1), 'box', 'off', 'YColor', 'k', 'FontSize', 8, 'FontWeight', 'bold');
set(ax(2), 'box', 'off', 'XAxisLocation', 'top',  'YColor', 'k', 'FontSize', 8, 'FontWeight', 'bold');
set(ax(1), 'Ytick', leftTicks);
set(ax(1), 'YTickLabel', leftTickLabels, 'FontSize', 8, 'FontWeight', 'bold');
set(ax(2), 'Ytick', rightTicks);
set(ax(2), 'YTickLabel', rightTickLabels);

% set(gca,'ytick',[])
xlim0 = [-0.1, 2.1];
xlim(xlim0)
ylabel('\delta^{18}O Anomaly','FontWeight','bold','FontSize',10);
set(ax(1), 'ylim', [bottom, top], 'LineWidth',1.1,'FontWeight','bold')
set(ax(2), 'ylim', [bottom, top], 'LineWidth',1.1,'FontWeight','bold')

%set(ax(1), 'Xtick', [])
%set(ax(1), 'Xticklabel', [])
set(ax(2), 'Xtick', [])
set(ax(2), 'Xticklabel', [])
%
% annotate plot
%
%   arrow at MPT start
%
harrow = annotation('arrow',[0.611 0.611], [0.495 0.53]); % 1.25 MYa
%harrow = annotation('arrow',[0.588 0.588], [0.06 0.09]); % 1.2 MYa
text(0.92, 0.655, '23kyr' ,'unit','normalized','FontWeight','Bold');
text(0.92, 0.57, '41kyr','unit','normalized','FontWeight','Bold');
text(0.92, 0.50, '100kyr','unit','normalized','FontWeight','Bold');
%text(0.92, 0.345, '400kyr','unit','normalized','FontWeight','Bold');
hold off;

% Print to file

if (printflg)
    fpath = './';
    fname0 = 'Fig2';
    fname = strcat(fpath,fname0,'.eps')
    print('-depsc', fname)
    fname = strcat(fpath,fname0,'.pdf')
    print( '-dpdf', fname)
end
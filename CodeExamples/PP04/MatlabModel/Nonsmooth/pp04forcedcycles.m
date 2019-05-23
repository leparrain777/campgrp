%
%  Create and plot sample cycles for PP04 model
%
%
fignum = 0;
% Selected phase plane plots
ddlc = [0.05, 0.16, 0.27];
nd = length(ddlc);
%
ttt = cell([nd 1]);
yyy = cell([nd 1]);
tte = cell([nd 1]);
yye = cell([nd 1]);
%
%
fignum = fignum+1;
figure(fignum);
clf;
%d
for id = nd
    tfshift = -40;
    tfcut = 0;
    singleforcedplot;
    ylim([0.0 0.9]);
    xlim([0.0 0.9]);
end
fpath = './Figs/';
fname0 = sprintf('PP04_forcedcycle_d=%g_ts=%i_tc=%g',p.d,tshift,tfcut);
print(sprintf('%s%s.pdf',fpath,fname0),'-dpdf');
print(sprintf('%s%s.eps',fpath,fname0),'-depsc2');
%
fignum = fignum+1;
figure(fignum);
clf;
%
for id = 2
    tfshift = -85;
    tfcut = 0;
    singleforcedplot;
    ylim([0.0 0.9]);
    xlim([0.0 0.9]);
end
fpath = './Figs/';
fname0 = sprintf('PP04_forcedcycle_d=%g_ts=%i_tc=%g',p.d,tshift,tfcut);
print(sprintf('%s%s.pdf',fpath,fname0),'-dpdf');
print(sprintf('%s%s.eps',fpath,fname0),'-depsc2');
%
fignum = fignum+1;
figure(fignum);
clf;
%
for id = 1
    tfshift = -3+40;
    tfcut = 0;
    singleforcedplot;
    ylim([0.0 0.9]);
    xlim([0.0 0.9]);
end
fpath = './Figs/';
fname0 = sprintf('PP04_forcedcycle_d=%g_ts=%i_tc=%g',p.d,tshift,tfcut);
print(sprintf('%s%s.pdf',fpath,fname0),'-dpdf');
print(sprintf('%s%s.eps',fpath,fname0),'-depsc2');
%


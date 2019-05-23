function savefigure(path,name,number);
%
ffname = sprintf('%s%s_Fig%i', path, name, number);
savefig(ffname);

h=figure(number);
set(h,'Units','centimeters');
pos = get(h,'Position');
set(h,'PaperPositionMode','Auto','PaperUnits','centimeters','PaperSize',[pos(3), pos(4)])

%print(h,'filename','-dpdf','-r0')
%print(sprintf('%s.pdf',ffname),'-dpdf','-bestfit');
print(sprintf('%s.pdf',ffname),'-dpdf','-r0');
%print(sprintf('%s.eps',ffname),'-depsc2');
%
end
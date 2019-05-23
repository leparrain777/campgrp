%
%
figure(1);
clf;
%
H=plot(dd,Vmin,'r',dd,Vmax,'b','LineWidth',2.0);
xlabel('d');
ylabel('V');
set(gca,'FontSize',14','FontWeight','bold','LineWidth',2.0);
set(gca,'YDir','reverse');
ylim([-0.1 0.9]);
%
dd0 = [-0.1:0.01:0];
dd1 = [0:0.01:0.32];
dd2 = [0.32:0.01:0.4];
Veq0 = 0.0+dd0*0.0;
Veq1 = ddlc/(p.b-p.a);
Veq2 = (p.z-p.x*p.delta)/(1-p.x*p.beta)+dd2*0.0;
hold on
plot(dd0,Veq0,'k',dd1,Veq1,'k--',dd2,Veq2,'k','LineWidth',2.0);
plot(dd,dd*0.0,'k--',dd*0.0,Vmax*2-.5,'k--','LineWidth',0.5);
hold off
fname0 = 'PP04nsBifur';
print(sprintf('%s.pdf',fname0),'-dpdf');
print(sprintf('%s.eps',fname0),'-depsc2');
%
%
figure(2);
clf;
%
H=plot(dd,period);



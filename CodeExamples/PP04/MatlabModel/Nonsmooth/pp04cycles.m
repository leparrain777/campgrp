%
%  Create and plot sample cycles for PP04 model
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
%
for id = nd
    hold on;
%
%
%   Load PP04 parameters
    pp04ns_param;
% Overwrite p.d parameter
    p.d = ddlc(id);
    %
    %
    % Run forced PP04
    pp04modelrun;
    % Run pp04 unforced;
    p.y=0;
    p.c=0;
    p.alpha=0;
    pp04modelrun;
    %
    ti = t0+2*ttrans;
    j0 = findbin(ti,te,1);
    ts = te(j0);
    tm = te(j0+1);
    tf = te(j0+2);
    k0 = findbin(ts,tt,1);
    k1 = findbin(tm,tt,1);
    k2 = findbin(tf,tt,1);
    ms1 = mstate(j0);
    if (ms1)
        H=plot(yy(k0:k1,2),yy(k0:k1,1),'r','LineWidth',2.0);
        hold on;
        plot(yy(k1:k2,2),yy(k1:k2,1),'b','LineWidth',2.0);
        hold off;
        period = [te(j0+2)-te(j0), te(j0+1)-te(j0), te(j0+2)-te(j0+1)];
    else
        H=plot(yy(k0:k1,2),yy(k0:k1,1),'b','LineWidth',2.0);
        hold on;
        plot(yy(k1:k2,2),yy(k1:k2,1),'r','LineWidth',2.0);
        hold off;
        period = [te(j0+2)-te(j0), te(j0+2)-te(j0+1), te(j0+1)-te(j0)];
    end %if
    xlabel('A');
    ylabel('V');
    ylim([0.2 0.8]);
    xlim([0.2 0.8]);
    set(gca,'FontSize',14','FontWeight','bold','LineWidth',2.0);
    set(gca,'Box','on','YDir','reverse');
    %
    % add trigger line (F=0)
    Vs = [0:0.01:0.9];
    As = (p.a*Vs+p.d)/p.b;
    hold on
    plot(As,Vs,'k--','LineWidth',2.0);
    % add unsatlbe eq. pt.
    Veq = p.d/(p.b-p.a);
    Aeq = (p.a*Veq+p.d)/p.b;
    plot(Aeq,Veq,'k.','MarkerSize',40);
    hold off;
    disp(sprintf('periodicity d=%g: full=%g, warm=%g (%g%%), cool=%g (%g%%)',...
        p.d,period(1),period(2),round(period(2)/period(1)*100),...
        period(3),round(period(3)/period(1)*100)));
end
if (savefig)
    fname0 = sprintf('PP04cycle_d=%g',p.d);
    print(sprintf('%s.pdf',fname0),'-dpdf');
    print(sprintf('%s.eps',fname0),'-depsc2');
end  %if
%
fignum = fignum+1;
figure(fignum);
clf;
%
for id = 2
    hold on;
%   Load PP04 parameters
    pp04ns_param;%
% Overwrite p.d parameter
    p.d = ddlc(id);
    %
    % Run forced PP04
    pp04modelrun;
    %
    % Run unforced PP04
    p.y=0;
    p.c=0;
    p.alpha=0;
    pp04modelrun;
    %
    ti = t0+2*ttrans;
    j0 = findbin(ti,te,1);
    ts = te(j0);
    tm = te(j0+1);
    tf = te(j0+2);
    k0 = findbin(ts,tt,1);
    k1 = findbin(tm,tt,1);
    k2 = findbin(tf,tt,1);
    ms1 = mstate(j0);
    if (ms1)
        H=plot(yy(k0:k1,2),yy(k0:k1,1),'r','LineWidth',2.0);
        hold on;
        plot(yy(k1:k2,2),yy(k1:k2,1),'b','LineWidth',2.0);
        hold off;
        period = [te(j0+2)-te(j0), te(j0+1)-te(j0), te(j0+2)-te(j0+1)];
    else
        H=plot(yy(k0:k1,2),yy(k0:k1,1),'b','LineWidth',2.0);
        hold on;
        plot(yy(k1:k2,2),yy(k1:k2,1),'r','LineWidth',2.0);
        hold off;
        period = [te(j0+2)-te(j0), te(j0+2)-te(j0+1), te(j0+1)-te(j0)];
    end %if
    xlabel('A');
    ylabel('V');
    ylim([0.0 0.8]);
    xlim([0.0 0.8]);
    set(gca,'FontSize',14','FontWeight','bold','LineWidth',2.0);
    set(gca,'Box','on','YDir','reverse');
    %
    % add trigger line (F=0)
    Vs = [0:0.01:0.9];
    As = (p.a*Vs+p.d)/p.b;
    hold on
    plot(As,Vs,'k--','LineWidth',2.0);
    % add unsatlbe eq. pt.
    Veq = p.d/(p.b-p.a);
    Aeq = (p.a*Veq+p.d)/p.b;
    plot(Aeq,Veq,'k.','MarkerSize',40);
    hold off
    disp(sprintf('periodicity d=%g: full=%g, warm=%g (%g%%), cool=%g (%g%%)',...
        p.d,period(1),period(2),round(period(2)/period(1)*100),...
        period(3),round(period(3)/period(1)*100)));
end
if (savefig)
    fname0 = sprintf('PP04cycle_d=%g',p.d);
    print(sprintf('%s.pdf',fname0),'-dpdf');
    print(sprintf('%s.eps',fname0),'-depsc2');
end %if
%
fignum = fignum+1;
figure(fignum);
clf;
%
for id = 1
    hold on;
%
%   Load PP04 parameters
    pp04ns_param;
% Overwrite p.d parameter
    p.d = ddlc(id);
    %
    % Run forced PP04
    pp04modelrun;
    %
    % Run unforced PP04
    p.y=0;
    p.c=0;
    p.alpha=0;
    pp04modelrun;
    %
    ti = t0+2*ttrans;
    j0 = findbin(ti,te,1);
    ts = te(j0);
    tm = te(j0+1);
    tf = te(j0+2);
    k0 = findbin(ts,tt,1);
    k1 = findbin(tm,tt,1);
    k2 = findbin(tf,tt,1);
    ms1 = mstate(j0);
    if (ms1)
        H=plot(yy(k0:k1,2),yy(k0:k1,1),'r','LineWidth',2.0);
        hold on;
        plot(yy(k1:k2,2),yy(k1:k2,1),'b','LineWidth',2.0);
        hold off;
        period = [te(j0+2)-te(j0), te(j0+1)-te(j0), te(j0+2)-te(j0+1)];
    else
        H=plot(yy(k0:k1,2),yy(k0:k1,1),'b','LineWidth',2.0);
        hold on;
        plot(yy(k1:k2,2),yy(k1:k2,1),'r','LineWidth',2.0);
        hold off;
        period = [te(j0+2)-te(j0), te(j0+2)-te(j0+1), te(j0+1)-te(j0)];
    end %if
    xlabel('A');
    ylabel('V');
    ylim([0.0 0.8]);
    xlim([0.0 0.8]);
    set(gca,'FontSize',14','FontWeight','bold','LineWidth',2.0);
    set(gca,'Box','on','YDir','reverse');
    %
    % add trigger line (F=0)
    Vs = [0:0.01:0.9];
    As = (p.a*Vs+p.d)/p.b;
    hold on
    plot(As,Vs,'k--','LineWidth',2.0);
    % add unsatlbe eq. pt.
    Veq = p.d/(p.b-p.a);
    Aeq = (p.a*Veq+p.d)/p.b;
    plot(Aeq,Veq,'k.','MarkerSize',40);
    hold off;
    disp(sprintf('periodicity d=%g: full=%g, warm=%g (%g%%), cool=%g (%g%%)',...
        p.d,period(1),period(2),round(period(2)/period(1)*100),...
        period(3),round(period(3)/period(1)*100)));
end %for
if (savefig)
    fname0 = sprintf('PP04cycls_d=%g-%g',ddlc(1),ddlc(end));
    print(sprintf('%s.pdf',fname0),'-dpdf');
    print(sprintf('%s.eps',fname0),'-depsc2');
end %if
%
fignum = fignum+1;
figure(fignum);
clf;
%
for id = 1:nd
    hold on;
%
%   Load PP04 parameters
    pp04ns_param;
% Overwrite p.d parameter
    p.d = ddlc(id);
    %
    % Run forced PP04
    pp04modelrun;
    %
    % Run unforced PP04
    p.y=0;
    p.c=0;
    p.alpha=0;
    pp04modelrun;
    %
    ti = t0+2*ttrans;
    j0 = findbin(ti,te,1);
    ts = te(j0);
    tm = te(j0+1);
    tf = te(j0+2);
    k0 = findbin(ts,tt,1);
    k1 = findbin(tm,tt,1);
    k2 = findbin(tf,tt,1);
    ms1 = mstate(j0);
    if (ms1)
        H=plot(yy(k0:k1,2),yy(k0:k1,1),'r','LineWidth',2.0);
        hold on;
        plot(yy(k1:k2,2),yy(k1:k2,1),'b','LineWidth',2.0);
        hold off;
        period = [te(j0+2)-te(j0), te(j0+1)-te(j0), te(j0+2)-te(j0+1)];
    else
        H=plot(yy(k0:k1,2),yy(k0:k1,1),'b','LineWidth',2.0);
        hold on;
        plot(yy(k1:k2,2),yy(k1:k2,1),'r','LineWidth',2.0);
        hold off;
        period = [te(j0+2)-te(j0), te(j0+2)-te(j0+1), te(j0+1)-te(j0)];
    end %if
    xlabel('A');
    ylabel('V');
    ylim([0.0 0.8]);
    xlim([0.0 0.8]);
    set(gca,'FontSize',14','FontWeight','bold','LineWidth',2.0);
    set(gca,'Box','on','YDir','reverse');
    %
    % add trigger line (F=0)
    Vs = [0:0.01:0.9];
    As = (p.a*Vs+p.d)/p.b;
    hold on
    plot(As,Vs,'k--','LineWidth',2.0);
    % add unsatlbe eq. pt.
    Veq = p.d/(p.b-p.a);
    Aeq = (p.a*Veq+p.d)/p.b;
    plot(Aeq,Veq,'k.','MarkerSize',40);
    hold off;
    disp(sprintf('periodicity d=%g: full=%g, warm=%g (%g%%), cool=%g (%g%%)',...
        p.d,period(1),period(2),round(period(2)/period(1)*100),...
        period(3),round(period(3)/period(1)*100)));
end %for
if (savefig)
    fname0 = sprintf('PP04cycls_d=%g-%g',ddlc(1),ddlc(end));
    print(sprintf('%s.pdf',fname0),'-dpdf');
    print(sprintf('%s.eps',fname0),'-depsc2');
end %if
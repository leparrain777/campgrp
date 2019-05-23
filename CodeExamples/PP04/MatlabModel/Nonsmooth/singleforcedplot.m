hold on;
    %
    %   Load PP04 parameters
    pp04ns_param;
    %   Overwrite p.d parameter
    p.d = ddlc(id);
    %
    %   Run forced PP04
    pp04modelrun;
    ttf = tt;
    yyf = yy;
    tef = te;
    yef = ye;
    cf = p.c;
    %   Run pp04 unforced;
    p.y=0;
    p.c=0;
    p.alpha=0;
    pp04modelrun;
    % unforced switch points
    ti = t0+2*ttrans;
    j0 = findbin(ti,te,1);
    ts = te(j0);
    tm = te(j0+1);
    tf = te(j0+2);
    k0 = findbin(ts,tt,1); %index for 1st switch
    k1 = findbin(tm,tt,1); %index for 2nd switch
    k2 = findbin(tf,tt,1); %index for 3rd switch
    % forced start and end times
    rs = ts+tfshift;
    rf = tf+tfshift-tfcut;
    kf0 = findbin(rs,ttf,1);
    kf2 = findbin(rf,ttf,1);
    % forced switch points
    jf0 = findbin(rs,tef,1);
    r0 = tef(jf0);
    if (r0 < rs)
        jf0=jf0+1;
        r0 = tef(jf0);
    end % if
    r1 = tef(jf0+1);
    r2 = tef(jf0+2);
    jr0 = findbin(r0,ttf,1);
    jr1 = findbin(r1,ttf,1);
    jr2 = findbin(r2,ttf,1);
    fperiod = [ttf(jr2)-ttf(jr0) ttf(jr2)-ttf(jr1) ttf(jr1)-ttf(jr0)];
    %
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
    set(gca,'FontSize',14','FontWeight','bold','LineWidth',2.0);
    set(gca,'Box','on','YDir','reverse');
    %
    % add trigger line (F=0)
    Vs = [0:0.01:0.9];
    As = (p.a*Vs+p.d)/p.b;
    Asp = (p.a*Vs+p.d+cf)/p.b;
    Asm = (p.a*Vs+p.d-cf)/p.b;
    hold on
    plot(As,Vs,'k--','LineWidth',2.0);
    plot(Asp,Vs,'k--',Asm,Vs,'k--','LineWidth',1.0);
    % add unstable eq. pt.
    Veq = p.d/(p.b-p.a);
    Aeq = (p.a*Veq+p.d)/p.b;
    plot(Aeq,Veq,'k.','MarkerSize',40);
    % add forced trajectory
    plot(yyf(kf0:kf2,2),yyf(kf0:kf2,1),'k','LineWidth',2.0);
    plot(yef(jf0,2),yef(jf0,1),'g.',yef(jf0+1,2),yef(jf0+1,1),'y.',...
        yef(jf0+2,2),yef(jf0+2,1),'r.','MarkerSize',30);
    hold off;
    disp(sprintf('periodicity d=%g: full=%g, warm=%g (%g%%), cool=%g (%g%%)',...
        p.d,period(1),period(2),round(period(2)/period(1)*100),...
        period(3),round(period(3)/period(1)*100)));
    disp(sprintf('forced periodicity d=%g: full=%g, warm=%g (%g%%), cool=%g (%g%%)',...
        p.d,fperiod(1),fperiod(2),round(fperiod(2)/fperiod(1)*100),...
        fperiod(3),round(fperiod(3)/fperiod(1)*100)));
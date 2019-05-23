%
%  Create and plot sample cycles for PP04 model
%
fignum = 0;
% Selected phase plane plots
ddlc = [0.27];
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
for id = 1
    hold on;
    %
    %
    %   Load PP04 parameters
    pp04ns_param;
    %   Overwrite p.d parameter
    p.d = ddlc(id);
    %
    % Run pp04 unforced;
    p.y=0;
    p.c=0;
    p.alpha=0;
    pp04modelrun;
    %
    % extract state variables
    V = yy(:,1);
    A = yy(:,2);
    C = yy(:,3);
    %
    % calculate efficienty variable F
    F = p.a*V-p.b*A+p.d;
    %
    % find times and state for single cycle
    %   events: trigger transitions (F=0);
    %   'cycle' defined as recurrence of trigger transition (same direction)
    ti = t0+2*ttrans;           % approx. initial time
    j0 = findbin(ti,te,1);      % event index for initial time
    ts = te(j0);                % starting event time
    tm = te(j0+1);              % 'mid' cycle event time
    tf = te(j0+2);              % final event time
    k0 = findbin(ts,tt,1);      % full time index for initial event
    k1 = findbin(tm,tt,1);      % full time index for mid-cycle event 
    k2 = findbin(tf,tt,1);      % full time undex for final event
    ms1 = mstate(j0);           % initial state of system for cycle
    %
    ind0 = [k0:k2];
    ind1 = [k0:k1];
    ind2 = [k1:k2];
    %
    period = [te(j0+2)-te(j0), te(j0+2-ms1)-te(j0+1-ms1), te(j0+1+ms1)-te(j0+ms1)];
    % setup equal time step points
    ns = 20;            % number of steps per cycle
    ds = period(1)/ns;  % time step
    ss1 = [ts:ds:tm];    % even time array, first branch
    V1e = interp1(tt,V,ss1);
    A1e = interp1(tt,A,ss1);
    C1e = interp1(tt,C,ss1);
    ss2 = flip([tf:-ds:tm]);    % even time array, second branch
    V2e = interp1(tt,V,ss2);
    A2e = interp1(tt,A,ss2);
    C2e = interp1(tt,C,ss2);
    % plot A vs V
    if (ms1)
        H=plot(A(ind1),V(ind1),'r','LineWidth',2.0);
        hold on;
        plot(A(ind2),V(ind2),'b','LineWidth',2.0);
        plot(A1e,V1e,'r.','MarkerSize',20);
        plot(A2e,V2e,'b.','MarkerSize',20);
        hold off;
    else
        H=plot(A(ind1),V(ind1),'b','LineWidth',2.0);
        hold on;
        plot(A(ind2),V(ind2),'r','LineWidth',2.0);
        plot(A1e,V1e,'b.','MarkerSize',20);
        plot(A2e,V2e,'r.','MarkerSize',20);
        hold off;
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
    % add unstable eq. pt.
    Veq = p.d/(p.b-p.a);
    Aeq = (p.a*Veq+p.d)/p.b;
    plot(Aeq,Veq,'k.','MarkerSize',40);
    hold off;
    
    
    disp(sprintf('periodicity d=%g: full=%g, warm=%g (%g%%), cool=%g (%g%%)',...
        p.d,period(1),period(2),round(period(2)/period(1)*100),...
        period(3),round(period(3)/period(1)*100)));
    if (savefig)
        fname0 = sprintf('PP04cycle_VA_d=%g',p.d);
        print(sprintf('%s.pdf',fname0),'-dpdf');
        print(sprintf('%s.eps',fname0),'-depsc2');
    end  %if
    %
    % plot C vs V
    fignum = fignum+1;
    figure(fignum);
    clf;
    %
    Vr1 = -p.x*C(ind1)+p.z;
    Cr1 = -p.beta*V(ind1)+ms1*p.gamma+p.delta;
    Vr2 = -p.x*C(ind2)+p.z;
    Cr2 = -p.beta*V(ind2)+(1-ms1)*p.gamma+p.delta;
    %
    if (ms1)        
        H=plot(C(ind1),V(ind1),'r','LineWidth',2.0);
        hold on;
        plot(C(ind2),V(ind2),'b','LineWidth',2.0);
        plot(Cr2,Vr2,'b--');
        plot(Cr1,Vr1,'r--');
        hold off;
        period = [te(j0+2)-te(j0), te(j0+1)-te(j0), te(j0+2)-te(j0+1)];

    else
        H=plot(C(ind1),V(ind1),'b','LineWidth',2.0);
        hold on;
        plot(C(ind2),V(ind2),'r','LineWidth',2.0);
        plot(Cr2,Vr2,'r--');
        plot(Cr1,Vr1,'b--');
        hold off;
        period = [te(j0+2)-te(j0), te(j0+2)-te(j0+1), te(j0+1)-te(j0)];
    end %if
    xlabel('C');
    ylabel('V');
    ylim([0.2 0.8]);
    xlim([0 0.8]);
    set(gca,'FontSize',14','FontWeight','bold','LineWidth',2.0);
    set(gca,'Box','on','YDir','reverse');
    if (savefig)
        fname0 = sprintf('PP04cycle_CA_d=%g',p.d);
        print(sprintf('%s.pdf',fname0),'-dpdf');
        print(sprintf('%s.eps',fname0),'-depsc2');
    end  %if
end


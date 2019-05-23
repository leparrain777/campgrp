function IceAge_lyapscan_QP_31_8
%%
%% Computes scan of lyapunov exponents QP forcing of various Ice Age models
%% last change 23/6/2017 (PA):
%  -- added Lin and Young shear forced oscillator
%  -- added de Saedeleer forcing and save to subdirectory
%% last change 15/6/2017 (CDC):
%  -- restructured call to ode45, streamlined timestepping
%  -- implemented option for integrated summer insolation forcing
%  -- changed if-elseif to case-switch in fn_lypas, loadModel
%  -- replaced legacy rand initialization with rng
%% last change 07/6/2017 (AH): added model option 5, TG03
%% last change 28/5/2017 (PA)

tic;
rng(199,'twister');

% plotfigs=true to plot timeseries
%plotfigs=false;
plotfigs=true;

p.model=2;
[p, mname] = loadModel(p);
% model options are
%   1=Palliard Parrenin 2004
%   2=Saltzmann Maasch 1991
%   3=van der Pol as in de Saedleleer et al 2013
%   4=van der Pol - Duffing
%   5=Tziperman-Gildor2003 %% added by AH
%   6=phase oscillator - Mitsui et al 2015
%   7=shear induced chaos oscillator - Lin and Young 2008

p.forcing=1;
% forcing options are
%   1=periodic (sum of 2 sinusoids)
%   2=Integrated Summer Insolation
%   3=de Saedeleer et al forcing with sum of obliquity and precession

% detuning
p.tau=1.0;

%integration transient time and maximum time (kyr)
ttrans=-60; 
%tmax=5000;  % for integrated summer forcing, need tmax-ttrans < 5000
tmax=1000;  % for integrated summer forcing, need tmax-ttrans < 5000

% choose forcing type and setup 2D scan
switch p.forcing
    case 1
        fname = 'QP';
        % periodic: 2-frequency
        % obliquity frequency
        p.omega1=2*pi/41.0;
        % precession frequency
        p.omega2=2*pi/23.0;
        %
        p.kt1=1.0;  % initialize variable for amplitude of p.omega1 sinusoid
        % scan range for x (p.kt1)
        xm=0.0;
        xp=1.0;
        %
        p.kt2=1.0;  % initialize variable for amplitude of p.omega2 sinusoid
        % scan range for y (p.kt2)
        ym=0.0;
        yp=1.0;
        % resolution for scan
        xsteps=10;
        ysteps=10;
        % scan arrays for x & y
        xs=(0:xsteps-1)*(xp-xm)/(xsteps-1)+xm;
        ys=(0:ysteps-1)*(yp-ym)/(ysteps-1)+ym;
        % timestep -- integer fraction of fastest forcing period
        dt=2*pi/(4*p.omega2);

    case 2
        fname = 'IS';
        % summer integrated insolation
        p.kt1=1.0;  % initialize variable for amplitude of forcing
        % scan range, resolution and arrays for x (p.kt1)
        xm=0.0;
        xp=0.5;
        xsteps=256;
        xs=(0:xsteps-1)*(xp-xm)/(xsteps-1)+xm;
        % 
        p.kt2 = 275;  % initialize variable for threshold
        % scan range, resolution and arrays for y (p.kt2)
        ym = 125;       % min threshold (multiple of 25 in [0 600])
        yp = 425;       % max threshold (multiple of 25 in [0 600])
        dy = 25;        % delta threshold in scan (multiple of 25)
        ys = [ym:dy:yp];
        ysteps = length(ys);
        % latitude for integrated insolation
        insol_lat = 65;
        % timestep -- integer fraction of obliquity period
        dt=41/8;
        
    case 3
        % de Saedeleer forcing: load coeffs
        fname = 'DCW';
        load('./Data/dcwcoeffs.txt','dcwc')
        p.dcwcoeffs=dcwcoeffs;
        %
        p.kt1=1.0;  % initialize variable for amplitude of obliquity modes
        % scan range for x (p.kt1)
        xm=0.0;
        xp=1.0;
        %
        p.kt2=1.0;  % initialize variable for amplitude of precession modes
        % scan range for y (p.kt2)
        ym=0.0;
        yp=1.0;
        % resolution for scan
        xsteps=200;
        ysteps=200;
        % scan arrays for x & y
        xs=(0:xsteps-1)*(xp-xm)/(xsteps-1)+xm;
        ys=(0:ysteps-1)*(yp-ym)/(ysteps-1)+ym;
        % timestep -- pretty arbitrary
        dt=2*pi/(4*40.0);
        
    otherwise
        sprintf('Forcing not known')
        keyboard
end % switch p.forcing

% most positive lyap exponent
ly=zeros(ysteps,xsteps);

for jj=1:ysteps
    p.kt2=ys(jj);
    if (p.forcing == 2)   % get interpolant coeff for insolation forcing
        p.insolcf = get_integrated_insol(insol_lat, p.kt2, ttrans);
    end % if
    for ii=1:xsteps
        p.kt1=xs(ii);
        [lp]=calc_lyap(ttrans,tmax,dt,p,plotfigs);
        ly(jj,ii)=lp;
    end
    sprintf('%d percent completed',(floor(jj/ysteps*100)))
end

toc;
figure(2);
clf;

%imagesc(xs,ys,ly,[-0.015,0.015]);
imagesc(xs,ys,ly,[-0.02,0.02]);

axis xy;
xlabel('k_1');
ylabel('k_2');
ttext=sprintf('%s LEs %s KK tmax=%d ttrans=%d (xs,ys)=(%d,%d)',mname, fname, tmax,-ttrans,xsteps,ysteps);
title(ttext);
colorbar

ftt=sprintf('./FIGS/%s_%s_KK_tm_%d__tt_%d_xs_%d__ys_%d',mname, fname, tmax,-ttrans,xsteps,ysteps);

print('-dpdf',ftt);
savefig(ftt);

keyboard;

end

%%
function [lyap]=calc_lyap(ttrans,tmax,dt,p,plotfigs)

% arbitrary initial condition
yinit=zeros(2*p.N+1,1);
yinit(1)=0.5;
yinit(p.N+1)=1.0;

%% integration code starts here

tspan=[ttrans tmax];
sol = ode45(@(t,y) fn_lyaps(t,y,p), tspan, yinit);
y0 = deval(sol,0);
ymax = deval(sol,tmax);
lystart = y0(end);
lyend = ymax(end);
lyap=(lyend-lystart)/tmax;

if plotfigs==true
    tt = [0:dt:tmax]';
    yy = deval(sol,tt);
    figure(1);
    clf;
    subplot(4,1,1);
    
    %first compt
    if p.N==3
        plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b',tt(:),yy(3,:),'k');
    elseif p.N==2
        if p.model==7
            plot(tt(:),sin(yy(1,:)),'r',tt(:),yy(2,:),'b');    
        else
            plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b');    
        end
    else 
        plot(tt(:),sin(yy(1,:)),'r');
    end
    ylabel('y');
    title(sprintf('kt1=%.4f kt2=%.4f',p.kt1,p.kt2));
    subplot(4,1,2);
    %lyap convergent
    plot(tt(:),yy(end,:));
    ylabel('ll');
    
    %lyap convergent
    subplot(4,1,3);
    tskip = 20;
    plot(tt(tskip:end),yy(end,tskip:end)'./(tt(tskip:end)+1));
    ylabel('ftle');
    xlabel('t');
    
    %forcing
    subplot(4,1,4);
    tskip = 20;
    plot(tt,arrayfun(@(t) forcingF(t,p),tt));
    ylabel('F(t)');
    xlabel('t');
    
    drawnow();
    keyboard;
end


end

%% figures!

%%
function [fn] = fn_lyaps(t,y,p)

fn=p.zeros;

% evaluate forcing
F=forcingF(t,p);

switch p.model
    % for all models, LE growth rate (lambda) must be last state variable
    case 1
    % PP04
    % nonlinear vars
    xx=y(1);
    yy=y(2);
    zz=y(3);
    % le direction
    lx=y(4);
    ly=y(5);
    lz=y(6);
    % log le amplitude
    %ll=y(7);
    % x=IV, y=AA, z=mu
    hvs=(1+tanh(-p.KK*(p.h*xx-p.i*yy+p.j)))*0.5;
    dhvs=sech(-p.KK*(p.h*xx-p.i*yy+p.j))^2*0.5;
    % nonlinear eqs
    fx=(-p.a*zz-p.b*F+p.c-xx)/p.taui;
    fy=(xx-yy)/p.taua;
    fz=(p.d*F-p.e*xx+p.f*hvs+p.g-zz)/p.taumu;
    % variational ODE from Jacobian
    fxl=lx*(-1/p.taui)+ly*0+lz*(-p.a/p.taui);
    fyl=lx*(1/p.taua)+ly*(-1/p.taua)+lz*0;
    fzl=lx*(-p.e+p.f*dhvs*(-p.KK*p.h))/p.taumu+ly*(p.f*dhvs*(p.KK*p.i))/p.taumu+lz*(-1/p.taumu);
    % project out expansion direction
    lam=fxl*lx+fyl*ly+fzl*lz;
    lamn=lx*lx+ly*ly+lz*lz;
    % growth rate
    lambda=lam/lamn;
    %
    fn(1)=fx;
    fn(2)=fy;
    fn(3)=fz;
    fn(4)=(fxl-lambda*lx);
    fn(5)=(fyl-lambda*ly);
    fn(6)=(fzl-lambda*lz);
    fn(7)=lambda;
    %
    case 2
    % Saltzmann Maasch 1991
    xx=y(1);
    yy=y(2);
    zz=y(3);
    % le direction
    lx=y(4);
    ly=y(5);
    lz=y(6);
    % log le amplitude
    %ll=y(7);
    % SM91 modified
    fx=p.alpha1-p.alpha2*p.c*yy-p.alpha3*xx-p.kth*p.alpha2*zz-p.alpha2*F;
    fy=p.beta1-(p.beta2-p.beta3*yy+p.beta4*yy*yy)*yy-p.beta5*zz+p.Fmu;
    fz=p.gamma1-p.gamma2*xx-p.gamma3*zz;
    % variational ODE from Jacobian
    fxl=lx*(-p.alpha3)+ly*(-p.alpha2*p.c)+lz*(-p.kth*p.alpha2);
    fyl=lx*0+ly*(-p.beta2+2*p.beta3*yy-3*p.beta4*yy*yy)+lz*(-p.beta5);
    fzl=lx*(-p.gamma2)+ly*0+lz*(-p.gamma3);
    % project out expansion direction
    lam=fxl*lx+fyl*ly+fzl*lz;
    lamn=lx*lx+ly*ly+lz*lz;
    % growth rate
    lambda=lam/lamn;
    %
    fn(1)=fx;
    fn(2)=fy;
    fn(3)=fz;
    fn(4)=(fxl-lambda*lx);
    fn(5)=(fyl-lambda*ly);
    fn(6)=(fzl-lambda*lz);
    fn(7)=lambda;
    %
    case 3
    % de Saedeleer, Crucifix, Wieczorek (4a,b)
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % nonlinear ODE
    % extra delta term, xx term in fy changed sign
    fx=-(yy+p.beta-F);
    fy=-p.alpha*(yy*(yy*yy/3-1)-xx);
    % variational ODE
    % from Jacobian
    fxl=-ly;
    fyl=-p.alpha*(-lx+ly*(yy*yy-1));
    % project out zero expansion direction
    lam=fxl*lx+fyl*ly;
    lamn=lx*lx+ly*ly;
    % growth rate
    lambda=lam/lamn;
    %
    fn(1)=fx/p.tt;
    fn(2)=fy/p.tt;
    fn(3)=(fxl-lambda*lx)/p.tt;
    fn(4)=(fyl-lambda*ly)/p.tt;
    fn(5)=lambda/p.tt;
    %
    case 4
    % de Saedeleer, Crucifix, Wieczorek (4a,b) modified to become vdP-Duffing
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % nonlinear ODE
    % extra delta term, xx term in fy changed sign
    fx=-(yy+p.beta-F);
    fy=-p.alpha*(yy*(yy*yy/3-1)-xx*(-1+p.delta*xx*xx));
    % variational ODE
    % from Jacobian
    fxl=-ly;
    fyl=-p.alpha*(-lx*(-1+3*p.delta*xx*xx)+ly*(yy*yy-1));
    % project out zero expansion direction
    lam=fxl*lx+fyl*ly;
    lamn=lx*lx+ly*ly;
    % growth rate
    lambda=lam/lamn;
    % (3,4) gives direction, (5) gives log size
    fn(1)=fx/p.tt;
    fn(2)=fy/p.tt;
    fn(3)=(fxl-lambda*lx)/p.tt;
    fn(4)=(fyl-lambda*ly)/p.tt;
    fn(5)=lambda/p.tt;
    %
    case 5
    % TG03
    % nonlinear vars
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % log le amplitude
    %ll=y(5);
    % x=V_LI, y=T
    asi=p.Is0*(1+tanh(-p.KK*(p.Tf-yy)))*0.5;
    dasi=p.Is0*sech(-p.KK*(p.Tf-yy))^2*0.5;
    q=p.qr*p.epsq*p.A*exp(-p.B/yy);
    aLI=p.LEW^(1/3)*(xx/(2*sqrt(p.lambda)))^(2/3);
    a=p.aocn+p.alnd;
    % nonlinear eqs
    fx=(p.P0+p.P1*q)*(1-asi/p.aocn)-p.S0+p.SM*F+p.ST*(yy-273.15);
    fy=(p.aocn/p.Cocn)*(-p.eps*p.sigma*yy^4+p.Hs*(1-p.alphaS*asi/a-p.alphaL*aLI/a)*(1-p.alphaC));
    % variational ODE from Jacobian
    fxl=lx*0+ly*(p.P1*p.qr*p.epsq*p.A*p.B*exp(-p.B/yy)/(yy^2)*(1-asi/p.aocn)-(p.P0+p.P1*q)*p.KK*dasi/a+p.ST);
    fyl=lx*(-(p.aocn/p.Cocn)*(1-p.alphaC)*2*p.alphaL*aLI/(3*a*xx))+ly*(-(p.aocn/p.Cocn)*(p.eps*p.sigma*4*yy^3+(1-p.alphaC)*p.alphaS*p.KK*dasi/a));
    % project out expansion direction
    lam=fxl*lx+fyl*ly;
    lamn=lx*lx+ly*ly;
    %
    % growth rate
    lambda=lam/lamn;
    %
    % (3,4) gives direction, (5) gives log size
    fn(1)=fx/p.tt;
    fn(2)=fy/p.tt;
    fn(3)=(fxl-lambda*lx)/p.tt;
    fn(4)=(fyl-lambda*ly)/p.tt;
    fn(5)=lambda/p.tt;
    %
    case 6
    % Mitsui, Crucifix, Aihara phase oscillator(2015)
    xx=y(1);
    % le direction (trivial but kepts for consistency with above)
    lx=y(2);
    % nonlinear ODE
    temp=p.alpha*(1+p.gamma*F);
    fx=p.beta+temp*(cos(xx)+p.delta*cos(2*xx));
    % variational ODE
    % from Jacobian
    fxl=-lx*temp*(sin(xx)+2*p.delta*sin(2*xx));
    % project out zero expansion direction
    lam=fxl*lx;
    lamn=lx*lx;
    % growth rate
    lambda=lam/lamn;
    % NB second component should be zero
    fn(1)=fx/p.tt;
    fn(2)=(fxl-lambda*lx)/p.tt;
    fn(3)=lambda/p.tt;
    %
    case 7
    % Shear induced chaos Lin and Young (2008)
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % nonlinear ODE
    % extra delta term, xx term in fy changed sign
    fx=2*pi/p.uf+p.sigma*yy;
    fy=-p.lambda*yy+sin(xx)*F;
    % variational ODE
    % from Jacobian
    fxl=p.sigma*ly;
    fyl=-p.lambda*ly+cos(xx)*F*lx;
    % project out zero expansion direction
    lam=fxl*lx+fyl*ly;
    lamn=lx*lx+ly*ly;
    % growth rate
    lambda=lam/lamn;
    % (3,4) gives direction, (5) gives log size
    fn(1)=fx/p.tt;
    fn(2)=fy/p.tt;
    fn(3)=(fxl-lambda*lx)/p.tt;
    fn(4)=(fyl-lambda*ly)/p.tt;
    fn(5)=lambda/p.tt;
    %

    otherwise
    sprintf('model unknown')
    keyboard
end % switch-case

%scaling of model time by tau
ts=1/p.tau;

fn=fn*ts;

end

%%

function [FO]=forcingF(t,p)
% astro forcing same for all models
switch p.forcing
    case 1
        % periodic ( sum of 2 sinusoids)
        FO=p.kt1*sin(t*p.omega1)+p.kt2*sin(t*p.omega2);
    case 2
        % integrated summer insolation
        FO=p.kt1*ppval(p.insolcf, t);
    case 3
        % de Saedeleer, Crucifix, Wieczorek forcing
        F1=(p.dcwcoeffs(1:15,2).*sin(p.dcwcoeffs(1:15,1)*t)+p.dcwcoeffs(1:15,3).*cos(p.dcwcoeffs(1:15,1)*t));
        F2=(p.dcwcoeffs(16:35,2).*sin(p.dcwcoeffs(16:35,1)*t)+p.dcwcoeffs(16:35,3).*cos(p.dcwcoeffs(16:35,1)*t));
        % the magic 11.77 is in caption of Fig. 2.
        FO=(p.kt1*sum(F1)+p.kt2*sum(F2))/11.77;
    otherwise
        keyboard;
end % switch p.forcing

end

%%

function [p, mname]=loadModel(p)

switch p.model
    case 1
    %internal paramters for PP model
    mname='PP';
    p.a=1.3;
    p.b=0.5;
    p.c=0.8;
    p.d=0.15;
    p.e=0.5;
    p.f=0.5;
    p.g=0.4;
    p.h=0.3;
    p.i=0.7;
    p.j=0.27;
    p.taui=15;
    p.taua=12;
    p.taumu=5;
    % smoothing for heaviside
    p.KK=100;
    p.N=3;
    %
    case 2
    %internal paramters for SM model
    mname='SM';
    p.alpha1=1.673915e1;
    p.alpha2=9.523810e0;
    p.alpha3=1.0e-1;
    p.beta1=5.118377e0;
    p.beta2=6.258680e0;
    p.beta3=2.639456e0;
    p.beta4=3.628118e-1;
    p.beta5=5.833333e-2;
    p.gamma1=1.85125e0;
    p.gamma2=1.125e-2;
    p.gamma3=2.5e-1;
    p.c=4.0e-1;
    p.kth=4.444444e-2;
    p.Fmu=0.0;
    p.N=3;
    %
    case 3
    % de Saedeleer et al VDP
    mname='VDP';
    p.alpha=11.11;
    p.beta=0.25;
    % scaling of unforced period
    p.tt=35.09;
    p.N=2;
    %
    case 4
    % VDVP
    mname='VDPD';
    p.alpha=2;
    p.beta=0.7;
    p.delta=1.0;
    % scaling of unforced period
    p.tt=13.0;
    p.N=2;
    %
    case 5
    % TG03
    mname='TG';
    p.KK=100;        % smoothing heaviside
    p.Tf=270.15;     %T_f (-3degC end value in TG03)
    p.qr=0.7;        %q_r
    p.epsq=0.622;    % epsilon_q
    p.A=2.53E11;     % A [Pa]
    p.B=5.42E3;      % B [K]
    p.LEW=4.E3;      % L^{E-W} [km]
    p.lambda=0.01;    % lambda [km]
    p.P0=1.89216E6;     % P_0 [km^3/kyr]
    p.P1=1.26144E9;      % P_1 [km^3/kyr/Pa]
    p.aocn=20.E6;   % a_{ocn} [km^2]
    p.Is0=0.3*p.aocn;% I_s0 [km^2]
    p.alnd=20.E6;   % a_{lnd} [km^2]
    p.S0=4.7304E6;     % S_0 [km^3/kyr]
    p.SM=2.52288E6;     % S_M [km^3/kyr] strength of forcing    
    p.ST=4.7304E4;   % S_T [km^3/kyr/K]
    p.Cocn=2.935470573313E12;% C_{ocn} [W kyr/K]
    p.eps=0.64;      % epsilon
    p.sigma=5.67E-02;% sigma [W km^-2 K^-4]
    p.Hs=350.E6;       % H_s [W km^-2]
    p.alphaS=0.65;   % alpha_S
    p.alphaL=0.7;    % alpha_L
    p.alphaC=0.27;   % alpha_C
    % scaling of unforced period
    p.tt=13.0;
    p.N=2;
    %
    case 6
    % Mitsui et al 2015 phase oscillator
    mname='PO2';
    p.alpha=1.0;
    p.beta=1.0006;
    p.gamma=1.0;
    p.delta=0.24;
    % scaling of unforced period
    p.tt=1.0;
    p.N=1;  
    %
    case 7
    % Lin and Young 2008 shear induced chaos
    mname='LY08';
    p.uf=100.0;
    p.sigma=3.0;
    p.lambda=0.2;
    % scaling of unforced period
    p.tt=1.0;
    p.N=2;
    otherwise
    sprintf('Model not known')
    keyboard
end  % switch-case

p.zeros=zeros(2*p.N+1,1);

end

%%

function insol_cf = get_integrated_insol(lat, threshold, tshift);
%  function [age, insol_n, insol_cf] = get_integrated_insol(threshold);
% 
% Returns the piecewise-polynomial coefficients of the cubic-spline
%   (not-a-knot) interpolant for normalized integrated summer insolation at
%   latitude 65 north with forward time (kyr, not ka)
%   For use in model integrations, hence forward time array.
%
% Input
%   threshold: insolation threshold, element of {0:25:600} W/m^2
%   default value for 65 North from Huybers, 2006:  threshold=275 W/m^2
%   tshift: initial time for synthetic time array (kyr)
%       allows for negative time for transients
%       or shift to later insolation values
%
% Use yy = ppval(insol_cf, tt) to return values insolation values at times
%   given by tt (kyr)
%   IMPORTANT:  times for the interpolant are in kyr (not kyr ago)
%
[age, insol] = readHuybersIntegrated(lat, threshold);
insol_n = normalize_array(insol);
%   synthetic time array (kyr) for interpolant
%       min(time) = tshift corresponds to insolation from 5 Mya
%       max(time) = 5000-tshift corresponds to insolation from present
time =  age(end) - age + tshift;       
%
insol_cf = spline(time, insol_n');
%
end  % function

%%
function [xx] = normalize_array(x)
% function [xx] = normalize_array(x)
%   Given matrix x; returns normalized columens of x

xs = size(x);
if ((xs(2) == 1) | (xs(1) == 1))
    xx = (x-mean(x))/std(x);
else
    nrow = xs(1);
    mu = repmat(mean(x),[nrow,1]);
    sigma = repmat(std(x),[nrow,1]);
    xx = (x-mu)./sigma;
end % if
end % function

%%
function [age, insol] = readHuybersIntegrated(lat, threshold)
% function [age, insol] = readHuybersInsolation(lat, threshold)
%    returns integrated 'summer' insolation at given latitude
%    integrates insolation for days in which insolation > threshold
%    ORIGINAL REFERENCE: 
%       Huybers, P. 2006. 
%       Early Pleistocene Glacial Cycles and the Integrated Summer Insolation Forcing. 
%       Science, v313, p508-511, 10.1126/science.1125249, 28 July 2006.
%   INPUT:
%    lat: latitude [-90:5:90] deg
%    threshold: min insolation [0:25:600] W/m^2
%   OUTPUT:
%    age (kyr)
%    insol (W/m^2):  one column per threshold
%
% last change (CDC) 13/6/2017: set path for local data files
%
fpath = './Data/IntegratedInsolation/';
if (lat < 0)
    fname = sprintf('%sJ_%iSouth.txt',fpath,abs(lat));
else
    fname = sprintf('%sJ_%iNorth.txt',fpath,lat);
end % if
%
nh = 25;        % number of thresholds (0:25:600 W/m^2)
%
fid = fopen(fname,'r');
for i=1:8
    comment = fgets(fid);
end % for
%
fmt = '%g';
temp = fscanf(fid,fmt,[nh+1,Inf]);     %Scan the data into a 4xInf array
fclose(fid);
%
% Index arrays
% thresh = temp(2:end,1);
age = temp(1, 2:end)';
%
j = threshold/25;
insol = temp(j, 2:end)';
%
end % function


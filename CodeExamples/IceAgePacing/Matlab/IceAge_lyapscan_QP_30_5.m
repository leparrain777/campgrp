function IceAge_lyapscan_QP_30_5
%%
%% Computes scan of lyapunov exponents QP forcing of various Ice Age models
%% last change 28/5/2017 (PA)

rand('twister',199)

% plotfigs=true to plot timeseries
plotfigs=false;
%plotfigs=true;

% model options are
%   1=Palliard Perrenin 2004
%   2=Saltzmann Maasch 1991
%   3=van der Pol as in de Saedleleer et al 2013
%   4=van der Pol - Duffing
%   PO=phase oscillator
% PP04
%p=loadModel(1);
% SM91
p=loadModel(2);
% vdP
%p=loadModel(3);
% vdPD
%p=loadModel(4);

% forcing paramters: obliquity
p.omega1=2*pi/41.0;
p.omega2=2*pi/23.0;

% detuning
p.tau=1.0;

p.kt1=1.0;
% scan range for x
xm=0.0;
xp=1.0;

p.kt2=1.0;
% scan range for y
ym=0.0;
yp=1.0;

%resolution for scan
xsteps=5;
ysteps=5;

%integration transient and steps
ttrans=16;
tsteps=256;

xs=(0:xsteps-1)*(xp-xm)/(xsteps-1)+xm;
ys=(0:ysteps-1)*(yp-ym)/(ysteps-1)+ym;

% most positive lyap exponent
ly=zeros(xsteps,ysteps);

for ii=1:xsteps
    p.kt1=xs(ii);
    for jj=1:ysteps
        p.kt2=ys(jj);
        [lp]=calc_lyap(tsteps,ttrans,p,plotfigs);
        ly(jj,ii)=lp;
    end
    sprintf('%d percent completed',(floor(ii/xsteps*100)))
end

figure(2);
clf;

imagesc(xs,ys,ly,[-0.015,0.015]);

axis xy;
xlabel('k_1');
ylabel('k_2');
ttext=sprintf('%s LEs QP KK tsteps=%d ttrans=%d (xs,ys)=(%d,%d)',p.name,tsteps,ttrans,xsteps,ysteps);
title(ttext);
colorbar

ftt=sprintf('%s_QP_KK_ts_%d__tt_%d_xs_%d__ys_%d',p.name,tsteps,ttrans,xsteps,ysteps);

print('-dpdf',ftt);
savefig(ftt);

keyboard;

return

%%
function [lyap]=calc_lyap(tsteps,ttrans,p,plotfigs)

% use timestep that is integer fraction of forcing period
dt=2*pi*(4*p.omega1);

% arbitrary initial condition
yinit=zeros(2*p.N+1,1);
yinit(1)=0.5;
yinit(p.N+1)=1.0;

t=(1-ttrans)*dt;

%% integration code starts here
tmax=tsteps*dt;

%% run transient first
y0=yinit;
for i=1:ttrans-1
    y1=timestep(y0,p,dt,t);
    y0=y1;
    t=t+dt;
end

% uncomment to record trajectory
yy=zeros(2*p.N+1,tsteps);
yy(:,1)=y0;
% t should be zero here
tt(1)=t;

lystart=y0(2*p.N+1);
% now compute LE
for i=1:tsteps-1
    y1=timestep(y0,p,dt,t);
    t=t+dt;
    yy(:,i+1)=y1;
    tt(i+1)=t;
    y0=y1;
    lyend=y0(2*p.N+1);
end
lyap=(lyend-lystart)/tmax;

if plotfigs==true
    figure(1);
    subplot(3,1,1);
    %first compt
    if p.N==3
        plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b',tt(:),yy(3,:),'k');
    else
        plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b');
    end
    
    subplot(3,1,2);
    %lyap convergent
    plot(tt(:),yy(2*p.N+1,:));
    
    %lyap convergent
    subplot(3,1,3);
    plot(tt(20:end),yy(2*p.N+1,20:end)./(tt(20:end)+1));
    drawnow();
    %    keyboard;
end


return

%% figures!

%%
function y = timestep(y0,p,h,t)
% integrate forward one timestep, length h, from t
% ode15s is stiff integrator, ode45 is not

tspan = [t t+h];
%solstep = ode15s(@(t,y) fn_lyaps(y,p,t), tspan, y0);
solstep = ode45(@(t,y) fn_lyaps(y,p,t), tspan, y0);
y=deval(solstep,t+h);

return

%%
function fn = fn_lyaps(y,p,t)

fn=p.zeros;
%zeros(2*p.N+1,1);

% astro forcing same for all models
F=p.kt1*sin(t*p.omega1)+p.kt2*sin(t*p.omega2);

if p.model==1
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
    ll=y(7);
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
    
elseif p.model==2
    % Saltzmann Maasch 1991
    xx=y(1);
    yy=y(2);
    zz=y(3);
    % le direction
    lx=y(4);
    ly=y(5);
    lz=y(6);
    % log le amplitude
    ll=y(7);
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
    
elseif p.model==3
    % de Saedeleer, Crucifix, Wieczorek (4a,b) modified considerably
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % log le amplitude
    ll=y(5);
    % nonlinear ODE
    % extra delta term, xx term in fy changed sign
    fx=-(yy+p.beta-F);
    fy=-p.alpha*(yy*(yy*yy/3-1)-xx);
    % variational ODE
    % from Jacobian
    fxl=-ly;
    fyl=(lx-ly*(yy*yy-1))*p.alpha;
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
    
elseif p.model==4
    % de Saedeleer, Crucifix, Wieczorek (4a,b) modified to be vdP-Duffing
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % log le amplitude
    ll=y(5);
    % nonlinear ODE
    % extra delta term, xx term in fy changed sign
    fx=-(yy+p.beta-F);
    fy=-p.alpha*(yy*(yy*yy/3-1)-xx*(-1+p.delta*xx*xx));
    % variational ODE
    % from Jacobian
    fxl=-ly;
    fyl=(lx*(-1+3*p.delta*xx*xx)-ly*(yy*yy-1))*p.alpha;
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
else
    sprintf('model unknown')
    keyboard
end

%scaling of model time by tau
ts=1/p.tau;

fn=fn*ts;

end

%%

function p=loadModel(mname)

p.model=mname;

if p.model==1
    %internal paramters for PP model
    p.name='PP';
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
elseif p.model==2
    %internal paramters for SM model
    p.name='SM';
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
elseif p.model==3
    % de Saedeleer et al VDP
    p.name='VDP';
    p.alpha=11.11;
    p.beta=0.25;
    % scaling of unforced period
    p.tt=35.09;
    p.N=2;
elseif p.model==4
    % VDVP
    p.name='VDPD';
    p.alpha=2;
    p.beta=0.7;
    p.delta=1.0;
    % scaling of unforced period
    p.tt=13.0;
    p.N=2;
else
    sprintf('Model not known')
    keyboard
end

p.zeros=zeros(2*p.N+1,1);

end
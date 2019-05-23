function SM91_lyapscan_P_15_5
%%
%% Computes scan of lyapunov exponents for Salzmann Maasch 91 system
%% last change 2/5/2017 (PA)

rand('twister',199)

% plotfigs=true to plot timeseries
plotfigs=false;

%internal paramters for model
p.alpha1=1.673915e1;
p.alpha2=9.523810e0;
p.alpha3=1.0e-1;
p.beta1=5.118377e0;
p.beta2=6.258680e0;
p.beta3=2.639456e-2;
p.beta4=3.628118e-5;
p.beta5=5.833333e0;
p.gamma1=1.85125e0;
p.gamma2=1.125e-2;
p.gamma3=2.5e-1;
p.c=4.0e-3;
p.kth=4.444444e-2;
p.Fmu=0.0;
% forcing paramters: obliquity only
p.omega=2*pi/41.0;

%p.alpha=11.11;
%taup=140.0*35.09/100;
taum=0.5;
taup=1.5;

%scan parameter p.kt min and max
ktm=0.0;
ktp=0.5;

%resolution for scan
xsteps=120;
ysteps=120;

%integration transient and steps
ttrans=16;
tsteps=128;

taus=(0:xsteps-1)*(taup-taum)/(xsteps-1)+taum;
kts=(0:ysteps-1)*(ktp-ktm)/(ysteps-1)+ktm;
% tulc for beta=
%tulcs=taus*100/35.09;
% most positive lyap exponent
ly=zeros(xsteps,ysteps);

for ii=1:xsteps
    p.tau=taus(ii);
    for jj=1:ysteps
        p.kt=kts(jj);
        [lp]=calc_lyap(tsteps,ttrans,p,plotfigs);
        ly(jj,ii)=lp;
    end
    sprintf('%d percent completed',(floor(ii/xsteps*100)))
end

figure(2);
clf;

imagesc(taus,kts,ly,[-0.02,0.02]);
%imagesc(tulcs,gammas,ly,[-0.05,0.05]);
axis xy;
xlabel('\tau');
%xlabel('T_{ULC}');
ylabel('kt');
ttext=sprintf('SM91 LEs P tsteps=%d ttrans=%d (xs,ys)=(%d,%d)',tsteps,ttrans,xsteps,ysteps);
title(ttext);
colorbar

ftt=sprintf('SM91_P_ts_%d__tt_%d_xs_%d__ys_%d.eps',tsteps,ttrans,xsteps,ysteps);

print('-depsc2',ftt);

%save(ftt);

keyboard;

return

%%
function [lyap]=calc_lyap(tsteps,ttrans,p,plotfigs)

% use integer fractions of forcing period
dt=2*pi*(4*p.omega);

yinit=[0.5,0.0,0.0,1.0,0.0,0.0,0.0];
t=(1-ttrans)*dt;

%% integration code starts here
tmax=tsteps*dt;

%% transient first
y0=yinit;
for i=1:ttrans-1;
    y1=timestep(y0,p,dt,t);
    y0=y1;
    t=t+dt;
end

% uncomment to record trajectory
yy=zeros(7,tsteps);
yy(:,1)=y0;
% t should be zero here
tt(1)=t;

lystart=y0(7);
for i=1:tsteps-1;
    y1=timestep(y0,p,dt,t);
    t=t+dt;
    yy(:,i+1)=y1;
    tt(i+1)=t;
    y0=y1;
    lyend=y0(7);
end

lyap=(lyend-lystart)/tmax;


if plotfigs==true
    figure(1);
    subplot(3,1,1);
    %first compt
    plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b',tt(:),yy(3,:),'k');
    
    subplot(3,1,2);
    %lyap convergent
    plot(tt(:),yy(7,:));
    
    %lyap convergent
    subplot(3,1,3);
    plot(tt(20:end),yy(7,20:end)./(tt(20:end)+1));
    drawnow();
%    keyboard;
end


return

%% figures!




%%
function y = timestep(y0,p,h,t)
% integrate forward one timestep, length h, from t
% ode15s is stiff integrator ode45 is not

tspan = [t t+h];
%solstep = ode15s(@(t,y) fn_lyaps(y,p,t), tspan, y0);
solstep = ode45(@(t,y) fn_lyaps(y,p,t), tspan, y0);
y=deval(solstep,t+h);

return

%%
function fn=fn_lyaps(y,p,t)

%global p

fn=[0;0;0;0;0;0;0];

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

% SM91 modified considerably
% forcing
F=sin(t*p.omega);%+p.gamma2*sin(t*p.omega2);
%
fx=p.alpha1-p.alpha2*p.c*yy-p.alpha3*xx-p.kth*p.alpha2*zz-p.kt*p.alpha2*F;
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

ts=1/p.tau;

% (3,4) gives direction, (5) gives log size
fn(1)=fx*ts;
fn(2)=fy*ts;
fn(3)=fz*ts;
fn(4)=(fxl-lambda*lx)*ts;
fn(5)=(fyl-lambda*ly)*ts;
fn(6)=(fzl-lambda*lz)*ts;
fn(7)=lambda*ts;


return

%%
function dSCW_lyapscan_2_5
%%
%% Computes scan of lyapunov exponents for de Saedeleer, Crucifix, Wieczorek system
%% last change 2/5/2017 (PA)

global plotfigs p

rand('twister',199)

% plotfigs=true to plot timeseries
plotfigs=false;

%internal paramters for model
%p.alpha=11.11;
p.alpha=2;
p.beta=0.7;
%extra cubic term: p.delta=0 in SCW
p.delta=1.0;
% scan param p.tau min and max
%taum=35.0*35.00/100;
%taup=140.0*35.09/100;
taum=7.0;
taup=15.0;

% forcing paramters
p.omega=2*pi/41;
%scan parameter p.gamma min and max
gammam=0.0;
gammap=0.6;

%resolution for scan
xsteps=200;
ysteps=200;

%integration transient and steps
ttrans=16;
tsteps=64;

taus=(0:xsteps-1)*(taup-taum)/(ysteps-1)+taum;
gammas=(0:ysteps-1)*(gammap-gammam)/(xsteps-1)+gammam;
% tulc for beta=
%tulcs=taus*100/35.09;
% most positive lyap exponent
ly=zeros(xsteps,ysteps);

for ii=1:xsteps
    p.tau=taus(ii);
    for jj=1:ysteps
        p.gamma=gammas(jj);
        [lp]=calc_lyap(tsteps,ttrans,p);
        ly(jj,ii)=lp;
    end
    sprintf('%d percent completed',(floor(ii/xsteps*100)))
end

figure(2);
clf;

imagesc(taus,gammas,ly,[-0.02,0.02]);
%imagesc(tulcs,gammas,ly,[-0.05,0.05]);
axis xy;
xlabel('\tau');
%xlabel('T_{ULC}');
ylabel('\gamma');
ttext=sprintf('LEs, tsteps=%d ttrans=%d (xs,ys)=(%d,%d) alpha=%g beta=%g delta=%g',tsteps,ttrans,xsteps,ysteps,p.alpha,p.beta,p.delta);
title(ttext);
colorbar

ftt=sprintf('dSCWLEs_ts_%d__tt_%d_xs_%d__ys_%d_al_%g_be_%g_de_g',tsteps,ttrans,xsteps,ysteps,p.alpha,p.beta,p.delta);

print('-depsc2',ftt);

%save(ftt);

keyboard;

return

%%
function [lyap]=calc_lyap(tsteps,ttrans,p)

global plotfigs;

% use integer fractions of forcing period
dt=2*pi*(4*p.omega);

yinit=[0.5,1.0,1.0,0.0,0.0];
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
yy=zeros(5,tsteps);
yy(:,1)=y0;
% t should be zero here
tt(1)=t;

lystart=y0(5);
for i=1:tsteps-1;
    y1=timestep(y0,p,dt,t);
    t=t+dt;
    yy(:,i+1)=y1;
    tt(i+1)=t;
    y0=y1;
    lyend=y0(5);
end

lyap=(lyend-lystart)/tmax;


if plotfigs==true
    figure(1);
    subplot(3,1,1);
    %first compt
    plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b');
    
    subplot(3,1,2);
    %lyap convergent
    plot(tt(:),yy(5,:));
    
    %lyap convergent
    subplot(3,1,3);
    plot(tt(20:end),yy(5,20:end)./(tt(200:end)+1));
    keyboard;
end


return

%% figures!




%%
function y = timestep(y0,p,h,t)
% integrate forward one timestep, length h, from t
% ode15s is stiff integrator

tspan = [t t+h];
solstep = ode15s(@(t,y) fn_lyaps(y,p,t), tspan, y0);
y=deval(solstep,t+h);

return

%%
function fn =fn_lyaps(y,p,t)

%global p

fn=[0;0;0;0;0];

% nonlinear vars
xx=y(1);
yy=y(2);
% le direction
lx=y(3);
ly=y(4);
% log le amplitude
ll=y(5);

% de Saedeleer, Crucifix, Wieczorek (4a,b)
F=sin(t*p.omega);
temp=1/p.tau;
% nonlinear ODE
% extra delta term, xx term in fy changed sign
fx=-(yy+p.beta-p.gamma*F)*temp;
fy=-p.alpha*(yy*(yy*yy/3-1)-xx*(-1+p.delta*xx*xx))*temp;        
% variational ODE
% from Jacobian
fxl=-ly*temp;
fyl=(lx*(-1+3*p.delta*xx*xx)-ly*(yy*yy-1))*p.alpha*temp;
% project out zero expansion direction
lam=fxl*lx+fyl*ly;
lamn=lx*lx+ly*ly;
% growth rate
lambda=lam/lamn;

% (3,4) gives direction, (5) gives log size
fn(1)=fx;
fn(2)=fy;
fn(3)=fxl-lambda*lx;
fn(4)=fyl-lambda*ly;
fn(5)=lambda;


return

%%
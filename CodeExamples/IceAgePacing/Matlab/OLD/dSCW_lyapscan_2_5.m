function dSCW_lyapscan_2_5
%%
%% Computes scan of lyapunov exponents for de Saedeleer, Crucifix, Wieczorek system
%% last change 2/5/2017 (PA)

global plotfigs p

rand('twister',199)

% plotfigs=true to plot timeseries
plotfigs=false;

%internal paramters for model
p.alpha=11.11;
p.beta=0.25;
% scan param p.tau min and max
taum=35.0*35.00/100;
taup=140.0*35.09/100;

% forcing paramters
p.omega=2*pi/41;
%scan parameter p.gamma min and max
gammam=0.0;
gammap=8.0;

%resolution for scan
xsteps=40;
ysteps=40;

%integration transient and steps
ttrans=16;
tsteps=200;



taus=(0:xsteps-1)*(taup-taum)/(ysteps-1)+taum;
gammas=(0:ysteps-1)*(gammap-gammam)/(xsteps-1)+gammam;
% tulc for beta=
tulcs=taus*100/35.09;
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

%imagesc(taus,gammas,ly,[-0.05,0.05]);
imagesc(tulcs,gammas,ly,[-0.05,0.05]);
axis xy;
%xlabel('\tau');
xlabel('T_{ULC}');
ylabel('\gamma');
ttext=sprintf('scan of lyap exponents, tsteps=%d ttrans=%d (xs,ys)=(%d,%d)',tsteps,ttrans,xsteps,ysteps);
title(ttext);
colorbar

ftt=sprintf('dSCW_lyapscan_ts_%d__tt_%d_xs_%d__ys_%d',tsteps,ttrans,xsteps,ysteps);

print('-depsc2',ftt);

%save(ftt);

keyboard;

return

%%
function [lyap]=calc_lyap(tsteps,ttrans,p)

global plotfigs;

% use integer fractions of forcing period
dt=2*pi*(8*p.omega);

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

% CHECK RK formula!

tspan = [t t+h];
solstep = ode15s(@(t,y) fn_lyaps(y,p,t), tspan, y0);
y=deval(solstep,t+h);

% k1=h*fn_lyaps(y,p,t);
% k2=h*fn_lyaps(y+k1/2,p,t+h/2);
% k3=h*fn_lyaps(y+k2/2,p,t+h/2);
% k4=h*fn_lyaps(y+k3,p,t+h);
% ydet=y+(k1+2*k2+2*k3+k4)/6;
% 
% y=ydet;

return

%%
function fn =fn_lyaps(y,p,t)

%global p

fn=zeros(5,1);

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
Phip=yy*(yy*yy/3-1);
dPhip=yy*yy-1;
temp=1/p.tau;
% nonlinear ODE
fx=-(yy+p.beta-p.gamma*F)*temp;
fy=-p.alpha*(Phip-xx)*temp;        
% variational ODE
fxl=-ly*temp;
fyl=(lx-ly*dPhip)*p.alpha*temp;
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
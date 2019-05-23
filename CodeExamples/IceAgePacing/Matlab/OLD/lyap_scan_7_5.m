function lyap_scan_27_4
%%
%% computes lyapunov exponents for coupled osc system of Timme, Bick et al
%% last change 27/4/2010 (PA)

global e1 e2 nodes

nodes=5;

rand('twister',199)

tsteps=1000;
ttrans=1000;
dt=0.1;
xsteps=20;
ysteps=20;

xs=zeros(1,xsteps);
ys=zeros(1,ysteps);
% most positive lyap exponent
ly=zeros(xsteps,ysteps);
% closes approach to boundary of c.i.r.
by=ones(xsteps,ysteps);

for ii=1:xsteps
    e1=(ii-1)*(0.15-0.0)/(xsteps-1)+0.0;
    xs(ii)=e1;
    for jj=1:ysteps
        e2=(jj-1)*(0.1-(-0.1))/(ysteps-1)+(-0.1);
        ys(jj)=e2;
        [lp,bp]=calc_lyap(tsteps,ttrans,dt);
        ly(jj,ii)=lp;
        by(jj,ii)=bp;
    end
    sprintf('%d percent completed',(floor(ii/xsteps*100)))
end

figure(1);
clf;
imagesc(xs,ys,ly,[-0.3,0.3]);
axis xy;
xlabel('\eta_1');
ylabel('\eta_2');
ttext=sprintf('scan of lyap exponents, tsteps=%d ttrans=%d dt=%g res=(%d,%d) nodes=%d',tsteps,ttrans,dt,xsteps,ysteps,nodes);
title(ttext);
colorbar

figure(2);
clf;
imagesc(xs,ys,by);
axis xy;
xlabel('\eta_1');
ylabel('\eta_2');
ttext=sprintf('scan of closest approach to bdy, tsteps=%d ttrans=%d dt=%g res=(%d,%d) nodes=%d',tsteps,ttrans,dt,xsteps,ysteps,nodes);
title(ttext);
colorbar


ftt=sprintf('lyap_scan_7_5_%d_%d_%d_%d_%d',tsteps,ttrans,xsteps,ysteps,nodes);

print('-depsc2',ftt);

save(ftt);

keyboard;

return

%%
function [lyap,clo]=calc_lyap(tsteps,ttrans,dt)

global nodes c1 c2 c3 c4

% c1,c2,c3,c4,e1,e2 from Bick paper
c1=-0.5;
c2=-0.5;
c3=-0.25;
c4=-0.22;
% bif params
%e1=0.1104;
%e2=0.051558;

% initial phase diffs, variations and (last compt) log lyap exp.
%yinit=[1.0,2.0,3.0,0.414,0.414,0.0,0.0];
%yinit=[0.5,1.0,2.0,2.5,3.0,4.0,5.0,0.414,0.414,0.0,0.0,0.0,0.0,0.0,0.0];
yinit=zeros(1,2*nodes-1);
yinit(nodes)=0.414;
yinit(nodes+1)=0.414;
for ii=1:nodes-1
    yinit(ii)=3.0*ii/(nodes-1);
end

%yinit=[0.5,1.0,1.5,2.0,2.5,3.0,4.0,5.0,0.414,0.414,0.0,0.0,0.0,0.0,0.0,0.0,0.0];

t=0.0;

        
%% code starts here
tmax=tsteps*dt;

%% transient first
y0=yinit;
for i=1:ttrans-1;
    y1=timestep(y0,dt);
    y0=y1;
end

clo=6;
for i=1:nodes-2;
    clo=min(clo,rem(abs(y0(i+1)-y0(i)),2*pi));
end

% uncomment to record trajectory
%yy=zeros(2*nodes-1,tsteps);
%yy(:,1)=y0;

lystart=y0(2*nodes-1);
for i=1:tsteps-1;
    y1=timestep(y0,dt);
    t=t+dt;
    %yy(:,i+1)=y1;
    %tt(i+1)=t;
    y0=y1;
    lyend=y0(2*nodes-1);
    for k=1:nodes-2;
        clo=min(clo,rem(abs(y0(k+1)-y0(k)),2*pi));
    end
end

lyap=(lyend-lystart)/tmax;
return

%% figures!

%figure(1);
%
%subplot(2,1,1)
% first compt
%plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b');
%
%subplot(2,1,2)
% lyap convergent
%plot(tt(:),yy(2*nodes-1,:));

% lyap convergent
%plot(tt(1000:5000),yy(2*nodes-1,1000:5000)./(tt(1000:5000)+1));



%%
function y = timestep(y,h)
% integrate forward one timestep, length h

global c1 c2 c3 c4 e1 e2 nodes

k1=h*fn_lyaps(y,c1,c2,c3,c4,e1,e2,nodes);
k2=h*fn_lyaps(y+k1/2,c1,c2,c3,c4,e1,e2,nodes);
k3=h*fn_lyaps(y+k2/2,c1,c2,c3,c4,e1,e2,nodes);
k4=h*fn_lyaps(y+k3,c1,c2,c3,c4,e1,e2,nodes);
ydet=y+(k1+2*k2+2*k3+k4)/6;

y=ydet;

return

% generate noise
% xn=rand(2,nodes);
% for n=1:ensembles
%     for ii=1:nodes
%         ynoise(1,ii,n)=eta(n)*sqrt(h)*(sqrt(-2*log(xn(1,ii))).*cos(2*pi*xn(2,ii)));
%     end
% end
%
% combined noise and signal
%y=ydet+ynoise+input;


%% code from xppaut prog
% dp0=om+(    g(p0-p1)+g(p0-p2)+g(p0-p3))
% dp1=om+(g(p1-p0)+    g(p1-p2)+g(p1-p3))
% dp2=om+(g(p2-p0)+g(p2-p1)+    g(p2-p3))
% dp3=om+(g(p3-p0)+g(p3-p1)+g(p3-p2)    )
% 
% dvp0=(dgdx(p0-p1)*(vp0-vp1)+dgdx(p0-p2)*(vp0-vp2)+dgdx(p0-p3)*(vp0-vp3))
% dvp1=(dgdx(p1-p0)*(vp1-vp0)+dgdx(p1-p2)*(vp1-vp2)+dgdx(p1-p3)*(vp1-vp3))
% dvp2=(dgdx(p2-p0)*(vp2-vp0)+dgdx(p2-p1)*(vp2-vp1)+dgdx(p2-p3)*(vp2-vp3))
% dvp3=(dgdx(p3-p0)*(vp3-vp0)+dgdx(p3-p1)*(vp3-vp1)+dgdx(p3-p2)*(vp3-vp2))
% 
% # phase diffs
% t0'=dp0-dp3+eta*w[0]
% t1'=dp1-dp3+eta*w[1]
% t2'=dp2-dp3+eta*w[2]
% 
% # variational diffs
% dvt0=dvp0-dvp3
% dvt1=dvp1-dvp3
% dvt2=dvp2-dvp3
% lambda= (dvt0*vt0+dvt1*vt1+dvt2*vt2)/(vt0*vt0+vt1*vt1+vt2*vt2)
% 
% #variational in norm
% vt0'=dvt0-lambda*vt0
% vt1'=dvt1-lambda*vt1
% vt2'=dvt2-lambda*vt2
% 
% lnv'=lambda
% 

%%

function fn =fn_lyaps(y,c1,c2,c3,c4,e1,e2,nodes)

fn =zeros(1,2*nodes-1);

% include final coords
yy=y(1:nodes-1);
yy(nodes)=0;

yv=y(nodes:2*nodes-2);
yv(nodes)=0;

dp=zeros(1,nodes);
ddp=zeros(1,nodes);

for ii=1:nodes
    for jj=1:nodes
        xx=yy(ii)-yy(jj);
        dp(ii)=dp(ii)+c1*cos(xx+e1)+c2*cos(2*xx-e1)+c3*cos(3*xx+e1+e2)+c4*cos(4*xx+e1+e2);
        dg=-c1*sin(xx+e1)-2*c2*sin(2*xx-e1)-3*c3*sin(3*xx+e1+e2)-4*c4*sin(4*xx+e1+e2);
        ddp(ii)=ddp(ii)+dg*(yv(ii)-yv(jj));
    end
end

% project
lamb=0.0;
lambn=0.0;
dv=zeros(1,nodes-1);
ddv=zeros(1,nodes-1);

for ii=1:nodes-1
    dv(ii)=dp(ii)-dp(nodes);
    ddv(ii)=ddp(ii)-ddp(nodes);
    lamb=lamb+ddv(ii)*yv(ii);
    lambn=lambn+yv(ii)*yv(ii);
end

lambda=lamb/lambn;

% copy back into rates of change;
for ii=1:nodes-1
    fn(ii)=dv(ii);
    fn(ii+nodes-1)=ddv(ii)-lambda*yv(ii);
    fn(2*nodes-1)=lambda;
end

return

%%
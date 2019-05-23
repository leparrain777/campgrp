% fixed parameters from PP04
x=1.3;
y=0.5;
z=0.8;
alpha=0.15;
beta=0.5;
gamma=0.5;
delta=0.4;
a=0.3;
b=0.7;
c=0.01;
d=0.27;
%
fignum=0;
%
% Bifurcation for PP04 drift in d (trigger)
k = -8.5*10^(-5);
maxt = 5000;            % kyr
mind = d+k*maxt;
dd = [-0.5:0.01:0.4];
%
% equilibria ice volume for each sub-model
term1 = (1-x*beta);
vg = (z-x*delta)/term1+dd*0.0; % glacial state
vi = (z-x*(delta+gamma))/term1+dd*0.0; %interglacial state
%
% switching state & bifurcation points
vs = dd/(b-a);
ds1 = (b-a)*(z-x*delta)/term1;
ds2 = (b-a)*(z-x*(delta+gamma))/term1;
%
% plot full equilibrium curves
fignum=fignum+1;
figure(fignum);
clf;
plot(dd,vg,'b',dd,vi,'r','LineWidth',2.0);
hold on;
plot(dd,vs,'k--');
plot(dd*0.0+ds1,vs*10,'k--','LineWidth',0.5);
plot(dd*0.0+ds2,vs*10,'k--','LineWidth',0.5);
hold off;
ylim([-2 4]);
xlabel('d');
ylabel('V^*');
%
% plot bifurcation diagram
ind1 = find(dd>=ds2);
ind2 = find(dd<=ds1);
vg1 = vg(ind1);
vi2 = vi(ind2);
i1 = max(ind2);
i2 = min(ind1);
%
fignum=fignum+1;
figure(fignum);
clf;
plot(dd(ind1),vg1,'b',dd(ind2),max(0,vi2),'r--',dd(ind2),vi2,'r','LineWidth',2.0);
hold on;
plot(dd,vs,'k--');
plot(dd*0.0+ds1,vi*10,'k--','LineWidth',0.5);
plot(dd*0.0+ds2,vi*10,'k--','LineWidth',0.5);
hold off
ylim([-2 4]);
xlabel('d');
ylabel('V^*');
%
% Bifurcation for C12 drift in delta (CO2)
% range of delta drift (C12)
ddel = [-0.2:0.01:0.6];
%
% equilibria ice volume for each sub-model
term1 = (1-x*beta);
vg = (z-x*ddel)/term1; % glacial state
vi = (z-x*(ddel+gamma))/term1; %interglacial state
%
% switching state & bifurcation points
vs = d/(b-a)+ddel*0.0;
dels1 = (z - d*term1/(b-a))/x;
dels2 = dels1-gamma;
%
% plot full equilibrium curves
fignum=fignum+1;
figure(fignum);
clf;
plot(ddel,vg,'b',ddel,vi,'r','LineWidth',2.0);
hold on;
plot(ddel,vs,'k--');
plot(ddel*0.0+dels1,vi*10,'k--','LineWidth',0.5);
plot(ddel*0.0+dels2,vi*10,'k--','LineWidth',0.5);
hold off;
ylim([-2 4]);
xlabel('\delta');
ylabel('V^*');
%
% plot bifurcation diagram
ind1 = find(ddel>=dels2);
ind2 = find(ddel<=dels1);
vg1 = vg(ind1);
vi2 = vi(ind2);
i1 = max(ind2);
i2 = min(ind1);
%
fignum=fignum+1;
figure(fignum);
clf;
plot(ddel(ind1),vg1,'b',ddel(ind2),max(0,vi2),'r--',ddel(ind2),vi2,'r','LineWidth',2.0);
hold on;
plot(ddel,vs,'k--');
plot(ddel*0.0+dels1,vi*10,'k--','LineWidth',0.5);
plot(ddel*0.0+dels2,vi*10,'k--','LineWidth',0.5);
hold off
ylim([-2 4]);
xlabel('\delta');
ylabel('V^*');



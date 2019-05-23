
%
% get model parameters
pp04ns_param;
%
% set forcing functions
threshold = 350;
tshift = 0;
%   65 N
lat = 65;
p.i65n_cf = get_integrated_insol(lat, threshold, tshift);
%   60 S
lat = -60;
p.i60s_cf = get_integrated_insol(lat, threshold, tshift);
%
% sweep values of p.d
dmin = -0.10;
dmax = 0.4;
nd = 201;
dd = linspace(dmin,dmax,nd);
%
period=NaN;
Vmax=NaN;
Vmin=NaN;
for id=1:nd
p.d = dd(id);
%
% initial model phase
[eff, switchmodel, dir] = efficiency(t0,yinit,p);
if (eff >= 0)
    warm = 0;
else
    warm = 1;
end %if
%
% set up switch & truncation for ode solver
odeoptions=odeset('Nonnegative',[1 2],'Events',@(t,y) efficiency(t,y,p));
%
tstart=t0;
ystart = yinit;
tt=t0;
te=t0;
yy=yinit;
ye=yinit;
while (tstart < tmax)
    tspan = [tstart tmax];
    if (warm)
        [tti yyi tei yei iei] = ode45(@(t,y) pp04warming(t,y,p), tspan, ystart, odeoptions);
        %[tti yyi tei yei iei] = ode15s(@(t,y) pp04warming(t,y,p), tspan, ystart, odeoptions);
        tt = [tt; tti(2:end)];
        yy = [yy; yyi(2:end,:)];
        te = [te; tei];
        ye = [ye; yei];
        %disp([tti(1)/1000,tti(end)/1000,warm]);
        warm = 0;
        tstart = tti(end);
        ystart = yyi(end,:);
    else
        [tti yyi tei yei iei] = ode45(@(t,y) pp04cooling(t,y,p), tspan, ystart, odeoptions);
        %[tti yyi tei yei iei] = ode15s(@(t,y) pp04warming(t,y,p), tspan, ystart, odeoptions);
        tt = [tt; tti(2:end)];
        yy = [yy; yyi(2:end,:)];
        te = [te; tei];
        ye = [ye; yei];
        %disp([tti(1)/1000,tti(end)/1000,warm]);
        warm = 1;
        tstart = tti(end);
        ystart = yyi(end,:);
    end %if
end % while
if (length(te) > 4)
    period(id)=te(end-2) - te(end-4);
else
    period(id)=NaN;
end %if
disp([p.d, length(te)])
nt0 = findbin(t0+ttrans,tt,1);
Vmax(id)=max(yy(nt0:end,1));
Vmin(id)=min(yy(nt0:end,1));
end % for
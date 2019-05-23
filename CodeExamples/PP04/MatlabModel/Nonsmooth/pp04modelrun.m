%
% get model parameters
%pp04ns_param;
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
mstate = warm;
while (tstart < tmax)
    tspan = [tstart tmax];
    if (warm)
        [tti yyi tei yei iei] = ode45(@(t,y) pp04warming(t,y,p), tspan, ystart, odeoptions);
        tt = [tt; tti(2:end)];
        yy = [yy; yyi(2:end,:)];
        if (length(tei))
            te = [te; tei(end)];
            ye = [ye; yei(end,:)];
        end %if
        warm = 0;
        mstate = [mstate;warm];
        tstart = tti(end);
        ystart = yyi(end,:);
    else
        [tti yyi tei yei iei] = ode45(@(t,y) pp04cooling(t,y,p), tspan, ystart, odeoptions);
        tt = [tt; tti(2:end)];
        yy = [yy; yyi(2:end,:)];
        if (length(tei))
           te = [te; tei(end)];
           ye = [ye; yei(end,:)];
        end %if
        warm = 1;
        mstate = [mstate;warm];
        tstart = tti(end);
        ystart = yyi(end,:);
    end %if
end % while
    % add final point to event arrays
    te = [te; tti(end)];
    ye = [ye; yyi(end,:)];
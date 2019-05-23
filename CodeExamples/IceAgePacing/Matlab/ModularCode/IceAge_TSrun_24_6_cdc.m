%  Ice Age Time Series Run -- main script
%
tic;
%
%   load control, model and forcing parameters
loadParamTS;
%
%   solve ode
tspan=[0 tmax];
sol = ode45(@(t,y) fn_lyaps(t,y,p), tspan, yinit);
%
%   extract desired solution (sip transient)
tt = [ttrans:1:tmax];
yy = deval(sol,tt);
%
% calulate max lyap exp
y0 = deval(sol,ttrans);
ymax = deval(sol,tmax);
lystart = y0(end);
lyend = ymax(end);
lyap=(lyend-lystart)/(tmax-ttrans);
%
toc;
%
% Plot Figures
if (plotfigs)
    plotTSrun;
end;



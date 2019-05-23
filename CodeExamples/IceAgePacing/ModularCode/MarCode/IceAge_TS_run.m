
%  Ice Age Time Series Run -- main script
%
tic;
clear variables;
%   load control, model and forcing parameters
loadParamTS;
fprintf('Ice Age run %s\n',basefilename);
%
%   set up for ode solver
tspan=[tstart tmax];
tt = (ttrans:1:tmax)';   % post-transient time array
nt = length(tt);
ny = 2*p.N+1;           % number of state variables in odesolver
yy = zeros(ny, nt, nIC);% storage for solutions
lyap = zeros(1,nIC);  % storage for max. Lyapunov exponents

for irun = 1:nIC
    if (p.solver=='stiff')
        sol = ode15s(@(t,y) fn_lyaps(t,y,p), tspan, yinit(:,irun));
    else
        sol = ode45(@(t,y) fn_lyaps(t,y,p), tspan, yinit(:,irun));
    end
    %
    %   extract desired solution (skipping transient)
    yy(:,:,irun) = deval(sol,tt);
    %
    % calulate max lyap exp
    y0 = deval(sol,ttrans);
    ymax = deval(sol,tmax);
    lystart = y0(end);
    lyend = ymax(end);
    lyap(irun)=(lyend-lystart)/(tmax-ttrans);
    %
end  %for
%
% Plot Figures
if (plotfigs)
    plotTSrun;
end

%
toc;
%
% Save Data
if (savedata)
    saveTSrun;
end



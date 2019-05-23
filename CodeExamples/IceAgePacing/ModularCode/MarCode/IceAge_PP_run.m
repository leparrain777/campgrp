
%  Ice Age Phase Portrait Run -- main script
%
tic;
%   load control, model and forcing parameters
loadParamPP;
fprintf('Ice Age run %s\n',basefilename);
%
%   set up for ode solver
tspan=[0 tmax];
tt = [ttrans:1:tmax]';   % post-transient time array
nt = length(tt);
ny = 2*p.N+1;           % number of state varaibles in odesolver
yy = zeros(ny, nt, nIC);% storage for solutions
lyap = zeros(1,nIC);  % storage for max. Lyapunov exponents
for irun = 1:nIC
    sol = ode45(@(t,y) fn_lyaps(t,y,p), tspan, yinit(:,irun));
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
    plotPPrun;
%     switch (p.model)
%         case 1 %PP04
%             plot_PP_TS;
%         case 2 %SM91
%             plot_PP_TS;
%         otherwise % default plot routine
%             plotTSrun;
%     end %switch
end

%
toc;
%
% Save Data
%if (savedata)
%    savePPrun;
%end



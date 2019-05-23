%  Ice Age Time Series Run -- main script
%
tic;
%   load control, model and forcing parameters
loadParamTAU;
fprintf('Ice Age run %s',basefilename);
%
%   set up for ode solver
tspan=[0 tmax];
tt = (ttrans:1:tmax)';   % post-transient time array
nt = length(tt);
ny = 2*p.N+1;           % number of state variables in odesolver
lyap = zeros(nAmp,nTau);  % storage for max. Lyapunov exponents
wind = zeros(nAmp,nTau);  % storage for winding rate

arrTau = linspace(minTau, maxTau, nTau);   % Tau array
arrAmp = linspace(minAmp, maxAmp, nAmp);    % forcing amplitude array
arrKT1 = arrAmp.*ratioAmp;             % array for forcing ampltude kt1
arrKT2 = arrAmp.*(1-ratioAmp);             % array for forcing ampltude kt2
for jAmp = 1:nAmp
    p.kt1 = arrKT1(jAmp);
    p.kt2 = arrKT2(jAmp);
    fprintf('\nkt1,kt2= %g %g ',p.kt1,p.kt2)
    for iTau = 2:nTau
        p.tau = arrTau(iTau);
        sol = ode45(@(t,y) fn_lyaps(t,y,p), tspan, yinit);
        %
        % calulate max lyap exp
        y0 = deval(sol,ttrans);
        ymax = deval(sol,tmax);
        lystart = y0(end);
        lyend = ymax(end);
        lyap(jAmp,iTau)=(lyend-lystart)/(tmax-ttrans);
        %
                % calculate winding
        Nsteps=2000;
        ts=(ttrans:(tmax-ttrans)/Nsteps:tmax);
        y1 = deval(sol,ts);
        if (p.model==6)||(p.model==7)
            % primitive phase angle already
            zz = y1(1,:);
        else
            % extract phase with Hilbert transform
            z=hilbert(y1(1,:)-mean(y1(1,:)));
            zz=unwrap(angle(z));
        end
        wstart = zz(1);
        wend = zz(end);
        wind(jAmp,iTau)=(wend-wstart)/(tmax-ttrans);
        if plotts==true
            figure(99);
            if (p.model==6)||(p.model==7)
                plot(ts,sin(y1(1,:)));
                drawnow();
            else
                plot(ts,y1(1,:));
                drawnow();
            end
        end

    end %for
    fprintf('.. %g%% ',round(jAmp/nAmp*1000)/10);
end  %for
%
toc;
%
% Plot Figures
if (plotfigs)
   plotTAUrun;
end
%
% Save Data
if (savedata)
    saveTAUrun;
end



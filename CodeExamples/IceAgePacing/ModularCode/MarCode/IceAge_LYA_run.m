%  Ice Age Lyapunov Exponent Run -- main script
%
%  C.D.Camp - 25Jul17
%  P. Ashwin - 31Aug17
%
tic;
%   load control, model and forcing parameters
loadParamLYA;
fprintf('Ice Age run %s\n',basefilename);
%
%   set up for ode solver
tspan=[0 tmax];
ny = 2*p.N+1;           % number of state variables in odesolver
% one more to keep track of winding..
lyap = zeros(nk2,nk1);  % storage for max. Lyapunov exponents
wind = zeros(nk2,nk1);  % storage for winding rate

for jj=1:nk2
    p.kt2=k2(jj);
    if (p.forcing == 2)   % get interpolant coeff for insolation forcing
        p.insolcf = get_integrated_insol(insol_lat, p.kt2, ttrans);
    end
    for ii=1:nk1
        p.kt1=k1(ii);
        sol = ode45(@(t,y) fn_lyaps(t,y,p), tspan, yinit);
        if sol.x(end)~=tmax 
            sprintf('ODE45 failed');
            keyboard;
        end
        %figure(99);
        %plot(sol.y(1,:),sol.y(2,:));
        %keyboard;
        %
        % calculate max lyap exp
        y0 = deval(sol,ttrans);
        ymax = deval(sol,tmax);
        lystart = y0(end);
        lyend = ymax(end);
        lyap(jj,ii)=(lyend-lystart)/(tmax-ttrans);
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
        wind(jj,ii)=(wend-wstart)/(tmax-ttrans);
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
    end
    sprintf('%d percent completed',(floor(jj/nk2*100)))
end
%wen
% Plot Figures
if (plotfigs)
    plotLYArun;   
end
%
toc;
%
% Save Data
if (savedata)
    saveLYArun;
end


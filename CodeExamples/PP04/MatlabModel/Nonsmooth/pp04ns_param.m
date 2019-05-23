% load pp04_parameters
%
t0 = 3500;             % initial time
ttrans = 500;
tmax = 5000;        % final time
yinit = [.7 .542 0]; % IC
unforced = 1;       % set to 1 for unforced run
savefig = 0;        % set to 1 to save figures to file
%
%internal paramters for PP model (default values)
    mname='PPns';
    p.x=1.3;
    p.y=0.5/2;        % i65 forcing in reference Ice Volume (def 0.5)
    p.z=0.8;
    p.alpha=0.15/2;   % i65 forcing in reference CO2 (def 0.15)
    p.beta=0.5;
    p.gamma=0.5;
    p.delta=0.4;    % DC-shift in reference CO2
    p.a=0.3;
    p.b=0.7;        
    p.c=0.01;       % i60 forcing
    p.d=0.27;       % DC-shift in efficiency
    %
    % relaxation time scales
    p.tauV=15;
    p.tauA=12;
    p.tauC=5;
%
% adjusted parameters
if (unforced)
    p.y=0;
    p.c=0;
    p.alpha=0;
end %if
%
p.d=0.21;
    

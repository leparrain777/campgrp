function [p, mname]=loadModel(p)
%
% set internal parameters for each model
% default solver:
p.solver='nonstiff';
switch p.model
    case 1
    %internal paramters for PP model
    mname='PP';
    p.a=1.3;
    p.b=0.5;
    p.c=0.8;
    p.d=0.15;
    p.e=0.5;
    p.f=0.5;
    p.g=0.4;
    p.h=0.3;
    p.i=0.7;
    p.j=0.27;
    p.taui=15;
    p.taua=12;
    p.taumu=5;
    % smoothing for heaviside
    p.KK=100;
    p.N=3;
    p.vname={'V','A','\mu'};
    p.vrange1=[0,1];
    p.vrange2=[0,1];

    
    % time rescaling
    %
    case 2
    %internal paramters for SM model
    mname='SM';
    p.alpha1=1.673915e1;
    p.alpha2=9.523810e0;
    p.alpha3=1.0e-1;
    p.beta1=5.118377e0;
    p.beta2=6.258680e0;
    p.beta3=2.639456e0;
    p.beta4=3.628118e-1;
    p.beta5=5.833333e-2;
    p.gamma1=1.85125e0;
    p.gamma2=1.125e-2;
    p.gamma3=2.5e-1;
    p.c=4.0e-1;
    p.kth=4.444444e-2;
    p.KR=0.4;
    p.Fmu=0.0;
    p.N=3;
    p.vname={'I','\mu','\theta'};
    %p.vrange1=[-50,150];
    %p.vrange2=[-1,4];
    p.vrange1=[0,100];
    p.vrange2=[1,4];
    %
    case 3
    % de Saedeleer et al VDP
    mname='VDP';
    p.alpha=11.11;
    p.beta=0.25;
    % scaling of forcing amplitude
    p.gamma=0.75;
    % scaling of unforced period
    p.tt=35.09;
    p.N=2;
    p.vname={'x','y'};
    p.vrange1=[-2,2];
    p.vrange2=[-2.2,2.2];
    
%
    case 4
    % VDVP
%     mname='VDPD';
%     p.alpha=2;
%     p.beta=0.7;
%     p.delta=1.0;
%     % scaling of forcing amplitude
%     p.gamma=1.0;
%     % scaling of unforced period
%     p.tt=13.0;
%     p.N=2;
    mname='VDPDNEW';
    p.alpha=11.11;
    p.beta=0.25;
    % with Duffing term on (scaled so unforced approx 100kyr period)
    p.delta1=-1.;
    p.delta3=1.2;
    p.tt=52;
    % with Duffing term off
    %p.delta1=1;
    %p.delta3=0;
    %p.tt=35.09;
    % scaling of forcing amplitude
    p.gamma=0.75;
    p.N=2;
    p.vname={'x','y'};
    p.vrange1=[-2,2];
    p.vrange2=[-2.2,2.2];
    %
    case 5
    % TG03
    mname='TG03';
    p.KK=5.0;           % smoothing for heaviside
    p.Tf=270.;          %T_f (-3degC end value in TG03)
    p.qr=0.7;           %q_r
    p.epsq=0.622;       % epsilon_q
    p.A=2.53E11;        % A [Pa=kg/(ms^2)]
    p.B=5.42E3;         % B [K]
    p.PS=1E5;           % P_S [Pa]
    p.P0=0.06*31.536E6; % P_0 [km^3/kyr] original 0.06 Sv   
    p.P1=40.0*31.536E6; % P_1 [km^3/kyr/Pa] original 40.0 Sv/Pa
    p.S0=0.15*31.536E6 ;      % S_0 [km^3/kyr] (from Sv)
    p.SM=0.08*31.536E6;       % S_M [km^3/kyr] strength of forcing (from Sv)    
    p.ST=0.0015*31.536E6;     % S_T [km^3/kyr/K] (from Sv/K)
    p.eps=0.64;      % epsilon
    p.sigma=5.67E-02;% sigma [W km^-2 K^-4] original 5.67E-8 Wm^{-2}K^{-4} 
    p.Hs=350.E6;    % H_s [W km^-2] original 350.6 Wm^{-2}
    p.alphaS=0.65;   % alpha_S albedo of sea ice []
    p.alphaL=0.7;    % alpha_L albedo of land ice []
    p.alphaC=0.27;   % alpha_C albedo of clouds []
    %p.Cocn=2.935470573313E12; % C_{ocn}=Cp*V_ocn*rho_0 [W kyr/K]% !!!!
    % WHERE FROM??
    %p.Cocn=6.5792E12; 
    p.Cocn=2.7294E12; % From Andre Jueling's interpretation..
    % Cp=4E3 [J/kg/K] !!! SHOULD BE 4.184E3 [J/kg/K] !!!
    % V_ocn=21.6E6 [km^3]
    % rho_0=1028 [kg/m^3]  
    p.aocn=20.E6;       % a_{ocn} [km^2]
    p.alnd=20.E6;       % a_{lnd} [km^2]
    p.Is0=0.3*p.aocn;   % I_s0 [km^2]
    p.LEW=4.E3;         % L^{E-W} [km]
    p.lambda=0.01;      % lambda [km]
    % scaling of unforced period
    p.tt=1.0;
    p.N=2;
    p.vname={'V [x10^6 km^3]','T [K]'}; % vol of land ice// temp
    p.vrange1=[10,200]; % [10^6 km^3]
    p.vrange2=[260,290]; % [K}
    p.solver='stiff';
    %
    case 6
    % Mitsui et al 2015 phase oscillator
    mname='PO2';
    p.alpha=1.0;
    p.beta=1.0006;
    p.gamma=1.0;
    p.delta=0.24;
    % scaling of unforced period
    p.tt=7.0;
    p.N=1;  
    %
    case 7
    % Lin and Young 2008 shear induced chaos
    mname='LY08';
    p.uf=100.0;
    p.sigma=3.0;
    p.lambda=0.2;
    % scaling of forcing
    p.gamma=0.05;
    % scaling of unforced period
    p.tt=1.0;
    p.N=2;
    p.vname={'\theta','y'};
    p.vrange1=[0,2*pi];
    p.vrange2=[-0.1,0.1];
    %
    %
    case 8
    % Ashkenazy (2006)
    mname='A06';
    % Original units
    %
    % note that 1 Sv = 3.1e7 km^3/kyr, I think.. 
    % so 1 Sv = 31.536 x 10^6 km^3/kyr .. CHECK!!
    %
    % units of V = 10^6 km^3, time = kyr
    p.p0=0.25*31.536; % original 0.25 Sv = 10^6 m^3/sec
    p.S=0.21*31.536; % original 0.21 Sv
    p.SM=0.02*31.536; % original 0.02 Sv
    p.Vmin=3; % 10^6 km^3
    p.Vmax=45; % 10^6 km^3
    p.aon=0.3; % dimensionless
    p.k=1/40.0; % 1/kyr
    % Name with t at the end means tilde
    %p.p0t=(p.p0-p.k*p.Vmin)/(p.Vmax-p.Vmin); % Sv
    %p.St=p.S/(p.Vmax-p.Vmin); % Sv
    %p.SMt=p.SM/(p.Vmax-p.Vmin); % Sv
    %p.Vmint=0.0; % dimensionless
    %p.Vmaxt=1.0; % dimensionless
    % scaling of forcing
    p.gamma=1.0;
    % steepness of cutoff
    p.Ks=1.0;
    % fast timescale for y
    p.tauy=8.0;
    % scaling of unforced period
    p.tt=1.0;
    p.N=2;
    p.vname={'V','a'};
    p.vrange1=[0,50.0];
    p.vrange2=[-0.05,0.35];

    otherwise
    sprintf('Model not known')
    keyboard
end  % switch-case

p.zeros=zeros(2*p.N+1,1);

end


function [p, mname]=loadModel(p)

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
    p.Fmu=0.0;
    p.N=3;
    %
    case 3
    % de Saedeleer et al VDP
    mname='VDP';
    p.alpha=11.11;
    p.beta=0.25;
    % scaling of unforced period
    p.tt=35.09;
    p.N=2;
    %
    case 4
    % VDVP
    mname='VDPD';
    p.alpha=2;
    p.beta=0.7;
    p.delta=1.0;
    % scaling of unforced period
    p.tt=13.0;
    p.N=2;
    %
    case 5
    % TG03
    mname='TG';
    p.KK=100;        % smoothing heaviside
    p.Tf=270.15;     %T_f (-3degC end value in TG03)
    p.qr=0.7;        %q_r
    p.epsq=0.622;    % epsilon_q
    p.A=2.53E11;     % A [Pa]
    p.B=5.42E3;      % B [K]
    p.LEW=4.E3;      % L^{E-W} [km]
    p.lambda=0.01;    % lambda [km]
    p.P0=1.89216E6;     % P_0 [km^3/kyr]
    p.P1=1.26144E9;      % P_1 [km^3/kyr/Pa]
    p.aocn=20.E6;   % a_{ocn} [km^2]
    p.Is0=0.3*p.aocn;% I_s0 [km^2]
    p.alnd=20.E6;   % a_{lnd} [km^2]
    p.S0=4.7304E6;     % S_0 [km^3/kyr]
    p.SM=2.52288E6;     % S_M [km^3/kyr] strength of forcing    
    p.ST=4.7304E4;   % S_T [km^3/kyr/K]
    p.Cocn=2.935470573313E12;% C_{ocn} [W kyr/K]
    p.eps=0.64;      % epsilon
    p.sigma=5.67E-02;% sigma [W km^-2 K^-4]
    p.Hs=350.E6;       % H_s [W km^-2]
    p.alphaS=0.65;   % alpha_S
    p.alphaL=0.7;    % alpha_L
    p.alphaC=0.27;   % alpha_C
    % scaling of unforced period
    p.tt=13.0;
    p.N=2;
    %
    case 6
    % Mitsui et al 2015 phase oscillator
    mname='PO2';
    p.alpha=1.0;
    p.beta=1.0006;
    p.gamma=1.0;
    p.delta=0.24;
    % scaling of unforced period
    p.tt=1.0;
    p.N=1;  
    %
    otherwise
    sprintf('Model not known')
    keyboard
end  % switch-case

p.zeros=zeros(2*p.N+1,1);

end


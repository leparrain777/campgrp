function [fn] = fn_lyaps(t,y,p)
% function [fn] = fn_lyaps(t,y,p)
%
% evaluates f(t,y) called by odesolver for solving y'=f(t,y)
% including variables for determining the largest Lyapunov Exponent
%   p.model: paramter for model choice
%       1 - PP04  
%       2 - SM91
%       3 - VDP
%       4 - VDVP
%       5 - TG03
%       6 - PO2
%   calls forcing.m to determine forcing for given time step

fn=p.zeros;

% evaluate forcing
F=forcingF(t,p);

switch p.model
    % for all models, LE growth rate (lambda) must be last state variable
    case 1
    % PP04
    % nonlinear vars
    xx=y(1);
    yy=y(2);
    zz=y(3);
    % le direction
    lx=y(4);
    ly=y(5);
    lz=y(6);
    % log le amplitude
    %ll=y(7);
    % x=IV, y=AA, z=mu
    hvs=(1+tanh(-p.KK*(p.h*xx-p.i*yy+p.j)))*0.5;
    dhvs=sech(-p.KK*(p.h*xx-p.i*yy+p.j))^2*0.5;
    % nonlinear eqs
    fx=(-p.a*zz-p.b*F+p.c-xx)/p.taui;
    fy=(xx-yy)/p.taua;
    fz=(p.d*F-p.e*xx+p.f*hvs+p.g-zz)/p.taumu;
    % variational ODE from Jacobian
    fxl=lx*(-1/p.taui)+ly*0+lz*(-p.a/p.taui);
    fyl=lx*(1/p.taua)+ly*(-1/p.taua)+lz*0;
    fzl=lx*(-p.e+p.f*dhvs*(-p.KK*p.h))/p.taumu+ly*(p.f*dhvs*(p.KK*p.i))/p.taumu+lz*(-1/p.taumu);
    % project out expansion direction
    lam=fxl*lx+fyl*ly+fzl*lz;
    lamn=lx*lx+ly*ly+lz*lz;
    % growth rate
    lambda=lam/lamn;
    %
    fn(1)=fx;
    fn(2)=fy;
    fn(3)=fz;
    fn(4)=(fxl-lambda*lx);
    fn(5)=(fyl-lambda*ly);
    fn(6)=(fzl-lambda*lz);
    fn(7)=lambda;
    %
    case 2
    % SM91
    % Saltzmann Maasch 1991
    xx=y(1);
    yy=y(2);
    zz=y(3);
    % le direction
    lx=y(4);
    ly=y(5);
    lz=y(6);
    % log le amplitude
    %ll=y(7);
    % SM91 modified
    fx=p.alpha1-p.alpha2*p.c*yy-p.alpha3*xx-p.kth*p.alpha2*zz-p.alpha2*F;
    fy=p.beta1-(p.beta2-p.beta3*yy+p.beta4*yy*yy)*yy-p.beta5*zz+p.Fmu;
    fz=p.gamma1-p.gamma2*xx-p.gamma3*zz;
    % variational ODE from Jacobian
    fxl=lx*(-p.alpha3)+ly*(-p.alpha2*p.c)+lz*(-p.kth*p.alpha2);
    fyl=lx*0+ly*(-p.beta2+2*p.beta3*yy-3*p.beta4*yy*yy)+lz*(-p.beta5);
    fzl=lx*(-p.gamma2)+ly*0+lz*(-p.gamma3);
    % project out expansion direction
    lam=fxl*lx+fyl*ly+fzl*lz;
    lamn=lx*lx+ly*ly+lz*lz;
    % growth rate
    lambda=lam/lamn;
    %
    fn(1)=fx;
    fn(2)=fy;
    fn(3)=fz;
    fn(4)=(fxl-lambda*lx);
    fn(5)=(fyl-lambda*ly);
    fn(6)=(fzl-lambda*lz);
    fn(7)=lambda;
    %
    case 3
    % VDP
    % de Saedeleer, Crucifix, Wieczorek (4a,b) (DCW)
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % nonlinear ODE
    % extra delta term, xx term in fy changed sign
    fx=-(yy+p.beta-F);
    fy=-p.alpha*(yy*(yy*yy/3-1)-xx);
    % variational ODE
    % from Jacobian
    fxl=-ly;
    fyl=-p.alpha*(-lx+ly*(yy*yy-1));
    % project out zero expansion direction
    lam=fxl*lx+fyl*ly;
    lamn=lx*lx+ly*ly;
    % growth rate
    lambda=lam/lamn;
    %
    fn(1)=fx/p.tt;
    fn(2)=fy/p.tt;
    fn(3)=(fxl-lambda*lx)/p.tt;
    fn(4)=(fyl-lambda*ly)/p.tt;
    fn(5)=lambda/p.tt;
    %
    case 4
    % VDPD
    % de Saedeleer, Crucifix, Wieczorek (4a,b) modified to become vdP-Duffing
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % nonlinear ODE
    % extra delta term, xx term in fy changed sign
    fx=-(yy+p.beta-F);
    fy=-p.alpha*(yy*(yy*yy/3-1)-xx*(-1+p.delta*xx*xx));
    % variational ODE
    % from Jacobian
    fxl=-ly;
    fyl=-p.alpha*(-lx*(-1+3*p.delta*xx*xx)+ly*(yy*yy-1));
    % project out zero expansion direction
    lam=fxl*lx+fyl*ly;
    lamn=lx*lx+ly*ly;
    % growth rate
    lambda=lam/lamn;
    % (3,4) gives direction, (5) gives log size
    fn(1)=fx/p.tt;
    fn(2)=fy/p.tt;
    fn(3)=(fxl-lambda*lx)/p.tt;
    fn(4)=(fyl-lambda*ly)/p.tt;
    fn(5)=lambda/p.tt;
    %
    case 5
    % TG03
    % nonlinear vars
    xx=y(1);
    yy=y(2);
    % le direction
    lx=y(3);
    ly=y(4);
    % log le amplitude
    %ll=y(5);
    % x=V_LI, y=T
    asi=p.Is0*(1+tanh(-p.KK*(p.Tf-yy)))*0.5;
    dasi=p.Is0*sech(-p.KK*(p.Tf-yy))^2*0.5;
    q=p.qr*p.epsq*p.A*exp(-p.B/yy);
    aLI=p.LEW^(1/3)*(xx/(2*sqrt(p.lambda)))^(2/3);
    a=p.aocn+p.alnd;
    % nonlinear eqs
    fx=(p.P0+p.P1*q)*(1-asi/p.aocn)-p.S0+p.SM*F+p.ST*(yy-273.15);
    fy=(p.aocn/p.Cocn)*(-p.eps*p.sigma*yy^4+p.Hs*(1-p.alphaS*asi/a-p.alphaL*aLI/a)*(1-p.alphaC));
    % variational ODE from Jacobian
    fxl=lx*0+ly*(p.P1*p.qr*p.epsq*p.A*p.B*exp(-p.B/yy)/(yy^2)*(1-asi/p.aocn)-(p.P0+p.P1*q)*p.KK*dasi/a+p.ST);
    fyl=lx*(-(p.aocn/p.Cocn)*(1-p.alphaC)*2*p.alphaL*aLI/(3*a*xx))+ly*(-(p.aocn/p.Cocn)*(p.eps*p.sigma*4*yy^3+(1-p.alphaC)*p.alphaS*p.KK*dasi/a));
    % project out expansion direction
    lam=fxl*lx+fyl*ly;
    lamn=lx*lx+ly*ly;
    %
    % growth rate
    lambda=lam/lamn;
    %
    % (3,4) gives direction, (5) gives log size
    fn(1)=fx/p.tt;
    fn(2)=fy/p.tt;
    fn(3)=(fxl-lambda*lx)/p.tt;
    fn(4)=(fyl-lambda*ly)/p.tt;
    fn(5)=lambda/p.tt;
    %
    case 6
    % PO2
    % Mitsui, Crucifix, Aihara phase oscillator(2015)
    xx=y(1);
    % le direction (trivial but kepts for consistency with above)
    lx=y(2);
    % nonlinear ODE
    temp=p.alpha*(1+p.gamma*F);
    fx=p.beta+temp*(cos(xx)+p.delta*cos(2*xx));
    % variational ODE
    % from Jacobian
    fxl=-lx*temp*(sin(xx)+2*p.delta*sin(2*xx));
    % project out zero expansion direction
    lam=fxl*lx;
    lamn=lx*lx;
    % growth rate
    lambda=lam/lamn;
    % NB second component should be zero
    fn(1)=fx/p.tt;
    fn(2)=(fxl-lambda*lx)/p.tt;
    fn(3)=lambda/p.tt;
    %
    otherwise
    sprintf('model unknown')
    keyboard
end % switch-case

%scaling of model time by tau
ts=1/p.tau;

fn=fn*ts;

end


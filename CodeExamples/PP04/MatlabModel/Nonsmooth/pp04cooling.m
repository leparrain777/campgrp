function fn=PP04cooling(t,y,p);
%
% PP04 nonsmooth glacial cycle model: cooling phase
%
% external forcing
    i65=ppval(p.i65n_cf,t);  % insolation 65 North
% state vars
    V=y(1);     % global ice volume
    A=y(2);     % Antarctic ice volume
    C=y(3);     % atmospheric CO2
% relaxation equilibira
    Vr = -p.x*C-p.y*i65+p.z;
    Cr = p.alpha*i65-p.beta*V+p.delta;
% nonlinear eqs
    fn(1)=(Vr-V)/p.tauV;
    fn(2)=(V-A)/p.tauA;
    fn(3)=(Cr-C)/p.tauC;
    fn=fn(:);
end % function
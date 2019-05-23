fn=PP04model(t,y,p);
%
% PP04 glacial cycle model
%
% exeternal forcing
    F=forcingF(t,p);
% state vars
    xx=y(1);
    yy=y(2);
    zz=y(3);
% efficiency heavside function
    hvs=(1+tanh(-p.KK*(p.h*xx-p.i*yy+p.j)))*0.5;
% nonlinear eqs
    fx=(-p.a*zz-p.b*F+p.c-xx)/p.taui;
    fy=(xx-yy)/p.taua;
    fz=(p.d*F-p.e*xx+p.f*hvs+p.g-zz)/p.taumu;
%
    fn(1) = fx;
    fn(2) = fy;
    fn(3) = fz;
end % function
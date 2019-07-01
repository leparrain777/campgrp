function Cfunout = C(D,Z,Dnot,alphafour,psi,H,n)
%Cfunctioninsv92
%   Detailed explanation goes here
Cfunout = piecewise(D < Z | D < Dnot, 0, D > Z & D > Dnot, -alphafour * psi / (H * n));
end

%piecewise(D < Z | D < Dnot, 0, D > Z & D > Dnot, -alphafour * psi / (H * n))

function [eff, switchmodel, dir] = efficiency(t,y,p)
%
% calculates bottom water efficiency switch for nonsmooth PP04 model
%
%   External forcing
i60=ppval(p.i60s_cf,t);  % insolation 60 South
%
%   state variables
V=y(1);     % global ice volume
A=y(2);     % Antarctic ice volume
% efficiency
eff = p.a*V-p.b*A-p.c*i60+p.d;
% terminate integrate
switchmodel=1;
% determine all zeros
dir=0;
end


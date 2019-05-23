function [D, Dbar, U,S,V, PC, EOF_scaled, rel_var, scaling] = process(D,nt,nlat,nlon,lat, scaleflag)
scaling = 0;
if (scaleflag)
    % scale the data by sqrt(cos(lat)), output is D_scaled
    [D_scaled, scaling] = scale(D, lat, nt, nlon);
    D = D_scaled;
end
% center the data about zero
[D_center, Dbar] = center(D, nt);
D = D_center;
% determine EOFs
[U, S, V] = svd(D);
total_EOF = nt;
[PC_scaled, EOF_scaled, rel_var] = EOF(S,U,V,total_EOF,nt,nlat,nlon);
PC = PC_scaled;

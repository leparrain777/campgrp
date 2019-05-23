function [D_scaled, scaling] = scale(D_unscaled, lat, nt, nlon)
%scales matrix by sqrt(cos(lat))
scaling = sqrt(cos(lat.*(pi/180)));
scale_mat = repmat(scaling', nt, nlon);
D_scaled = D_unscaled.*scale_mat;
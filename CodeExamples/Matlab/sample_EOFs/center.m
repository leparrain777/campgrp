function [D_center, Dbar] = center(D_uc, nt)
%Centers data about zero;  inputs temp_total from read_waccm then outputs
% # of timesteps, latitudes, and longitudes.  Centered data is temp_center.
Dbar = mean(D_uc, 1);
Dbig = repmat(Dbar, nt, 1);
D_center = D_uc-Dbig;
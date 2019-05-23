function [EOF_spatial, seasonal_unf, Dbar_unf]= post_process(nlat, nlon, nEOF, seasonal_cycle, EOF_scaled, scaling, scaleflag, Dbar)
% unfold the EOF matrix
[EOF_unfolded, seasonal_unf, Dbar_unf] = unfold_matrix(nlat, nlon, nEOF, seasonal_cycle, EOF_scaled, Dbar);
if (scaleflag)
    % unscale the EOF matrix
    unscale_mat = repmat(scaling,1,nlon);
    EOF_spatial = zeros(nlat,nlon,nEOF);
    for z = 1:nEOF;
        EOF_spatial(:,:,z) = EOF_unfolded(:,:,z)./unscale_mat;
    end
    Dbar_unf = Dbar_unf./unscale_mat;
else
    EOF_spatial = EOF_unfolded;
end

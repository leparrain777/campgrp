function [EOF_unfolded, seasonal_unf, Dbar_unf] = unfold_matrix(nlat, nlon, nEOF, seasonal_cycle, EOF_scaled, Dbar)
EOF_unfolded = zeros(nlat,nlon,nEOF);
for y = 1:nEOF;
    EOF_unfolded(:,:,y) = reshape(EOF_scaled(:,y),nlat,nlon);
end
seasonal_unf = zeros(12,nlat,nlon);
for w = 1:12;
    seasonal_unf(w,:,:) = reshape(seasonal_cycle(w,:),nlat,nlon);
end
Dbar_unf = zeros(nlat, nlon);
Dbar_unf(:,:) = reshape(Dbar(:,:),nlat,nlon);
function [D] = fold_matrix(nt, nlat, nlon, mat)
%folds matrix such that it is m x n, where m is time and n is lat/lon
%n is organized with all the latitudes for one longitude, then all the latitudes
%for the next longitude and so on
D = zeros(nt, nlat*nlon);
for k=1:nt;
    M3 = mat(k,:,:);
    M2 = squeeze(M3);
    V_k = M2(:);
    D(k,:) = V_k;
end
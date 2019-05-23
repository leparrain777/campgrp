function [PC_scaled, E_O_F_scaled, rel_var] = EOF(S,U,V,total_EOF,nt,nlat,nlon)
s_u = size(U);
s_v = size(V);
PC = zeros(s_u(1),total_EOF);
lambda = zeros(total_EOF,1);
for c = 1:total_EOF;
    PC(:,c) = S(c,c).*U(:,c);
    lambda(c) = S(c,c).^2;
end
E_O_F = V;
% rescale
s_dev = std(PC);
s_dev_PC = repmat(s_dev,nt,1);
s_dev_EOF = zeros(nlat*nlon, nlat*nlon);
s_dev_EOF(:,1:nt) = repmat(s_dev,nlat*nlon,1);
PC_scaled = PC./s_dev_PC;
E_O_F_scaled = E_O_F.*s_dev_EOF;
% relative variance
rel_var = lambda./sum(lambda);
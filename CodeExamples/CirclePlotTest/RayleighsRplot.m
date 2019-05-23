function [R, avgPhase, R_alpha, d] = RayleighsRplot(phases, alpha_R, alpha_p, niter)
%
% function [R, avgPhase, R_alpha, d] = RayleighsRplot(phases, alpha_R, alpha_p, niter)
%
% Calculates and plots circle statistics for set of phases
% Inputs
%   phases       array of phases
%   alpha_R      significnce alpha for R,
%                eg. alpha_R = 0.01
%   alpha_p      significance alpha of mean direction,
%                eg. alpha_p =1-0.6827
%   niter;       number of iterations in Monte Carlo, eg. niter = 1e4;
%
%   C.D.Camp, 8/27/18
%
   np = length(phases);
   %
   phases1 = pi/2+phases; % shift zero phase to vertical
   %
   rho = sum(exp(phases1 * i)) / np;
   R = abs(rho);            % Rayleigh's R
   avgPhase = angle(rho);   % mean direction
   %
   % Test for uniformity - Monte Carlo
   for k=1:niter
       Phi_k = rand(np,1)*2*pi;      % Random uniform smaple
       R_unif(k) = abs(sum(exp(Phi_k * i)) / np);
   end
   R_alpha = prctile(R_unif,100*(1-alpha_R));
   %
   %  limits for (1-alpha) confidence level of the mean phase
   % Bootstrap phases using even resampling (unless too large)
   if (np*niter) <= 1e8 % construct set of evenly resampled phases
     % construct set of evenly resampled indices
     temp = repmat([1:np],1,niter)';        
     index_perm = reshape(temp(randperm(length(temp))),np,niter);
     for j = 1:niter
       Phi_j = phases1(index_perm(:,j));
       avgPhase_dist(j) = angle(sum(exp(Phi_j * i)) / np);
     end
     deltaPhase = avgPhase_dist-avgPhase;
     ind = find(deltaPhase < -1*pi);
     deltaPhase(ind) = deltaPhase(ind)+2*pi;
     d = prctile(deltaPhase,100*(1-alpha_p));
   else % sequential bootstrap not implemented
       disp('Error (RayleighRplot): data * iterations too large for even-resampling bootstrap');
       return;
   end % if
   
   hold on;

   tt = 0:.01:2 * pi;
   % unit circle
   h1 = polar(tt,ones(size(tt)), 'k');
   set(h1, 'Linewidth', 2);
   %
   % Disk: 99-th percentile uniform Rayleigh's R
   h4 = patch(get(h1,'XData') *R_alpha, get(h1,'YData') *R_alpha, [.85,.85,.35]);
   set(h4,'edgecolor','none');
   %
   % phi = 0 line
   topline = 0.9 : 0.01 : 1.1;
   h6 = polar(pi / 2 + zeros(size(topline)), topline, 'k');
   set(h6, 'Linewidth', 2);
   %
   % small center circle
   h5 = polar(tt, ones(size(tt)) * 0.05, 'k');   
   set(h5, 'Linewidth', 2);
   %
   % sampled phases
   h2 = polar(phases1, ones(np,1), '.r');
   set(findobj(h2, 'Type', 'line'), 'MarkerSize', 20);
   %
   % sample Rayleigh's R linbe segemnt
   h3 = polar([avgPhase avgPhase], [0 R], 'k');
   set(findobj(h3, 'Type', 'line'), 'Linewidth', 3);
   %
   % arc for error in average phase
   arc = avgPhase - d : 0.05 : avgPhase + d;
   h7 = polar(arc, ones(size(arc)) * R, 'k');
   set(h7, 'Linewidth', 2);

   pbaspect([.8 1 1]);

   axis off;

   hold off;
end


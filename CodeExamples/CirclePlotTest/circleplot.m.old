function [R, avgPhase, r99, d] = circleplot(phases)
   t = 0:.01:2 * pi;
   np = length(phases);
   phases = pi/2+phases; % shift zero phase to vertical
   
   rho = sum(exp(phases * i)) / np;
   R = abs(rho);
   avgPhase = angle(rho);
   % R for 1-alpha confidence level
   alpha = 0.01;
   r99 = sqrt((1+2*np)^2 - (1+2*np+log(alpha))^2)/2/np
   %
   %  limits for (1-alpha) confidence level of the mean phase
   alpha = 0.6826; % 1-std-dev
   chi2value = chi2inv(alpha, 1);
   Rn = R * np;
   if R<sqrt(chi2value/2/np)
       d = 0;
   elseif R>.9
       term1 = np-(np^2-Rn^2)*exp(chi2value/np);
       d=acos(sqrt(term1)/Rn);
   else % R .LE. .9
       term1 =2*np*(2*Rn^2-np*chi2value);
       term2 = 4*np-chi2value;
       d=acos(sqrt(term1/term2)/Rn);
   end
   
   hold on;

   h1 = polar(t,ones(size(t)), 'k');
   set(h1, 'Linewidth', 2);

   h4 = patch(get(h1,'XData') *r99, get(h1,'YData') *r99, [.85,.85,.35]);
   set(h4,'edgecolor','none');

   topline = 0.9 : 0.01 : 1.1;
   h6 = polar(pi / 2 + zeros(size(topline)), topline, 'k');
   set(h6, 'Linewidth', 2);

   h5 = polar(t, ones(size(t)) * 0.05, 'k');   
   set(h5, 'Linewidth', 2);

   h2 = polar(phases, ones(size(phases)), '.r');
   set(findobj(h2, 'Type', 'line'), 'MarkerSize', 20);
   

   h3 = polar([avgPhase avgPhase], [0 R], 'k');
   set(findobj(h3, 'Type', 'line'), 'Linewidth', 3);

   arc = avgPhase - d : 0.05 : avgPhase + d;
   h7 = polar(arc, ones(size(arc)) * R, 'k');
   set(h7, 'Linewidth', 2);

   pbaspect([.8 1 1]);


   axis off;

   hold off;
end


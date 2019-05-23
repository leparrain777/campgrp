%
% Testing script for circleplot routine
%
clear all;
%close all;
%
% Set sigma to change significance of R
%  For datatype 1:
%  sigma = 0.5:    R definitely sig.
%  sigma = 1.5:    R sig. (barely)
%  sigma = 2.0;    R not sig,
sigma = 1.5;
%
% Set flag for time direction in plots (does not affect phases)
%  0 - forward time (increase to right)
%  1 - reversed time (increases to left)
%   chose reversetime=1 to match Huybers
reversetime = 0;
%
% Set flag for form of synthetic data
%   1 - slowly varying oscillation locked to index
%   2 - slowly varying oscillation NOT locked to index
datatype = 1;
%
% set parameters for  statistical tests
alpha_R = 0.01;
alpha_p = 1-0.6827;
niter = 1e4;        % number of iteration in MC
%
% index leads data by phi0 (on average)
%    index max precedes average data max for phi0 > 0
phi0 = 0.25*pi;  
%
maxt = 150;
tt = [0:0.1:maxt]';
nt = length(tt);
if (reversetime)
    ttr = tt(end)-tt;
    ttt = ttr;
    xlbl = 'Reversed Time';
else
    ttt = tt;
    xlbl = 'Time';
end
%
% index: strictly periodic
%
period = 10;
w0 = 2*pi/period;
xx = cos(w0.*tt);
%
switch datatype
    case 1
    % data: slowly varying oscillation locked to index
    %   slowly varying phaseshift
    w1 = w0./pi;
    phi1 = phi0 + sigma*sin(w1.*tt);
    yy = cos(w0.*tt-phi1);
    %
    case 2
    % data: slowly varying oscillation NOT locked to index
    %   slowly varying phaseshift
    w1 = w0./pi;
    w2 = 2*w0./exp(1);
    phi1 = phi0 + sigma*sin(w1.*tt);
    yy = cos(w2.*tt-phi1);
end % switch
%
% plot data vs index
%
figure(1);
clf;
subplot(2,1,1);
plot(ttt,xx,'r',ttt,yy,'b');
xlabel(xlbl);
%
% find maxima & local period for index
%
[maxs mins] = extrema(xx);
ind_xmax = maxs(:,1); % include both endpoints
t_xmax = tt(ind_xmax);
%
% find 'phases' for index for data maxima
%
[maxs mins] = extrema(yy);
ind_ymax = maxs(2:end-1,1);  % ignore both endpoints
t_ymax = tt(ind_ymax);
%
subplot(2,1,2);
plot(ttt,xx,'r',ttt,yy,'b');
hold on;
plot(ttt(ind_ymax),xx(ind_ymax),'b.',ttt(ind_xmax),xx(ind_xmax),'r.','MarkerSize',20);
hold off;
xlabel(xlbl)
%
% Determine 'phase' of index for each data maxima
%
ng = length(ind_ymax);
phases = zeros(ng,1);
for j = 1:ng
    t_j = t_ymax(j);    % time of data point
    ind0 = max(find(t_xmax<t_j)); % index for start time of cycle
    t0 = t_xmax(ind0);  % initial time for cycle
    t1 = t_xmax(ind0+1); % final time for cycle
    period = t1-t0;     % period of cycle
    phases(j) = 2*pi*(t_j-t0)/period;
end
%
%  In the circle plot, zero phase is vertical 
%  Arbitrary choice of direction of increasing phaseshift
%    chosen to 'match' temporal plot
%    here, blue dots to left of red dots => ccw shift on circle
figure(2);
clf;
if (reversetime)
  [R, avgPhase, r99, d] = RayleighsRplot(phases,alpha_R,alpha_p,niter)
else
  [R, avgPhase, r99, d] = RayleighsRplot(2*pi-phases,alpha_R,alpha_p,niter)
end
%

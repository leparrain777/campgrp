function [x_dtr, p, tarr] = detrend_miss(x, t, tr)
%DETREND	removes polynomial trend of order TR from multivariate X.
%		with missing data
%
%	[X_DTR,P] = DETREND(X, T, TR) uses polyfit to remove
%		    a TR-th order trend from array X(T,...);
%		    detrends in 1st dimension of X		    
%
error(nargchk(3, 3, nargin))		% check number of arguments
%
n	= size(x,1);		% if row vector, convert to column vector
if (n == 1)
  x = x(:);
end;
m	= size(t,1);		% if row vector, convert to column vector
if (m == 1)
  t = t(:);
end;
xs	= size(x);
%
nt	= xs(1);
nx	= prod(xs(2:end));
temp	= reshape(x, [nt nx]);
tarr	= t - t(1);
p	= zeros(tr+1, nx);
x_dtr	= zeros(nt, nx);
for ix = 1:nx
  x1		= squeeze(temp(:,ix));
  p1		= polyfit(tarr, x1, tr);
  x1_tr		= polyval(p1, tarr);
  x1_dtr	= x1 - x1_tr;
  p(:, ix)	= p1.';
  x_dtr(:, ix)	= x1_dtr;
end;
p	= reshape(p, [ tr+1 xs(2:end)]);
x_dtr	= reshape(x_dtr, xs);
%
if (n == 1)
  x_dtr	= x_dtr.';
end;
if (m == 1)
  tarr	= tarr.';
end;

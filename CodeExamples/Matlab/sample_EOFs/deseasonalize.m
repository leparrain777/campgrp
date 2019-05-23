function [x_dsn, cycle] = deseasonalize(x, ntyear)
% Syntax:
%	 [x_dsn, cycle] = deseasonalize(x, ntyear)
%
%	Removes mean annual cycle from single timeseries
%
%	Inputs:	X(t)		Initial timeseries
%		ntyear		number of timesteps per year
%
%	Output: X_DSN(t)	Deseasonalized timeseries
%		CYCLE		Mean cycle (length ntyear)
%
nt = length(x);
%
ind0 = find(isnan(x));
ind1 = find(isfinite(x));
%
cycle = zeros(ntyear,1);
count = zeros(ntyear,1);
%
x_dsn = x;
%
for t = 1:nt
  if ~isnan(x(t))
    l = mod(t-1, ntyear)+1;
    count(l) = count(l) + 1;
    cycle(l) = cycle(l) + x(t);
  end
end
cycle = cycle./count;
%
ind_ann = mod(ind1-1,ntyear)+1;
if ~isempty(ind1) x_dsn(ind1) = x(ind1) - cycle(ind_ann); end
if ~isempty(ind0) x_dsn(ind0) = NaN; end

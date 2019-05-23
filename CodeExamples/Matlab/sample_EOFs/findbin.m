function ix0 = findbin(x0, x, upper)
%	function ix0 = findbin(x0, x, upper)
%
%	Determines index of bin of monotonic array X which contains
%	the value X0.
%
%	UPPER = 1 chooses upper bound if X0 equidistant from 2 Xi's
%		0   "     lower   "
%
diffx = diff(x);
dir = sign(diffx(1));		% +1 - increasing, -1 - decreasing
check = isempty(find(sign(diffx) ~= dir));	% test monotonicity
if check	
  nx = length(x);
  m0 = (3*x(1) - x(2))/2.;
  m1 = (3*x(nx) - x(nx-1))/2.;
  midpt = [m0, (x(1:nx-1) + x(2:nx))'/2., m1]';
;
  if dir == 1
    if upper
      ix = find(midpt <= x0);
    else
      ix = find(midpt < x0);
    end
    ix0 = max(ix);
  elseif dir == -1
    if upper
      ix = find(midpt > x0);
    else
      ix = find(midpt >= x0);
    end
    ix0 = max(ix);
  else
    error('FINDBIN: constant array input')
  end
else
  error('FINDBIN: non-monotonic array input')
end
;

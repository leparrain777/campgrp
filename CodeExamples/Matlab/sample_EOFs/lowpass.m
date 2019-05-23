function x_lowpass = lowpass(x, cut_freq)
%LOWPASS    Low-pass filter columns of data matrix.
% 
%    X_LOWPASS = LOWPASS(X, cut_freq) uses an eigth-order Chebyshev
%    type I filter to lowpass filter the columns of the data matrix X,
%    returning the low pass component X_LOWPASS. The filter's
%    cutoff frequency (measured in fractions of the sampling rate)
%    is given by the input parameter cut_freq.
%
%    If the data sequence is too short for an eigth-order filter,
%    the filter order is reduced. 

%    Principal ideas taken from decimate.m

    error(nargchk(2, 2,nargin))          % check number of input arguments 
  
    nrows       = size(x, 1);
    nfilt	= 8;				% default filter order
    rip		= 0.05;				% passband ripple in db
    [b,a]	= cheby1(nfilt, rip, 2*cut_freq);

    % check if filter order is adequate
    while (abs(filtmag_db(b, a, 2*cut_freq) + rip) > 1e-6) 
      nfilt = nfilt - 1;
      if nfilt == 0
	break
      end
      [b,a] = cheby1(nfilt, rip, 2*cut_freq);
    end
    
    if nfilt == 0
      error('Bad Chebyshev design: cutoff frequency likely to be too small.')
    end

    x_lowpass	= filtfilt(b, a, x);

% ---------------------------------------------------------------------------
    
function H = filtmag_db(b,a,f)
%FILTMAG_DB Filter's magnitude response in decibels at given frequency.

  nb  = length(b);
  na  = length(a);
  top = exp(-j*(0:nb-1)*pi*f)*b(:);
  bot = exp(-j*(0:na-1)*pi*f)*a(:);
  
  H   = 20*log10(abs(top/bot));


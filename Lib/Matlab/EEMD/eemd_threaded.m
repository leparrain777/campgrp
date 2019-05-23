function modes = eemd(ts, nStd, nItr, nThreads)
% Syntax:
%  function modes = eemd(ts, nStd, nItr)  
%
%  ts - The time series on which to perform the eemd    
%  nStd - Number of standard deviations to use for the noise
%  nItr - Number of iterations
%

% Check if nThreads arg is provided
   if (nargin < 4 || nThreads == 1)
      nThreads = 0;
   end

   if (nargin < 2)
      nItr = 1;
      nStd = 0;
   end

   if (~isvector(ts))
      error 'Must input a vector';
   end

   if (size(ts,1) == 1)
      ts = ts';
   end

% Calculate length of ts
   len = length(ts);

% Normalize standard deviation of ts
   tsStd = std(ts);
   ts = ts / tsStd;

% Calculate number of modes
   nModes = floor(log2(len)) - 1;
% Calculate number of vectors - modes plus original
% data and residual
   nVecs = nModes + 2;

% Initialize modes array
   modes = zeros(len, nVecs);

   if(nThreads)
      matlabpool('open', 'local', nThreads); 
   end

   parfor ndx = 1:nItr

      % Make normal noise and create synthetic
      noise = randn(len,1) * nStd;

      synth = ts + noise;

      % Initialize tempmodees (what we later add to modes)
      tempmodes = zeros(len,nVecs);

      % First column is the data
      tempmodes(:,1) = ts;

      for nmode = 1:nModes
         % mode will turn into our IMF
         mode = synth;

         for iter = 1:10
            % Create envelope and subtract the mean from mode x10
            [maxs, mins] = extrema(mode);
            upperEnv = spline(maxs(:,1), maxs(:,2), 1:len);
            lowerEnv = spline(mins(:,1), mins(:,2), 1:len); 
            meanEnv = ((upperEnv + lowerEnv) / 2)';
            mode = mode - meanEnv;
         end  
         synth = synth - mode; 
      
         tempmodes(:,nmode + 1) = mode;
      end

      tempmodes(:, nVecs) = synth;

      modes = modes + tempmodes;

   end
   
   if (nThreads) 
      matlabpool close;
   end
   

% Divide by number of iterations and denormalize (is that a word?)
   modes = modes / nItr; 
   modes = modes * tsStd;

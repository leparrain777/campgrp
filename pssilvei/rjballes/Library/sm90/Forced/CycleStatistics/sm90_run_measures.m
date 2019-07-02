% Date Created:7 August 2018
% Author: Raymart Ballesteros

% This script finds the certain measurements for cycles of the SM90 model run

% General Flags and runID
runID = 11;
% Identifies data of model runs by the forcing used
descr = 'insolHuybersIntegrated';
%descr = 'insolLaskar';
%descr = 'solsticeLaskar';

fileName = sprintf('SM90_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';

%sm90_cycle_stats   % May need to adjust flags to turn off/on
sm90_find_cycles

% vectors of the indices of the max/min ice mass
mxI = []; %maxIat;
mnI = []; %minIat;
for k=1:length(maxIat)
   mxI = [mxI t(maxIat(k))];
   mnI = [mnI t(minIat(k))];
end %for

% costructing vector of proportion of ice melted in each cycle
dI = mxI-mnI;
propI = [];
for j=1:length(dI)
   prop = dI(j)/mxI(j);
   propI = [propI prop];
end %for

% vector of the lengths of full cycles
%fullLens = fullLength;
fullLens = MinAt(2:end)-MinAt(1:end-1);
%avg_fullLens = mean(fullLens);

% Constructing vector of number partial melts in each cycle, and times of max/min in cooling phases
idMax_pmelts = [];
idMin_pmelts = [];
%numpmelts = 0;
melts_per_cycle = [];
for i=1:size(MinAt,2)-1
[numPartials,idxMaxI,idxMinI] = sm90_partialmelts(MaxAt(i),MinAt(i+1),I);
   %numpmelts = numpmelts+numPartials;
   melts_per_cycle = [melts_per_cycle numPartials];
   idMax_pmelts = [idMax_pmelts idxMaxI];
   idMin_pmelts = [idMin_pmelts idxMinI];
end %for

% Finds correlations between variables of interest
[r1,p1] = corrcoef(mxI(1:end-1),fullLens(2:end));
[r2,p2] = corrcoef(mnI,fullLens);
[r3,p3] = corrcoef(mxI(1:end-1),mnI(2:end));

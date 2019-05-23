%
% Ice Age Pacing TimeSeries run
%
tic;
%
% set plotfigs=true to plot timeseries
plotfigs=false;
%plotfigs=true;
%
p.model=1;
[p, mname] = loadModel(p);
% model options are
%   1=Palliard Parrenin 2004
%   2=Saltzmann Maasch 1991
%   3=van der Pol as in de Saedleleer et al 2013
%   4=van der Pol - Duffing
%   5=Tziperman-Gildor2003 %% added by AH
%   6=phase oscillator - Mitsui et al 2015
%
p.forcing=3;
% forcing options are
%   1=periodic (sum of 2 sinusoids)
%   2=Integrated Summer Insolation
%   3=de Saedeleer et al forcing with sum of obliquity and precession
%integration transient time and maximum time (kyr)
ttrans=-60; 
tmax=2000;  % for integrated summer forcing, need tmax-ttrans < 5000

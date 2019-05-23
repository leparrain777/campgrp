% loadParamTAU
%       loads control parameters for 'tau' run
%       scales model time vs 'true' forcing time
%
runNumber = 705;
userNumber = 2;
fullRunNumber = userNumber*10.^4+runNumber;
%
plotfigs = true;        % set to true to plot figures
savefigs = true;        % set to true to save figures to file
savedata = true;        % set to true to save output data to file
plotts   = false;       % set to true to plot the time series as computed
%
pfpath = './Params/TAUruns/';     % location for saved parameter files
sfpath = './SavedData/TAUruns/';  % location for date save files
ffpath = './Figures/TAUruns/';    % location for figure save files
%
p.model=8;
[p, mname] = loadModel(p);
% model options are
%   1=Palliard Parrenin 2004
%   2=Saltzmann Maasch 1991
%   3=van der Pol as in de Saedleleer et al 2013
%   4=van der Pol - Duffing
%   5=Tziperman-Gildor2003 %% added by AH
%   6=phase oscillator - Mitsui et al 2015
%   7=Lin and Young 2008 model
%   8=Ashkenazy 2007
%
p.forcing=1;
normflg = 1; % normalization choice for DCW forcing
% forcing options are
%   1=(quasi) periodic (sum of 2 sinusoids)
%   2=Integrated Summer Insolation
%   3=de Saedeleer et al forcing with sum of obliquity and precession
%       normflg choses normalization option:
%           1 - absolute maximum = 1
%           2 - standard deviation = 1
%
% detuning parameters
nTau = 120;     % number of Tau gridpoints in scan
nAmp   = 120;       % number of amplitude gridpoints in scan
minTau = 0.3;   % minimum Tau value
maxTau = 1.5;   % maximum Tau value
%
% integration transient time, maximum time (kyr)
ttrans=600;  % time (kyr) for transient
tmax=3600;  % for integrated summer forcing, need tmax < 5000
%
% Initial Conditions for all runs
yinit=zeros(2*p.N+1,1);
yinit(1)=0.5;
% Random unit vector for Ly.Exp. IC
temp = rand(p.N,1);
yinit(p.N+1:2*p.N)= temp./norm(temp,2);
%
% forcing dependent parameters
switch p.forcing
    case 1
        fname = 'QP';
        % periodic: 2-frequency
        % obliquity frequency
        p.omega1=2*pi/41.0;
        % precession frequency
        p.omega2=2*pi/23.0;
        % select forcing parameter values for scan
        minAmp = 0;         % min amplitude in scan
        maxAmp = 1;         % max amplitude in scan
        ratioAmp = 1;       % ratio of omega1 to omega2 amplitudes:
                            % 1= only omega1, 0= only omega2
    case 2
        % summer integrated insolation
        fname = 'IS';
        % latitude for integrated insolation
        insol_lat = 65;
        % select forcing parameter values for scan
        minAmp = 0;         % min amplitude in scan
        maxAmp = sqrt(2);   % max amplitude in scan
        ratioAmp = 1;       % ratio of omega1 to omega2 amplitudes
        % choose threshold level
        p.kt2 = 275;        % threshold
        %
        % ---- don't edit below here for this forcing ----
        % get interpolant coeff
        p.insolcf = get_integrated_insol(insol_lat, p.kt2, ttrans);
    case 3
        % de Saedeleer forcing: load coeffs
        fname0 = 'DCW';
        %
        % select forcing parameter values for scan
        minAmp = 0;         % min amplitude in scan
        maxAmp = sqrt(4.5);   % max amplitude in scan
        ratioAmp = 1;       % ratio of omega1 to omega2 amplitudes
        % ratioAmp = 'inf'  %  uncomment for pure omega1 scan
        %
        % ---- don't edit below here for this forcing ----
        % get obliquity & precession coefficients and setup normalization 
        load('./Insolation/DCW/dcwcoeffs.txt','dcwc')
        p.dcwcoeffs=dcwcoeffs;
        % normalization constants for obliquity and precession components
        n_obl=15;	% number of obliquity modes
        c_obl = sqrt(dcwcoeffs(1:n_obl,2).^2+dcwcoeffs(1:n_obl,3).^2);
        c_prc = sqrt(dcwcoeffs(n_obl+1:end,2).^2+dcwcoeffs(n_obl+1:end,3).^2);
        switch normflg
            case 1  % max.abs.value=1
                p.f1norm=norm(c_obl,1);
                p.f2norm=norm(c_prc,1);
                fname = sprintf('%sn1',fname0);
            case 2 % std.dev = 1;
                p.f1norm=norm(c_obl,2)/sqrt(2);
                p.f2norm=norm(c_prc,2)/sqrt(2);
                fname = sprintf('%sn2',fname0); 
            otherwise
                fprintf('DCW normalization option not known');
                keyboard
        end % switch normflg
    otherwise
        sprintf('Forcing option not known')
        keyboard
end % switch p.forcing
% core of save and figure filenames
basefilename = sprintf('IceAgeTAU_%s_%s_r%i',mname,fname,fullRunNumber);
%
if (savefigs || savedata)
    pfile = sprintf('%s%s_param.m',pfpath,basefilename);
    copyfile('loadParamTS.m',pfile,'f');  %saves (overwrites) parameter file 
end %if


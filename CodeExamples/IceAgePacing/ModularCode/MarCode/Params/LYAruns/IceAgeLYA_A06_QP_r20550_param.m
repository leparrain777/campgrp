% loadParamLYA
%       loads control parameters for Lyapunov Exponent Scan
%
runNumber=550;
userNumber = 2;
fullRunNumber = userNumber*(10.^4)+runNumber;
%
plotfigs = true;        % set to true to plot figures
savefigs = true;        % set to true to save figures to file
savedata = true;        % set to true to save output data to file
plotts   = false;          % set to true to plot the time series as computed
%
pfpath = './Params/LYAruns/';     % location for saved parameter files
sfpath = './SavedData/LYAruns/';  % location for date save files
ffpath = './Figures/LYAruns/';    % location for figure save files
%
% Uncomment to seed random number generator for reproducibility
% seed = 135;
% rng(seed,'twister');
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
% detuning (default tau = 1 for unscaled time)
p.tau=1.0;
% integration transient time, maximum time (kyr)
ttrans=400;  % time (kyr) for transient
tmax=1500;  % for integrated summer forcing, need tmax < 5000
%
% Initial Conditions
% Initial state vector (common for all runs in scan)
yinit=zeros(2*p.N+1,1);
yinit(1,:)=rand(1);
% Random unit vector for Ly.Exp. IC (common for all runs in scan)
temp = rand(p.N,1);
yinit(p.N+1:2*p.N)= temp./norm(temp,2);
%
% forcing dependent parameters
% default scan range for forcing parameter values
k1min = 0.00;     % min amplitude - obliquity modes
k1max = 2.00;     % max amplitude - obliquity modes
nk1 = 120;
k2min = 0.00;     % max amplitude - precession modes
k2max = 2.00;     % max amplitude - precession modes
nk2 = 120;
switch p.forcing
    case 1
        fname = 'QP';
        % periodic: 2-frequency
        % obliquity frequency
        p.omega1=2*pi/41.0;
        % precession frequency
        p.omega2=2*pi/23.0;
        %
        % ---- don't edit below here for this forcing ----
        % construct forcing parameter arrays
        k1 = linspace(k1min,k1max,nk2)';
        k2 = linspace(k2min,k2max,nk2)';
    case 2
        % summer integrated insolation
        fname = 'IS';
        % latitude for integrated insolation
        insol_lat = 65;
        % select forcing parameter values from scan
        % select scan range for forcing parameter values
        k1min = 0.00;     % min amplitude
        k1max = 1.00;     % max amplitude
        nk1 = 25;
        % scan range for threshold -- valid thresholds are [0:25:600]
        k2min = 150;     % max threshold - p.omega2
        k2max = 350;     % min threshold - p.omega2
        k2step = 5;       % delta threshold (multiple of 25 only)
        %
        % ---- don't edit below here for this forcing ----
        % construct forcing parameter arrays
        k1 = linspace(k1min,k1max,nk2)';
        k2 = [k2min:k2step:k2max]';
        nk2 = length(k2);
    case 3
        % de Saedeleer forcing: load coeffs
        fname0 = 'DCW';
        %
        % ---- don't edit below here for this forcing ----
        % construct forcing parameter arrays
        k1 = linspace(k1min,k1max,nk1)';
        k2 = linspace(k2min,k2max,nk2)';
        % get obliquity & precession coefficients and setup normalization
        load('./Insolation/DCW/dcwcoeffs.txt','dcwc');
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
                fprintf('DCW normalization option not known\n');
                keyboard
        end % switch normflg
    otherwise
        fprintf('Forcing option not known\n');
        keyboard
end % switch p.forcing
% core of save and figure filenames
basefilename = sprintf('IceAgeLYA_%s_%s_r%i',mname,fname,fullRunNumber);
%
if (savefigs | savedata)
    pfile = sprintf('%s%s_param.m',pfpath,basefilename);
    copyfile('loadParamLYA.m',pfile,'f');  %saves (overwrites) parameter file
end %if


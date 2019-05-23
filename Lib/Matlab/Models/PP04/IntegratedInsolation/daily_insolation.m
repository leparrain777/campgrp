function [Fsw,ecc,obliquity,long_perh] = daily_insolation(kyear,lat,day,day_type)

% Usage:
%   Fsw = daily_insolation(kyear,lat,day)
%
% Optional inputs/outputs:
%   [Fsw, ecc, obliquity, long_perh] = daily_insolation(kyear,lat,day,day_type)
%
% Description:
%   Computes daily average insolation as a function of day and latitude at
%   any point during the past 5 million years.
%
% Inputs:
%   kyear:    Thousands of years before present (0 to 5000).
%   lat:      Latitude in degrees (-90 to 90).
%   day:      Indicator of time of year, by default day 1 is Jan 1.
%   day_type: Convention for specifying time of year (+/- 1,2) [optional].
%     day_type=1 (default): day input is calendar day (1-365.24), where day 1 
%       is January first.  The calendar is referenced to the vernal equinox 
%       which always occurs at day 80.
%     day_type=2: day input is solar longitude (0-360 degrees). Solar
%       longitude is the angle of the Earth's orbit measured from spring
%       equinox (21 March). Note that calendar days and solar longitude are
%       not linearly related because, by Kepler's Second Law, Earth's
%       angular velocity varies according to its distance from the sun.
%     If day_type is negative, kyear is taken to be a 3 element array
%       containing [eccentricity, obliquity, and longitude of perihelion].
%
% Output:
%   Fsw = Daily average solar radiation in W/m^2.
%   Can also output orbital parameters.
%
% Required file: orbital_parameter_data.mat
%
% Detailed description of calculation:
%   Values for eccentricity, obliquity, and longitude of perihelion for the
%   past 5 Myr are taken from Berger and Loutre 1991 (data from
%   ncdc.noaa.gov). If using calendar days, solar longitude is found using an
%   approximate solution to the differential equation representing conservation
%   of angular momentum (Kepler's Second Law).  Given the orbital parameters
%   and solar longitude, daily average insolation is calculated exactly
%   following Berger 1978.
%
% References: 
%   Berger A. and Loutre M.F. (1991). Insolation values for the climate of
%     the last 10 million years. Quaternary Science Reviews, 10(4), 297-317.
%   Berger A. (1978). Long-term variations of daily insolation and
%     Quaternary climatic changes. Journal of Atmospheric Science, 35(12),
%     2362-2367.
%
% Authors:
%   Ian Eisenman and Peter Huybers, Harvard University, August 2006
%   eisenman@fas.harvard.edu
%   This file is available online at
%   http://deas.harvard.edu/~eisenman/downloads
%
% For function syntax, enter daily_insolation with no arguments.
% For examples, enter daily_insolation('examples')

% === Examples ===
if nargin==1
    if isstr(kyear)
        if kyear=='examples'
disp(' ')
disp(' Example 1: Summer solstice insolation at 65 N')
disp('   Fsw=daily_insolation(0:1000,65,90,2);')
disp('   plot(0:1000,Fsw)')
disp(' ')
disp(' Example 2: Difference between June 20 (calendar day) and summer solstice insolation at 65 N')
disp('   june20=datenum(0,6,20)-1; % year 0 is leap-year for datenum')
disp('   Fsw1=daily_insolation(0:1000,65,june20);   % June 20')
disp('   Fsw2=daily_insolation(0:1000,65,90,2); % solstice')
disp('   plot(0:1000,Fsw1-Fsw2)')
disp(' ')
disp(' Example 3: Insolation for the current orbital configuration as a function of day and latitude')
disp('   [day lat]=meshgrid(1:5:365, -90:90);')
disp('   [Fsw,ecc,obl,omega]=daily_insolation(0,lat,day);')
disp('   [c,h]=contour(day,lat,Fsw,[0:50:500]);')
disp('   clabel(c,h)')
disp('   disp([ecc,obl,omega])')
disp(' ')
disp(' Example 4: Annual average insolation by explicitly specifying orbital parameters')
disp('   ecc=0.017236; obl=23.446; omega=101.37+180;')
disp('   [day lat]=meshgrid(1:5:365, -90:90);')
disp('   Fsw=daily_insolation([ecc,obl,omega],lat,day,-1);')
disp('   plot(-90:90,mean(Fsw''))')
disp(' ')
disp(' Example 5: Compare calculated insolation with example values given by Berger (1991); requires file ORBIT91 from ncdc.noaa.gov')
disp('   m=dlmread(''ORBIT91'','' '',3,0); % Matlab 6.5')
disp('   m=dlmread(''ORBIT91'','''',3,0);  % Matlab 7')
disp('   Fsw=daily_insolation(0:5000,65,(7-3)*30,2)*1360/1365; % July 65N; Berger uses So=1360')
disp('   plot(m(:,1),1-m(:,6)./Fsw'') % values agree within 3e-5')
disp(' ')
disp(' Example 6: Plot 65N integrated summer insolation as in Huybers (2006), Science 313 508-511')
disp('   [kyear day]=meshgrid(1000:1:2000,1:1:365);')
disp('   Fsw = daily_insolation(kyear,65,day);')
disp('   Fsw(Fsw<275)=0;')
disp('   plot(-(1000:1:2000),sum(Fsw,1)*86400*10^-9)')
disp('   title(''As in Huybers (2006) Fig. 2C'')')
return
        end
    end
end

% === Check input arguments ===
if nargin<3, disp('Fsw = daily_insolation(kyear,lat,day,day_type)');
    disp('  for examples, enter daily_insolation(''examples'')'); return; end
if nargin<4, day_type=1; end

% === Get orbital parameters ===
if day_type>=0
    [ecc,epsilon,omega]=orbital_parameters(kyear); % function is below in this file
else
    if length(kyear)~=3
        disp('Error: expect 3-element kyear argument for day_type<0'), Fsw=nan; inso; return
    end
    ecc=kyear(1);
    epsilon=kyear(2) * pi/180;
    omega=kyear(3) * pi/180;
end
% For output of orbital parameters
obliquity=epsilon*180/pi;
long_perh=omega*180/pi;

% === Calculate insolation ===
lat=lat*pi/180; % latitude
% lambda (or solar longitude) is the angular distance along Earth's orbit measured from spring equinox (21 March)
if abs(day_type)==1 % calendar days
    % estimate lambda from calendar day using an approximation from Berger 1978 section 3
    delta_lambda_m=(day-80)*2*pi/365.2422;
    beta=(1-ecc.^2).^(1/2);
    lambda_m0=-2*( (1/2*ecc+1/8*ecc.^3).*(1+beta).*sin(-omega)-...
        1/4*ecc.^2.*(1/2+beta).*sin(-2*omega)+1/8*ecc.^3.*(1/3+beta).*(sin(-3*omega)) );
    lambda_m=lambda_m0+delta_lambda_m;
    lambda=lambda_m+(2*ecc-1/4*ecc.^3).*sin(lambda_m-omega)+...
        (5/4)*ecc.^2.*sin(2*(lambda_m-omega))+(13/12)*ecc.^3.*sin(3*(lambda_m-omega));
elseif abs(day_type)==2 %solar longitude (1-360)
    lambda=day*2*pi/360; % lambda=0 for spring equinox
else
    disp('Error: invalid day_type'); Fsw=nan; inso; return
end
So=1365; % solar constant (W/m^2)
delta=asin(sin(epsilon).*sin(lambda)); % declination of the sun
Ho=acos(-tan(lat).*tan(delta)); % hour angle at sunrise/sunset
% no sunrise or no sunset: Berger 1978 eqn (8),(9)
Ho( ( abs(lat) >= pi/2 - abs(delta) ) & ( lat.*delta > 0 ) )=pi;
Ho( ( abs(lat) >= pi/2 - abs(delta) ) & ( lat.*delta <= 0 ) )=0;

% Insolation: Berger 1978 eq (10)
Fsw=So/pi*(1+ecc.*cos(lambda-omega)).^2 ./ ...
    (1-ecc.^2).^2 .* ...
    ( Ho.*sin(lat).*sin(delta) + cos(lat).*cos(delta).*sin(Ho) );


% === Calculate orbital parameters ===

function [ecc,epsilon,omega] = orbital_parameters(kyear)

% === Load orbital parameters (given each kyr for 0-5Mya) ===
% this .mat file contains the matrix m with data from Berger and Loutre 1991
load orbital_parameter_data.mat; 
kyear0=-m(:,1); % kyears before present for data (kyear0>=0);
ecc0=m(:,2); % eccentricity
% add 180 degrees to omega (see lambda definition, Berger 1978 Appendix)
omega0=m(:,3)+180; % longitude of perihelion (precession angle)
omega0=unwrap(omega0*pi/180)*180/pi; % remove discontinuities (360 degree jumps)
epsilon0=m(:,4); % obliquity angle

% Interpolate to requested dates
ecc=spline(kyear0,ecc0,kyear); % eccs means array of ecc values
omega=spline(kyear0,omega0,kyear) * pi/180;
epsilon=spline(kyear0,epsilon0,kyear) * pi/180;
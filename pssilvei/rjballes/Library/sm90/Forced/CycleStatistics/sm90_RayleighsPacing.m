% A comparison of pacing of sm90 model output with a particular forcing signal
% 
clf
printflg = 0;
sm90_params
sm90_readeemd
%fileName = sprintf('SM90_insolLaskar_10_Model.txt',descr,runID);
%filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';

time = 0:4000;
len = length(time);

%[Data,te,ye] = readSM90Data(fileName,filePath, 4);
%I = flipud(-Data(:,2));
I = flipud(nmodes(:,1));
%Mu = Data(:,3);
%Theta = Data(:,4);

[ndxTime, ~, forcing, ~, ~] = readLaskarAstronomical(0,5000);  % reading in obliquity signal based on Lasksar
%forcing = forcing(end:-1:1);

%[ndxTime, ~, forcing, ~, ~] = readBergerAstronomical(0, 5000);   % reading in obliquity signal based on Berger

%[ndxTime,forcing] = integratedInsolation(0,5000);   % reading in insolation forcing based on Berger
%forcing = forcing(end:-1:1);


% Normalize both time series
signal = (I)/std(I);
forcing = (forcing - mean(forcing))/std(forcing);

forcing = smooth(forcing);

signal = signal(1:length(time));
forcing = forcing(1:length(time));

[maxes,mins] = extrema(signal);

maxend = length(maxes); % Array lengths
minend = length(mins);
%maxarray = 1:maxend-1;
%minarray = 2:minend;

if maxes(2,1) > mins(2,1)
    if maxes(end-1,1) > mins(end-1,1)
        maxarray = 1:maxend-1;
        minarray = 2:minend;
        disp('used 1')
    else % maxes(end-1,1) < mins(end-1,1)
        maxarray = 1:maxend-1;
        minarray = 2:minend-1;
        disp('used 2')
    end % if
else % if maxes(2,1) < mins(2,1)
    if maxes(end-1,1) > mins(end-1,1)
        maxarray = 2:maxend-2;
        minarray = 2:minend-1;
        disp('used 3')
    else % maxes(end-1,1) < mins(end-1,1)
        maxarray = 2:maxend-1;
        minarray = 2:minend-1;
        disp('used 4')
    end % if
end % if

if length(maxarray) ~= length(minarray)
   dupl = [];
   for k=1:length(minarray)-1
      if mins(minarray(k),2) == mins(minarray(k+1),2)
         dupl = [dupl k];
      end %if
   end %for
   minarray(dupl) = [];
   
   dupl=[];
   for k=1:length(maxarray)-1
      if maxes(maxarray(k),2) == maxes(maxarray(k+1),2)
         dupl = [dupl k];
      end %if
   end %for
   maxarray(dupl) = [];
end %if


% Find indices of times of maxes and mins respectively
tmax = [time(maxes(maxarray,1))]';
maxEO = maxes(maxarray,2);
tmin = [time(mins(minarray,1))]';
minEO = mins(minarray,2);
length(tmax)
length(tmin)
cutoff = min(length(maxEO), length(minEO));
maxEO = maxEO(1:cutoff);
minEO = minEO(1:cutoff);

tmid = mean([tmin,tmax],2);
diffEO = maxEO - minEO;
midEO = (signal(floor(tmid)+1) + signal(ceil(tmid)+1))/2;
% create cubic spline for interpolation of midpoints in time
midSig = spline(time, signal,tmid);
dev = 1.1251;
%dev = 1.45;
ind0 = find(diffEO > dev.*std(signal));

Msize = 15;

figure(1)
clf(1)

subplot(3, 1, 1)
H1 = plot(time, signal,'k');
set(H1, 'LineWidth',1.5);
hold on;
H3 = plot(tmax(ind0), maxEO(ind0), 'k+');
H4 = plot(tmin(ind0), minEO(ind0), 'k+');
H5 = plot(tmid(ind0), midSig(ind0), 'r.', 'MarkerSize', Msize);
hold off;
%set(gca, 'YDir', 'reverse')

xlim([time(1)-floor(len/50), time(end)+floor(len/50)])
xlabel('time')
midObl = spline(time, forcing,tmid);

subplot(6,1,3)
H2 = plot(time,forcing, 'k');
xlim([time(1)-floor(len/50), time(end)+floor(len/50)])
set(H2,'LineWidth', 1.5);
hold on;
plot(tmid(ind0),midObl(ind0), '.r', 'MarkerSize', Msize)
hold off;


% Rayleigh Circle Plot Routine

[forc_maxes, forc_mins] = extrema(forcing);
ng = length(ind0);
phases = [];
for ig = 1:ng
    ind1 = max(find(forc_maxes(:,1) < tmid(ind0(ig))));
    period = (forc_maxes(ind1+1,1) - forc_maxes(ind1,1));
    phases(ig) = 2*pi*(tmid(ind0(ig)) - forc_maxes(ind1,1))/period;
    if phases(ig)>pi
        phases(ig) = phases(ig)-2*pi;
    end % if
end % for
phases = phases';
phases = 2*pi - phases;

subplot(2,2,3)
[R, avgPhase, R_alpha, d] = RayleighsRplot(phases, 0.01, 1-0.6827, 1e4);

disp(R)


%suptitle(sprintf('SM90 Run %g vs %s Forcing for u = %g, p = %g',runID,descr,param(5),param(1))); 
suptitle(sprintf('SM90 Run %g Ice Output vs Obliquity for u = %g, p = %g',runID,param(5),param(1))); 

if printflg
    fpath = '/nfsbigdata1/campgrp/rjballes/ToShow/09042018/';
    %fname0 = sprintf('sm90_Run%d_oblpacing',runID);
    fname0 = sprintf('sm90_%s_oblpacing',descr);
    fname = strcat(fpath,fname0,'.eps');
    print('-depsc', fname);
%    fname = strcat(fpath,fname0,'.pdf')
%    print( '-dpdf', fname)
    fname = strcat(fpath,fname0,'.jpg');
    print( '-djpeg', fname)
end
% Obliquity pacing for sm90

printflg = 0;
%addMatlabpath_Branch;
%sm90_params

fileName = sprintf('SM90_Unforced_Model.txt');
filePath = '~/campgrp/rjballes/ModelRuns/sm90/Unforced/';

%sm90_readeemd
[Data,te,ye] = readSM90Data(fileName,filePath, 4);
I = Data(:,2);
%Mu = Data(:,3);
%Theta = Data(:,4);
[ndxTime, ecc, prec, ndxObl] = readHuybersInsolation;

ndxTime = ndxTime(10:end -1);
ndxObl = ndxObl(10:end -1);

allmodes = flipud(-sum(I,2));
%allmodes = flipud(-sum(I,2));
%allmodes = fliplr(-sum(Mu,2));
%allmodes = fliplr(sum(Theta,2));
nt1 = 2000;%findbin( 1990000, ndxTime, 1);
[maxs, mins] = extrema(-1.*allmodes(1:nt1));
%
tmax = ndxTime(maxs(2:end,1));
maxEO = maxs(2:end,2);
tmin = ndxTime(mins(1:end-1,1));
minEO = mins(1:end-1,2);
%
tmid = mean([tmin, tmax],2);
diffEO = maxEO - minEO;
midEO = mean([maxEO, minEO],2);
%
ind0 = find(diffEO > 1.1251*std(allmodes(1:nt1)));
%
Msize = 15;
figure
subplot(3, 1,1)
H1=plot(ndxTime(1:nt1)./10^6,-1.*allmodes(1:nt1), 'k');
set(H1,'LineWidth',1.5);
hold on;
H3=plot(tmax(ind0)./10^6, maxEO(ind0), 'k+');
H4=plot(tmin(ind0)./10^6, minEO(ind0), 'k+');
H5=plot(tmid(ind0)./10^6, midEO(ind0), 'r.', 'MarkerSize', Msize);
hold off;
set(gca,'YDir', 'reverse', 'FontWeight', 'bold', 'LineWidth', 1.5);
xlim([-0.1 2.1])
ylabel('Global Ice Mass');
%ylabel('Antarctic Ice Volume');
%ylabel('pCO2');;
text(-0.08, 0.88, '(a)','FontWeight','bold');
%
midObl = spline(ndxTime, ndxObl, tmid);
%
%
subplot(6, 1,3)
H2=plot(ndxTime(1:nt1)./10^6, ndxObl(1:nt1)/2/pi*360,'k');
set(H2,'LineWidth',1.5);
hold on;
plot(tmid(ind0)./10^6, midObl(ind0)/2/pi*360, 'r.', 'MarkerSize', Msize)
hold off;
set(gca, 'FontWeight', 'bold', 'LineWidth', 1.5);
ylim([22 24.5]);
xlim([-0.100, 2.1])
xlabel('Time (Myr ago)');
ylabel('Obliquity');
text(-0.08, 24.2, '(b)','FontWeight','bold');
%
%  Circle plot phases
%
[oblmaxs, oblmins] = extrema(ndxObl(1:nt1));
ng = length(ind0)
phases = zeros(ng, 1);
for ig = 1:ng
    ind1 = max(find(oblmaxs(:,1) < tmid(ind0(ig))./10^3));
    period = (oblmaxs(ind1+1,1)- oblmaxs(ind1,1));
    phases(ig) = 2*pi*(tmid(ind0(ig))/10^3 - oblmaxs(ind1,1))/period;
    if phases(ig)>pi
        phases(ig) = phases(ig)-2*pi;
    end
end
%
indEP = find(tmid(ind0)>1000000);
indLP = find(tmid(ind0)<1000000);
subplot(2, 2, 4)
[REP, avgPhaseEP, r99EP, dEP] = circleplot(-phases);
text(0.0, 0.8, '(c)','FontWeight','bold','Units','normalized');
%
%subplot(2, 2, 3)
%[RLP, avgPhaseLP, r99LP, dLP] = circleplot(phases(indLP));
%text(0.0, 0.8, '(d)','FontWeight','bold','Units','normalized');
%%
%% Print to file
%%
%if (printflg)
%    fpath = './';
%    fname0 = 'Fig5';
%    fname = strcat(fpath,fname0,'.eps')
%    print('-depsc', fname)
%    fname = strcat(fpath,fname0,'.pdf')
%    print( '-dpdf', fname)
%end

suptitle(sprintf('SM90 Oblituity Pacing for u = %g, p = %g',param(5),param(1))); 
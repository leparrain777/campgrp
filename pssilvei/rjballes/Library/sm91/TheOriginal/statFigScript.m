% nmodesModel must be defined, with time running forward as indices increase
%
% FigFileName1 through 4 must be defined
%
% FigSaveFlag must be set to 0 or 1, with 1 meaning save results to file, 0
% meaning don't
%
% distBetweenModes must be defined
%
% ModelName must be defined

DO18fileName = 'DO18EEMDwn.5it2000.txt';
DO18filePath = '/nfsbigdata1/campgrp/Data/Analysis/';

if (size(nmodesModel,1)<15)
    nmodesModel = nmodesModel';
end

[time,obl] = readHuybersObliquity;
lengthModel = size(nmodesModel,1);
start = lengthModel-(size(obl,1)-1);




PlotEEMDDataTrend(nmodesModel,distBetweenModes,7);
fig1 = gcf;




figure
%nmodesD = readData(DO18fileName,DO18filePath,12);
%nmodesD = nmodesD(:,2:12);
[time,obl] = readHuybersObliquity;
negnobl = (-1)*(obl-mean(obl))/std(obl);
Ktime = time*(1/1000);
Ktime = Ktime(end:-1:1);
KtimePlot = Ktime-2000;
nImfM = (nmodesModel(start:end,imfnumObl)-mean(nmodesModel(start:end,imfnumObl)))/std(nmodesModel(start:end,imfnumObl));
[cM,lagsM] = xcorr(nImfM,negnobl,20,'coeff');
[cstatM,k] = max(cM);
lagsstatM = lagsM(k);
subplot(3,1,1)
plot(KtimePlot,negnobl,'r');
hold on
plot(KtimePlot,nImfM);
hold off
title(['Normalized Negative Obliquity Against Normalized IMF ',num2str(imfnumObl-1),' of the ',ModelName,' Model'],'FontSize',18);
ylabel('Without Lags','FontSize',14);
set(gca,'XTick',[]);
set(gca,'XLim',[-2031 0]);
legend('Obliquity',['IMF ',num2str(imfnumObl-1)]);
subplot(3,1,2)
plot(KtimePlot(1:1000),negnobl(1:1000),'r');
hold on
plot(KtimePlot(1:1000)-lagsstatM,nImfM(1:1000));
hold off
ylabel('With Lags','FontSize',14);
set(gca,'XLim',[-2031 -1000]);
subplot(3,1,3)
plot(KtimePlot(1000:2001),negnobl(1000:2001),'r');
hold on
plot(KtimePlot(1000:2001)-lagsstatM,nImfM(1000:2001));
hold off
ylabel('With Lags','FontSize',14);
set(gca,'XLim',[-1031 0]);
fig2 = gcf;



figure
modelTime = KtimePlot(end-1500:end);
KtimePlot = Ktime(end-EccCutoff:end)-2000;
[time,ecc,prec,obl2] = readHuybersInsolation;
ecc = ecc(end-EccCutoff:end);
nmodesEccRead = readData('EEMDeccentricitywn.5it2000.txt','/nfsbigdata1/campgrp/rsmith49/Data/',12);
ecc = nmodesEccRead(end-EccCutoff:end,5)+nmodesEccRead(end-EccCutoff:end,6);
necc = (-1)*(ecc-mean(ecc))/std(ecc);
EccCombImf = nmodesModel(end-1500:end,imfnumEcc1)+nmodesModel(end-1500:end,imfnumEcc2);
normImfEcc = (EccCombImf-mean(EccCombImf))/std(EccCombImf);
[ecccstat,ecclags] = xcorr(normImfEcc(end-EccCutoff:end),necc,50,'coeff');
[EccStat,k] = max(ecccstat);
lagsstatM = ecclags(k);
subplot(2,1,1)
plot(KtimePlot,necc,'r');
hold on
plot(modelTime,normImfEcc);
hold off
title(['Normalized Modified Negative Eccentricity Against Normalized IMF ',num2str(imfnumEcc1-1),' and ',num2str(imfnumEcc2-1),' of the ',ModelName,' Model'],'FontSize',18);
ylabel('Without Lags','FontSize',14);
set(gca,'XTick',[]);
set(gca,'XLim',[-1271 0]);
legend('Modified Eccentricity',['IMF ',num2str(imfnumEcc1-1),' and ',num2str(imfnumEcc2-1)]);
subplot(2,1,2)
plot(KtimePlot,necc,'r');
hold on
plot(modelTime-lagsstatM,normImfEcc);
hold off
ylabel('With Lags','FontSize',14);
set(gca,'XLim',[-1271 0]);
fig3 = gcf;



figure
KtimePlot = Ktime-2000;
[age,sigma,DO18,benthic,planktic] = readHuybersDO18;
normDO18 = (DO18-mean(DO18))/std(DO18);
normModel = (nmodesModel(start:end,1)-mean(nmodesModel(start:end,1)))/std(nmodesModel(start:end,1));
plot(KtimePlot,normDO18,'r');
hold on
plot(KtimePlot,normModel);
hold off
title(['The Normalized ',ModelName,' Model Against the Normalized DO18 Record'],'FontSize',18);
legend('DO18 Record',[ModelName,' Model']);
fig4 = gcf;

figure
subplot(3,1,1)
plot(nmodesModel(start:end,1))
%plot(nmodesModel(end-EccCutoff:end,1))
hold on
plot(Meltings(:,1),nmodesModel(Meltings(:,1),1),'r.')
hold off
set(gca,'XTick',[]);
title('Obliquity Pacing with Huybers'' Ice-Volume Model','FontSize',18);
set(gca,'XLim',[0 2005]);
subplot(6,1,3)
%obl = ecc;
plot(obl)
hold on
plot(Meltings(:,1),obl(Meltings(:,1)),'r.')
hold off
set(gca,'XLim',[0 2005]);
subplot(2,2,3)
[R,avgPhase,r99,d] = circleplot(phis)
subplot(2,2,3)
phisL = phis(end-sum((Meltings(:,1)>(length(obl)-EccCutoff)))+1:end);
phisE = phis(1:sum((Meltings(:,1)<length(obl)-EccCutoff)));
%polar([0:.01:2*pi],linspace(1,1,size([0:.01:2*pi],2)))
%hold on
%polar(phis+pi/2,linspace(1,1,size(phis,1))','r.')
circleplot(phisE);
title('Early Pleistocene','FontSize',16);
subplot(2,2,4)
circleplot(phisL);
title('Late Pleistocene','FontSize',16);
%hold off
fig5 = gcf;


if (FigSaveFlag==1)
    print(fig1,'-dpdf',FigFileName1);
    print(fig2,'-dpdf',FigFileName2);
    print(fig3,'-dpdf',FigFileName3);
    print(fig4,'-dpdf',FigFileName4);
    print(fig5,'-dpdf',FigFileName5);
end

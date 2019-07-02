% nmodesModel must be defined, with time running forward as indices increase
%
% statFileName must be defined
%
% statFilePath must be defined
%
% ModelName must be defined
%
% FileSaveFlag must be set to 0 or 1, with 1 meaning save results to file, 0 
% meaning don't

DO18fileName = 'DO18EEMDwn.5it2000.txt';
DO18filePath = '/nfsbigdata1/campgrp/Data/Analysis/';

filePath = '/nfsbigdata1/campgrp/rsmith49/Data/';

if (size(nmodesModel,1)<25)
    nmodesModel = nmodesModel';
end

[time,obl] = readHuybersObliquity;
lengthModel = size(nmodesModel,1);
start = lengthModel-(size(obl,1)-1);

% Cross Correlation with imfnumObl and Obliquity signal (Early)
noblE = (-1)*(obl(1:oblCutoffE)-mean(obl(1:oblCutoffE)))/std(obl(1:oblCutoffE));
noblL = (-1)*(obl(end-oblCutoffL:end)-mean(obl(end-oblCutoffL:end)))/std(obl(end-oblCutoffL:end));
normImfOblE = (nmodesModel(start:oblCutoffE,imfnumObl)-mean(nmodesModel(start:oblCutoffE,imfnumObl)))/std(nmodesModel(start:oblCutoffE,imfnumObl));
normImfOblL = (nmodesModel(end-oblCutoffL:end,imfnumObl)-mean(nmodesModel(end-oblCutoffL:end,imfnumObl)))/std(nmodesModel(end-oblCutoffL:end,imfnumObl));
[oblcstatE,obllagsE] = xcorr(normImfOblE,noblE,20,'coeff');
[OblStatE,k] = max(oblcstatE)
OblLagE = obllagsE(k)
% Significance of Correlation
[corrsigOblE,xycorr] = isotestcorr(normImfOblE(1+mod(OblLagE+40,40):end),noblE(1:end-mod(OblLagE+40,40)),1000)
% Correlation with Obliquity (Late)
[oblcstatL,obllagsL] = xcorr(normImfOblL,noblL,20,'coeff');
[OblStatL,k] = max(oblcstatL)
OblLagL = obllagsL(k)
% Significance of Correlation
corrsigOblL = isotestcorr(normImfOblL(1+mod(OblLagL+40,40):end),noblL(1:end-mod(OblLagL+40,40)),1000)
%Percent change in Obliquity Correlation Stat
OblStatChange = (OblStatL-OblStatE)/OblStatE


% Cross Correlation with imfnumEcc1+imfnumEcc2 and modes 4 and 5 of the eemd of eccentricity
[time,ecc,prec,obl2] = readHuybersInsolation;
ecc = ecc(end-EccCutoff:end);
nmodesEccRead = readData('EEMDeccentricitywn.5it2000.txt',filePath,12);
ecc = nmodesEccRead(end-EccCutoff:end,5)+nmodesEccRead(end-EccCutoff:end,6);
necc = (-1)*(ecc-mean(ecc))/std(ecc);
EccCombImf = nmodesModel(end-EccCutoff:end,imfnumEcc1)+nmodesModel(end-EccCutoff:end,imfnumEcc2);
normImfEcc = (EccCombImf-mean(EccCombImf))/std(EccCombImf);
[ecccstat,ecclags] = xcorr(normImfEcc,necc,50,'coeff');
[EccStat,k] = max(ecccstat)
eccLag = ecclags(k)
% Significance of correlation
corrsigEcc = isotestcorr(normImfEcc(1+mod(eccLag+102,102):end),necc(1:end-mod(eccLag+102,102)),1000)

% Calculation of variance ratios in the IMF's
nmodesMEcc = nmodesModel(:,imfnumEcc1)+nmodesModel(:,imfnumEcc2);

%Tuning Variance Early: [1250,2000] Late: [0,500]
VarRatioTuning = var(nmodesModel(start:start+750,imfnumObl))/var(nmodesMEcc(end-500:end))

%Validation Variances (various late/late windows)
VarRatioStatOverall = var(nmodesModel(end-1250:end,imfnumObl))/var(nmodesMEcc(end-1250:end))
VarRatioStatNoMPT = var(nmodesModel(end-900:end,imfnumObl))/var(nmodesMEcc(end-900:end))
VarRatioStatL1 = var(nmodesModel(end-500:end,imfnumObl))/var(nmodesMEcc(end-500:end))
VarRatioStatL2 = var(nmodesModel(end-900:end-500,imfnumObl))/var(nmodesMEcc(end-900:end-500))
VarRatioStatL3 = var(nmodesModel(end-1250:end-900,imfnumObl))/var(nmodesMEcc(end-1250:end-900))


% Cross Correlation with DO18 Data, Mode 4, and Modes 5+6
nmodesD = readData(DO18fileName,DO18filePath,12);
normModel = (nmodesModel(start:end,1)-mean(nmodesModel(start:end,1)))/std(nmodesModel(start:end,1));
normMImf4 = (nmodesModel(start:end,imfnumObl)-mean(nmodesModel(start:end,imfnumObl)))/std(nmodesModel(start:end,imfnumObl));
multiModelModes = nmodesModel(start:end,imfnumEcc1)+nmodesModel(start:end,imfnumEcc2);
normMImf56 = (multiModelModes-mean(multiModelModes))/std(multiModelModes);
normDO18 = (nmodesD(:,2)-mean(nmodesD(:,2)))/std(nmodesD(:,2));
normDImf4 = (nmodesD(:,6)-mean(nmodesD(:,6)))/std(nmodesD(:,6));
multiDModes = nmodesD(:,7)+nmodesD(:,8);
normDImf56 = (multiDModes-mean(multiDModes))/std(multiDModes);

DCorrStatOverall = max(xcorr(normModel,normDO18,'coeff'))
DCorrStatImf4 = max(xcorr(normMImf4,normDImf4,'coeff'))
DCorrStatImf56 = max(xcorr(normMImf56,normDImf56,'coeff'))

% Rayleigh's R
%Vsmoothed = nmodesModel(end-EccCutoff:end,imfnumRayleighs(1));
%for i=2:size(imfnumRayleighs,1)
%    Vsmoothed = Vsmoothed+nmodesModel(end-EccCutoff:end,imfnumRayleighs(i));
%end
%obl = ecc;

Vsmoothed = nmodesModel(:,imfnumRayleighs(1));
for i=2:size(imfnumRayleighs,1)
    Vsmoothed = Vsmoothed+nmodesModel(:,imfnumRayleighs(i));
end
maxChange = std(Vsmoothed);
dir = 0;
change = 0;
count = 0;
n = 0;
tmp = zeros(size(Vsmoothed,1),2);
i = 2;
while (i<=size(Vsmoothed,1))
    dir = (Vsmoothed(i)<Vsmoothed(i-1));
    if (dir==1)
        change = change+(Vsmoothed(i-1)-Vsmoothed(i));
        count = count+1;
    else
        change = 0;
        count = 0;
    end
    if (change>maxChange)
        while ((dir==1)&&(i<size(Vsmoothed,1)))
            i = i+1;
            dir = (Vsmoothed(i)<Vsmoothed(i-1));
            if (dir==1)
                change = change+(Vsmoothed(i-1)-Vsmoothed(i));
                count = count+1;
            end
        end
        n = n+1;
        tmp(n,1) = i-floor(count/2);
        tmp(n,2) = change;
        change = 0;
        count = 0;
    end
i = i+1;
end
Meltings = zeros(n,2);
for i=1:n
    Meltings(i,1) = tmp(i,1);
    Meltings(i,2) = tmp(i,2);
end
phis = zeros(n,1);
[pks,locs] = findpeaks(obl);
closest = dsearchn(locs,Meltings(:,1));
for i=2:n
    if (locs(closest(i))>Meltings(i,1))
        closest(i) = closest(i)-1;
    end
end
Rayleighs = 0+0*1i;
for i=1:n
    if (closest(i)==size(locs,1))
            phis(i) = 2*pi*(Meltings(i,1)-locs(closest(i)))/(locs(closest(i))-locs(closest(i)-1));
    else
        phis(i) = 2*pi*(Meltings(i,1)-locs(closest(i)))/(locs(closest(i)+1)-locs(closest(i)));
    end
    Rayleighs = Rayleighs+exp(phis(i)*1i);
end
RayleighsR = abs(Rayleighs)/n



    fname = strcat(statFilePath,statFileName);
    fid = fopen(fname,'w');
    fprintf(fid,'%s Model Statistical Results\n\n',ModelName);
    fprintf(fid,'Obliquity Early Window: [%g,2000] Ka\n',2000-oblCutoffE);
    fprintf(fid,'Obliquity Correlation Early:                    %g\n',OblStatE);
    fprintf(fid,'With Significance:   %g at Lag %g\n',corrsigOblE,OblLagE);
    fprintf(fid,'Obliquity Late Window: [0,%g] Ka\n',oblCutoffL);
    fprintf(fid,'Obliquity Correlation Late:                     %g\n',OblStatL);
    fprintf(fid,'With Significance:   %g at Lag %g\n',corrsigOblL,OblLagL);
    fprintf(fid,'Percent Change in Obliquity Correlation:        %g\n',OblStatChange);
    fprintf(fid,'Eccentricity Window: [0,%g] Ka\n',EccCutoff);
    fprintf(fid,'Modified Eccentricity Correlation:              %g\n',EccStat);
    fprintf(fid,'With Significance:   %g at Lag %g\n',corrsigEcc,eccLag);
    fprintf(fid,'(TUNING) Early Var Window: [1250,2000] Ka | Late Var Window: [0,500] Ka\n');
    fprintf(fid,'Early Obl Var/Late Ecc Var:                     %g\n',VarRatioTuning);
	fprintf(fid,'(VALIDATIONS) Var Window: [0,1250] Ka\n');
    fprintf(fid,'Late Obl Var/Late Ecc Var:                      %g\n',VarRatioStatOverall);
	fprintf(fid,'(VALIDATIONS) Var Window: [0,900] Ka\n');
    fprintf(fid,'Late Obl Var/Late Ecc Var:                      %g\n',VarRatioStatNoMPT);
	fprintf(fid,'(VALIDATIONS) Var Window: [0,500] Ka\n');
    fprintf(fid,'Late Obl Var/Late Ecc Var:                      %g\n',VarRatioStatL1);
	fprintf(fid,'(VALIDATIONS) Var Window: [500,900] Ka\n');
    fprintf(fid,'Late Obl Var/Late Ecc Var:                      %g\n',VarRatioStatL2);
	fprintf(fid,'(VALIDATIONS) Var Window: [900,1250] Ka\n');
    fprintf(fid,'Late Obl Var/Late Ecc Var:                      %g\n',VarRatioStatL3);
    fprintf(fid,'Correlation with DO18 Data:                     %g\n',DCorrStatOverall);
    fprintf(fid,'Correlation with DO18 IMF 4:                    %g\n',DCorrStatImf4);
    fprintf(fid,'Correlation with DO18 IMFs 5 and 6:             %g\n',DCorrStatImf56);
    fprintf(fid,'Rayleigh''s R Corresponding to Obliquity Cycle: %g\n',RayleighsR);
    fclose(fid);

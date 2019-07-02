% This script plots the fundamental limmit cycle of the SM90 model

addpath(genpath('~/campgrp/rjballes/ModelRuns/sm91/'));

% Flags to control plot on what plane
IvMuflag = 1;
IvThetaflag = 0;
ThetavMuflag = 0;

% Reading in data and putting it into an array
fileID = fopen('SM91_unforced_Model.txt','r');
formatSpec = '%f %f %f';
sizeA = [3 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
A = A';

I = A(:,1);
Mu = A(:,2);
Theta = A(:,3);

if IvMuflag
   plot(Mu(350:460),I(350:460),'-')
   %xlabel('co2 concentration')
   %ylabel('global ice mass')
end %if

if IvThetaflag
   plot(Theta(350:460),I(350:460),'-')
end %if

if ThetavMuflag
   plot(Mu(350:460),Theta(350:460),'-')
end %if
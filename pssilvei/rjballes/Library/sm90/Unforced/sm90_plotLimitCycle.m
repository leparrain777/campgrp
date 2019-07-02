% This script plots the fundamental limmit cycle of the SM90 model

addpath(genpath('~/Lib/sm90Runs/Unforced'));

% Flags to control plot on what plane
IvMuflag = 1;
IvThetaflag = 0;
ThetavMuflag = 0;

% Reading in data and putting it into an array
fileID = fopen('run4SM90_300.txt','r');
formatSpec = '%f %f %f';
sizeA = [3 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
A = A';

I = A(:,1);
Mu = A(:,2);
Theta = A(:,3);

if IvMuflag
   plot(Mu(370:470),I(370:470),'k-')
   %xlabel('co2 concentration')
   %ylabel('global ice mass')
end %if

if IvThetaflag
   plot(Theta(320:420),I(320:420),'k-')
end %if

if ThetavMuflag
   plot(Mu(320:420),Theta(320:420),'k-')
end %if
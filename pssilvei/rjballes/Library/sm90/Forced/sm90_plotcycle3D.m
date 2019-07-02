function sm90_plotcycle(runID,descr,cycleNum1,cycleNum2)

% This function producs a plot of a single cycle of the forced model
% with the unforced limit cycle and fixed point on the I vs Mu phase plane.
% Input:
%   runID := the number of the model run
%   descr := a string of the forcing used in the model run
%            (i.e., 'insolLaskar' or 'insolHuybersIntegrated')
%   cycleNum1,cycleNum2 := the span of the number of the full cycle(s) interested in
%
% Example:  sm90_plotcycle(5,'insolLaskar',5);

fileName = sprintf('SM90_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';
[data,fullMat,iceMat] = sm90_find_cycles(fileName,filePath);  % May have to edit this script to adjust for size of data file

t = data(:,1);
I = data(:,2)./1.3;
Mu = data(:,3)./26.3;
Theta = data(:,4)./0.7;

tmin_co2 = fullMat(:,1);
tmax_co2 = fullMat(:,2);


%figure;
hold on;
for cycleNum=cycleNum1:cycleNum2
   
   t1 = tmin_co2(cycleNum);
   t2 = tmax_co2(cycleNum);
   t3 = tmin_co2(cycleNum+1);
   
   strmin1 = [num2str(10*t(t1)),'(ka)'];
   strmax = [num2str(10*t(t2)),'(ka)'];
   strmin2 = [num2str(10*t(t3)),'(ka)'];
   
   % May have to edit on how variables should be plotted to what axis
   plot3(Mu(t1:t2),Theta(t1:t2),I(t1:t2),'r-','LineWidth',1.5)
   plot3(Mu(t2:t3),Theta(t2:t3),I(t2:t3),'b-','LineWidth',1.5)
   %plot(Mu(tmin_co2(cycleNum):tmin_co2(cycleNum+1)),Theta(tmin_co2(cycleNum):tmin_co2(cycleNum+1)),'r-','LineWidth',1.5)
%sm90_plotLimitCycle
%plot(0,0,'k.','MarkerSize',20)
   
   %txt1 = 't = 
   %t(tmin_co2(cycleNum))
   %t(tmax_co2(cycleNum))
   %t(tmin_co2(cycleNum+1))
   
   text(Mu(t1),Theta(t1),I(t1),strmin1);
   text(Mu(t2),Theta(t2),I(t2),strmax);
   text(Mu(t3),Theta(t3),I(t3),strmin2);
   
end %for

plot(0,0,'k.','MarkerSize',20)
%hold off;
%title(strcat('SM90,',descr));
%xlabel('co2 concentration (Mu)');
%ylabel('global ice mass (I)');


end
% This script produces various plots in 3D phase space, but mostly looking at projections,
% where a sample of points are colored based on the sign of ydot and/or zdot,
% as well as sample trajectories (unforced and forced) colored based on the sign of the 
% equations.


% General flags for plots
%colorunforcedFlag = 1;
%colorforcedFlag = 0;

ydotFlag = 1;
zdotFlag = 1;


% Reading in data and putting it into an array for unforced run
fileName = sprintf('SM91_unforced_Model.txt');
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/';

[A,te_unfor,ye_unfor] = readSM91Data(fileName,filePath,4);

% Separating the variables
t = A(:,1);
I_unfor = A(:,2)./2;
Mu_unfor = A(:,3)./52.5;
Theta_unfor = A(:,4)./0.9;

ye_unfor(:,1) = ye_unfor(:,1)./2;
ye_unfor(:,2) = ye_unfor(:,2)./52.5;
ye_unfor(:,3) = ye_unfor(:,3)./0.9;


% Reading in data and putting it into an array for forced run
% and finding intervals for full cycles

% Identifies runs by the forcing used
runID = 10;
cycleNum = 32;  %Number of cycle want to plot
descr = 'insolHuybersIntegrated';
%descr = 'insolLaskar';
%descr = 'solsticeLaskar';

fileName = sprintf('SM91_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm91/';

[data,fullMat,iceMat] = sm91_find_cycles(fileName,filePath);

% Separating the variables
t = data(:,1);
I_for = data(:,2)./2;
Mu_for = data(:,3)./52.5;
Theta_for = data(:,4)./0.9;

tmin_co2 = fullMat(:,1);
tmax_co2 = fullMat(:,2);


% Sorts to color by sign of ydot/zdot for unforced/forced model output
redt_mu_unfor = [];
bluet_mu_unfor = [];
redt_theta_unfor = [];
bluet_theta_unfor = [];
redt_theta_for = [];
bluet_theta_for = [];
p = size(Mu_unfor,1);
for i=2:p
   if -Theta_unfor(i) + 1.3*Mu_unfor(i) - 0.6.*Mu_unfor(i).^2 - Mu_unfor(i).^3 > 0
      redt_mu_unfor = [redt_mu_unfor i];
   elseif -Theta_unfor(i) + 1.3*Mu_unfor(i) - 0.6.*Mu_unfor(i).^2 - Mu_unfor(i).^3 < 0
      bluet_mu_unfor = [bluet_mu_unfor i];
   end %if
   
   if -2.5.*(I_unfor(i)+Theta_unfor(i)) > 0
      redt_theta_unfor = [redt_theta_unfor i];
   elseif -2.5.*(I_unfor(i)+Theta_unfor(i)) < 0
      bluet_theta_unfor = [bluet_theta_unfor i];
   end %if
   
   if -2.5.*(I_for(i)+Theta_for(i)) > 0
      redt_theta_for = [redt_theta_for i];
   elseif -2.5.*(I_for(i)+Theta_for(i)) < 0
      bluet_theta_for = [bluet_theta_for i];
   end %if
   
end %for


% Phase space coloring based on the sign of ydot (red-pos.; blue-neg.)
if ydotFlag
   
   % Phase space coloring based on sign of ydot
   red_ydot = [];
   blue_ydot = [];
   zero_ydot = [];
   p = size(Mu_unfor,1);
   X = [-5:1:5];
   Y = [-5:1:5];
   Z = [-5:1:5];
   for h = X
      for i = Y
         for j = Z
            if -j + 1.3*i - 0.6.*i.^2 - i.^3 > 0
               red_ydot = [red_ydot; h i j];
            elseif -j + 1.3*i - 0.6.*i.^2 - i.^3 < 0
               blue_ydot = [blue_ydot; h i j];
            elseif -j + 1.3*i - 0.6.*i.^2 - i.^3 == 0
               zero_ydot = [zero_ydot; h i j];
            end %if
         end %for
      end %for
   end %for

   fig1 = figure;
   subplot(1,3,1)  %Mu-Theta Projection
   hold on;
   for i = 1:length(red_ydot)
      %x = redp(i,:);
      plot3(red_ydot(i,2),red_ydot(i,3),red_ydot(i,1),'r.','MarkerSize',10)
   end %for

   for j = 1:length(blue_ydot)
      %[x y z] = bluep(i,:);
      plot3(blue_ydot(j,2),blue_ydot(j,3),blue_ydot(j,1),'b.','MarkerSize',10)
   end %for

   for h = 1:length(zero_ydot)
      hold on;
      %[x y z] = zerop(i,:);
      plot3(zero_ydot(h,2),zero_ydot(h,3),zero_ydot(h,1),'k.','MarkerSize',10)
   end %for
   
   sm91_plotcycle(runID,descr,cycleNum,cycleNum)
   
   syms x y z
   h1 = fimplicit3(-z + 1.3*y - 0.6.*y.^2 - y.^3);
   h1.FaceAlpha = 0.25;
   ylabel('Theta')
   xlabel('Mu')
   zlabel('I')
   title('Mu-Theta Projection')
   %view(0,90)
   xlim([-3 4])
   ylim([-3 3])
   
   subplot(1,3,2)  %I-Theta Projection
   hold on;
   t1 = tmin_co2(cycleNum);
   t2 = tmax_co2(cycleNum);
   t3 = tmin_co2(cycleNum+1);
   
   % May have to edit on how variables should be plotted to what axis
   plot3(I_for(t1:t2),Theta_for(t1:t2),Mu_for(t1:t2),'r-','LineWidth',1.5)
   plot3(I_for(t2:t3),Theta_for(t2:t3),Mu_for(t2:t3),'b-','LineWidth',1.5)
   plot(0,0,'k.','MarkerSize',20)
   
   syms x y z
   h3 = fimplicit3(-2.5*(x+z));
   h3.FaceAlpha = 0.5;
   ylabel('Theta')
   zlabel('Mu')
   xlabel('I')
   title('I-Theta Projection')
   %view(20,20)
   xlim([-3 3])
   ylim([-3 3])
   
   subplot(1,3,3)  %I-Mu Projection
   hold on;
   t1 = tmin_co2(cycleNum);
   t2 = tmax_co2(cycleNum);
   t3 = tmin_co2(cycleNum+1);
   
   % May have to edit on how variables should be plotted to what axis
   plot3(Mu_for(t1:t2),I_for(t1:t2),Theta_for(t1:t2),'r-','LineWidth',1.5)
   plot3(Mu_for(t2:t3),I_for(t2:t3),Theta_for(t2:t3),'b-','LineWidth',1.5)
   plot(0,0,'k.','MarkerSize',20)
   
   %syms x y z
   %h2 = fimplicit3(-x-y-0.2*z);
   %h2.FaceAlpha = 0.5;
   zlabel('Theta')
   xlabel('Mu')
   ylabel('I')
   title('I-Mu Projection')
   
   suptitle('SM91,Phase Space Coloring Based on YDot (red-pos.; blue-neg.)') 
   
end %if


% Phase space coloring based on the sign of zdot (red-pos.; blue-neg.)
if zdotFlag
   
   % Phase space coloring based on sign of zdot
   red_zdot = [];
   blue_zdot = [];
   zero_zdot = [];
   p = size(Mu_unfor,1);
   X = [-5:1:5];
   Y = [-5:1:5];
   Z = [-5:1:5];
   for h = X
      for i = Y
         for j = Z
            if -2.5*(h+j) > 0
               red_zdot = [red_zdot; h i j];
            elseif -2.5*(h+j) < 0
               blue_zdot = [blue_zdot; h i j];
            elseif -2.5*(h+j) == 0
               zero_zdot = [zero_zdot; h i j];
            end %if
         end %for
      end %for
   end %for
   
   fig2 = figure;
   subplot(1,3,1)  %Mu-Theta Projection
   plottime = [tmin_co2(cycleNum)];
   i = tmin_co2(cycleNum);
   hold on;
   while i < tmin_co2(cycleNum+1)
      hold on;
      if ismember(i,redt_theta_for)
         while ismember(i,redt_theta_for)
            plottime = [plottime (i-1)];
            i = i+1;
         end %while
         
         plot3(Mu_for(plottime+1),Theta_for(plottime+1),I_for(plottime+1),'r-')
         plottime = [i-2];
      else
         while ismember(i,bluet_theta_for)
            if i > tmin_co2(cycleNum+1)
               break
            end %if
            plottime = [plottime (i-1)];
            i = i+1;
         end %while
         
         plot3(Mu_for(plottime+1),Theta_for(plottime+1),I_for(plottime+1),'b-')
         plottime = [i-2];
      end %if
   end %while
   plot(0,0,'k.','MarkerSize',20)
   
   syms x y z
   h1 = fimplicit3(-z + 1.3*y - 0.6.*y.^2 - y.^3);
   h1.FaceAlpha = 0.25;
   ylabel('Theta')
   xlabel('Mu')
   zlabel('I')
   title('Mu-Theta Projection')
   %view(0,90)
   xlim([-3 4])
   ylim([-3 3])
   
   subplot(1,3,2)  %I-Theta Projection
   hold on;
   for i = 1:length(red_zdot)
      plot3(red_zdot(i,1),red_zdot(i,3),red_zdot(i,2),'r.','MarkerSize',10)
   end %for

   for j = 1:length(blue_zdot)
      plot3(blue_zdot(j,1),blue_zdot(j,3),blue_zdot(j,2),'b.','MarkerSize',10)
   end %for

   for h = 1:length(zero_zdot)
      plot3(zero_zdot(h,1),zero_zdot(h,3),zero_zdot(h,2),'k.','MarkerSize',10)
   end %for
   
   plottime = [tmin_co2(cycleNum)];
   i = tmin_co2(cycleNum);
   %figure;
   hold on;
   while i < tmin_co2(cycleNum+1)
      hold on;
      if ismember(i,redt_theta_for)
         while ismember(i,redt_theta_for)
            plottime = [plottime (i-1)];
            i = i+1;
         end %while
         
         plot3(I_for(plottime+1),Theta_for(plottime+1),Mu_for(plottime+1),'r-')
         plottime = [i-2];
      else
         while ismember(i,bluet_theta_for)
            if i > tmin_co2(cycleNum+1)
               break
            end %if
            plottime = [plottime (i-1)];
            i = i+1;
         end %while
         
         plot3(I_for(plottime+1),Theta_for(plottime+1),Mu_for(plottime+1),'b-')
         plottime = [i-2];
      end %if
   end %while
   plot(0,0,'k.','MarkerSize',20)
   
   syms x y z
   h3 = fimplicit3(-2.5*(x+z));
   h3.FaceAlpha = 0.5;
   ylabel('Theta')
   zlabel('Mu')
   xlabel('I')
   title('I-Theta Projection')
   %view(0,90)
   xlim([-3 3])
   ylim([-3 3])
   
   subplot(1,3,3)  %I-Mu Projection
   plottime = [tmin_co2(cycleNum)];
   i = tmin_co2(cycleNum);
   hold on;
   while i < tmin_co2(cycleNum+1)
      hold on;
      if ismember(i,redt_theta_for)
         while ismember(i,redt_theta_for)
            plottime = [plottime (i-1)];
            i = i+1;
         end %while
         
         plot3(Mu_for(plottime+1),I_for(plottime+1),Theta_for(plottime+1),'r-')
         plottime = [i-2];
      else
         while ismember(i,bluet_theta_for)
            if i > tmin_co2(cycleNum+1)
               break
            end %if
            plottime = [plottime (i-1)];
            i = i+1;
         end %while
         
         plot3(Mu_for(plottime+1),I_for(plottime+1),Theta_for(plottime+1),'b-')
         plottime = [i-2];
      end %if
   end %while
   plot(0,0,'k.','MarkerSize',20)
   
   zlabel('Theta')
   xlabel('Mu')
   ylabel('I')
   title('I-Mu Projection')
   %view(0,90)
   
   suptitle('SM91,Phase Space Coloring Based on ZDot (red-pos.; blue-neg.)')
   
end %if
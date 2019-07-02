% This script records times of max/min CO2 with its state at times,
% times of max/min ice mass with state values,
% plots the cycles of the forced SM90 model

% General flags for plots
colorphaseFlag = 0;
colorunforcedFlag = 0;
colorforcedFlag = 0;

ydotFlag = 0;
zdotFlag = 0;

fileName = sprintf('SM90_Unforced_Model.txt');
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Unforced/';

% Reading in data and putting it into an array for unforced run
[A,te_unfor,ye_unfor] = readSM90Data(fileName,filePath,4);

% Separating the variables
t = A(:,1);
I_unfor = A(:,2)./1.3;
Mu_unfor = A(:,3)./26.3;
%normMu = (Mu-mean(Mu))/(std(Mu));
Theta_unfor = A(:,4)./0.7;

ye_unfor(:,1) = ye_unfor(:,1)./1.3;
ye_unfor(:,2) = ye_unfor(:,2)./26.3;
ye_unfor(:,3) = ye_unfor(:,3)./0.7;


% Reading in data and putting it into an array for forced run
% and finding intervals for full cycles

% Identifies runs by the forcing used
runID = 12;
descr = 'insolHuybersIntegrated';
%descr = 'insolLaskar';
%descr = 'solsticeLaskar';

fileName = sprintf('SM90_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';

[data,fullMat,iceMat] = sm90_find_cycles(fileName,filePath);
%[A_for,te_for,ye_for] = readSM90Data(fileName,filePath,4);

% Separating the variables
t = data(:,1);
I_for = data(:,2)./1.3;
Mu_for = data(:,3)./26.3;
%normMu_for = (Mu_for-mean(Mu_for))/(std(Mu_for));
Theta_for = data(:,4)./0.7;

tmin_co2 = fullMat(:,1);
tmax_co2 = fullMat(:,2);


% Sorts to color times of warming/cooling for unforced model output
%if ye_unfor(1,2) < ye_unfor(2,2)
%   redt_mu_unfor = te_unfor(1:2:end);  %times of start of full cycle, or min co2
%   bluet_mu_unfor = te_unfor(2:2:end);  %times of switch of cycle, max co2
%else
%   redt_mu_unfor = [];  %times of start of full cycle, or min co2
%   bluet_mu_unfor = [];  %times of switch of cycle, max co2
%end %if

redt_mu_unfor = [];
bluet_mu_unfor = [];
redt_theta_unfor = [];
bluet_theta_unfor = [];
p = size(Mu_unfor,1);
for i=2:p
   %if Mu_unfor(i)-Mu_unfor(i-1) > 0
   if -Theta_unfor(i) + 0.9*Mu_unfor(i) + Theta_unfor(i).^2 - 0.5.*Mu_unfor(i).*Theta_unfor(i) - Mu_unfor(i).*Theta_unfor(i).^2 > 0
      redt_mu_unfor = [redt_mu_unfor i];
   %elseif Mu_unfor(i)-Mu_unfor(i-1) < 0
   elseif -Theta_unfor(i) + 0.9*Mu_unfor(i) + Theta_unfor(i).^2 - 0.5.*Mu_unfor(i).*Theta_unfor(i) - Mu_unfor(i).*Theta_unfor(i).^2 < 0
      bluet_mu_unfor = [bluet_mu_unfor i];
   end %if
   
   %if Theta_unfor(i)-Theta_unfor(i-1) > 0
   if -2.5.*(I_unfor(i)+Theta_unfor(i)) > 0
      redt_theta_unfor = [redt_theta_unfor i];
   %elseif Theta_unfor(i)-Theta_unfor(i-1) < 0
   elseif -2.5.*(I_unfor(i)+Theta_unfor(i)) < 0
      bluet_theta_unfor = [bluet_theta_unfor i];
   end %if
end %for


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
         if -j + 0.9*i + j.^2 - 0.5.*i.*j - i.*j.^2 > 0
            red_ydot = [red_ydot; h i j];
         elseif -j + 0.9*i + j.^2 - 0.5.*i.*j - i.*j.^2 < 0
            blue_ydot = [blue_ydot; h i j];
         elseif -j + 0.9*i + j.^2 - 0.5.*i.*j - i.*j.^2 == 0
            zero_ydot = [zero_ydot; h i j];
         end %if
      end %for
   end %for
end %for


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


if colorphaseFlag

   if ydotFlag
      fig1 = figure;
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
      %hold off;
   end %if
   
   if zdotFlag
      fig2 = figure;
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
      %hold off;
      xlabel('I')
      ylabel('Theta')
      zlabel('Mu')
   end %if
   
end %if


if colorunforcedFlag
   % Emphasizes Mu-Theta Projection
   plottime = [0];
   i = 2;
   newi = 1;
   %figure;
   hold on;
   while i < p
      hold on;
      %if ismember(i,redt_theta_unfor)
      %   while ismember(i,redt_theta_unfor)
      %if ismember(i,redt_mu_unfor)
         %while ismember(i,redt_mu_unfor)
            plottime = [plottime (i-1)];
            i = i+1;
         end %while
         
         plot3(Mu_unfor(plottime+1),Theta_unfor(plottime+1),I_unfor(plottime+1),'r-')
         %plot3(Mu(plottime+1)./52.5,Theta(plottime+1)./0.9,I(plottime+1)./2,'r-')
         plottime = [i-2];
      else
         %while ismember(i,bluet_theta_unfor)
         while ismember(i,bluet_mu_unfor)
            plottime = [plottime (i-1)];
            i = i+1;
         end %while
         
         plot3(Mu_unfor(plottime+1),Theta_unfor(plottime+1),I_unfor(plottime+1),'b-')
         %plot3(Mu(plottime+1)./52.5,Theta(plottime+1)./0.9,I(plottime+1)./2,'b-')
         plottime = [i-2];
      end %if
   end %while
   %
   syms x y z
   h1 = fimplicit3(-z+0.9.*y+z.^2-0.5.*y.*z-y.*z.^2);
   %h1 = fimplicit3(-z + 1.3*y - 0.6*y^2 - y^3);
   %h2 = fimplicit3(-x-y-0.2*z);
   %h3 = fimplicit3(-2.5*(x+z));
   h1.FaceAlpha = 0.5;
   %h2.FaceAlpha = 0.5;
   %h3.FaceAlpha = 0.5;
   ylabel('Theta')
   xlabel('Mu')
   zlabel('I')
   title('Phase Space Coloring Based on YDot (red-pos.; blue-neg.); Trajectory Based on ZDot')
   %title('Phase Space Coloring Based on YDot (red-pos.; blue-neg.); Trajectory Based on YDot')
   %%view(0,90)
   
   
   % Emphasizes I-Theta Projection
   %plottime = [0];
   %i = 2;
   %newi = 1;
   %hold on;
   %while i<p
   %   hold on;
   %   if ismember(i,redt_theta)
   %      while ismember(i,redt_theta)
   %         plottime = [plottime (i-1)];
   %         i = i+1;
   %      end %while
   %      
   %      plot3(I(plottime+1),Theta(plottime+1),Mu(plottime+1),'r-')
   %      %plot3(Mu(plottime+1)./52.5,Theta(plottime+1)./0.9,I(plottime+1)./2,'r-')
   %      plottime = [i-2];
   %   else
   %      while ismember(i,bluet_theta)
   %         plottime = [plottime (i-1)];
   %         i = i+1;
   %      end %while
   %      
   %      plot3(I(plottime+1),Theta(plottime+1),Mu(plottime+1),'b-')
   %      %plot3(Mu(plottime+1)./52.5,Theta(plottime+1)./0.9,I(plottime+1)./2,'b-')
   %      plottime = [i-2];
   %   end %if
   %end %while
   
   %syms x y z
   %h3 = fimplicit3(-2.5*(x+z));
   %h3.FaceAlpha = 0.5;
   %ylabel('Theta')
   %xlabel('I')
   %zlabel('Mu')
   %title('Phase Space Coloring Based on YDot (red-pos.; blue-neg.)')
   %%view(0,90)
   
end %if


if colorforcedFlag

% Sorts to color times of warming/cooling for forced model output
%redt_mu_for = [];
%bluet_mu_for = [];
%redt_theta_for = [];
%bluet_theta_for = [];
%p = size(Mu_for,1);
%for i=2:p
%   if Mu_for(i)-Mu_for(i-1) > 0
%      redt_mu = [redt_mu i];
%   elseif Mu_for(i)-Mu_for(i-1) < 0
%      bluet_mu = [bluet_mu i];
%   end %if
   
%   if Theta_for(i)-Theta_for(i-1) > 0
%      redt_theta = [redt_theta i];
%    elseif Theta_for(i)-Theta_for(i-1) < 0
%      bluet_theta = [bluet_theta i];
%   end %if
%end %for
   
   sm90_plotcycle(11,descr,2,2)
   
   %syms x y z
   %h1 = fimplicit3(-z+0.9.*y+z.^2-0.5.*y.*z-y.*z.^2);
   %h1.FaceAlpha = 0.5;
   ylabel('Theta')
   xlabel('Mu')
   zlabel('I')
   title('Phase Space Coloring Based on YDot (red-pos.; blue-neg.)')
   %%%view(0,90)
   
end %if


%%---Scratch Work---%%

% Sorts to color times of positive/negative zdot for forced model output
%redt_mu_for = [];
%bluet_mu_for = [];
%redt_theta_for = [];
%bluet_theta_for = [];
%p = size(Mu(tmin_co2(cycleNum1):tmin_co2(cycleNum2)),1);
%for i=tmin_co2(cycleNum1):tmin_co2(cycleNum2)
%   
%   %if Theta_unfor(i)-Theta_unfor(i-1) > 0
%   if -2.5.*(I(i)+Theta(i)) > 0
%      redt_theta_for = [redt_theta_for i];
%   %elseif Theta_unfor(i)-Theta_unfor(i-1) < 0
%   elseif -2.5.*(I(i)+Theta(i)) < 0
%      bluet_theta_for = [bluet_theta_for i];
%   end %if
%   
%end %for

%size(redt_theta_for)
%size(bluet_theta_for)

%figure;
%hold on;
%for cycleNum=cycleNum1:cycleNum2
%   if opt
%      plottime = [tmin_co2(cycleNum1)];
%      i = tmin_co2(cycleNum1);
%      while i < tmin_co2(cycleNum2)
%         hold on;
%         if ismember(i,redt_theta_for)
%            while ismember(i,redt_theta_for)
%               plottime = [plottime (i-1)];
%               i = i+1;
%            end %while
%         
%            plot3(Mu(plottime+1),Theta(plottime+1),I(plottime+1),'r-')
%            plottime = [i-2];
%         else
%            while ismember(i,bluet_theta_for)
%               plottime = [plottime (i-1)];
%               i = i+1;
%            end %while
%         
%            plot3(Mu(plottime+1),Theta(plottime+1),I(plottime+1),'b-')
%            plottime = [i-2];
%         end %if
%      end %while
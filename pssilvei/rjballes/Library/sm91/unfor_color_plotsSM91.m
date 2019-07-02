%Raymart Ballesteros
%22 July 2018

% This script produces various plots of the three variables without forcing
% This script needs access to the following functions:
%   runSM91.txt

% These flags control what plots to print
plot3Dflag = 0;  %control plot of solutions in 3D space
plot2Dflag = 0;  %control plot of solutions in 2D space
timeflag = 0;  %control temporal plot of solutions
tectflag = 0;  %control plot of tectonic solutions

% Reading in data and putting it into an array
fileID = fopen('runSM91_250.txt','r');
formatSpec = '%f %f %f';
sizex = [3 Inf];
x = fscanf(fileID,formatSpec,sizex);
fclose(fileID);
x = x';

tspan = [0:0.1:250];
I = flipud(x(:,1));
Mu = flipud(x(:,2));
theta = flipud(x(:,3));
k = size(x,1);

% The following plots are for the solutions without the tectonic solution
% Plots temporal plots of variables
if timeflag
   figure;
   subplot(3,1,1)
   plot(fliplr(tspan),I,'-')
   set(gca,'xdir','reverse')
   ylabel('global ice mass')
   subplot(3,1,2)
   plot(fliplr(tspan),Mu,'-')
   set(gca,'xdir','reverse')
   ylabel('CO2 concentration')
   subplot(3,1,3)
   plot(fliplr(tspan),theta,'-')
   set(gca,'xdir','reverse')
   ylabel('global mean ocean temp')
   xlabel('time (10 ka)')
   
   % Saves temporal plots
   print(gcf,'-djpeg','time_plotsSM91_250')
   
end %if

%3-D plot of the solutions
if plot3Dflag
   figure;
   hold on;
   for i=1:k-1
      if i == 1
         plot3(I(i),Mu(i),theta(i),'o')
      else 
         if Mu(i+1)-Mu(i) > 0
         %if theta(i+1)-theta(i) > 0
            plot3(I(i),Mu(i),theta(i),'ro')
         elseif Mu(i+1)-Mu(i) < 0
         %elseif theta(i+1)-theta(i) < 0
            plot3(I(i),Mu(i),theta(i),'bo')
         else
            plot3(I(i),Mu(i),theta(i),'o')
         end %if
      end%if
   end %for
   title('Change of atmospheric CO2')
   %title('Change of ocean temperature')
   xlabel('I')
   ylabel('Mu')
   zlabel('theta')
   hold off;

   %Save the 3-D plot figure to a file
   %print(gcf, '-djpeg', 'colorCO2_sols3D_SM91');
   %print(gcf, '-djpeg', 'colorOcean_sols3D_SM91');
   savefig('colorCO2_sols3D_SM91.fig')

end %if

%Projections on one of the variables; 2-D plots
if plot2Dflag
   redt = [];
   bluet = [];
   p = size(Mu,1);
   for i=2:p
      if Mu(i)-Mu(i-1) > 0
      %if theta(i)-theta(i-1) >0
         redt = [redt i];
      elseif Mu(i)-Mu(i-1) < 0
      %elseif theta(i)-theta(i-1) < 0
         bluet = [bluet i];
      end %if
   end %for

   figure;
   % Plot of I vs Mu
   %subplot(3,1,1)
   hold on;
   for i=1:p
      if ismember(i,redt)
         plot(Mu(i), I(i),'ro')
      elseif ismember(i,bluet)
         plot(Mu(i),I(i),'bo')
      else
         plot(Mu(i),I(i),'o')
      end %if
   end %for
   %title('change of CO2')
   title('change of ocean temp')
   xlabel('CO2 concentration')
   ylabel('Global Ice Mass')
   hold off;
   
   %Save the I vs Mu figure to a file
   %print(gcf, '-djpeg', 'colorCO2_IvMu_SM91');
   %print(gcf, '-djpeg', 'colorOcean_IvMu_SM91');
   %savefig('sols2D_SM90.fig')

   % Plot of I vs Theta
   %subplot(3,1,2)
   figure;
   hold on;
   for i=1:p
      if ismember(i,redt)
         plot(theta(i), I(i),'ro')
      elseif ismember(i,bluet)
         plot(theta(i),I(i),'bo')
      else
         plot(theta(i),I(i),'o')
      end %if
   end %for
   title('change of CO2')
   %title('change of ocean temp')
   xlabel('Global Mean Ocean Temp.')
   ylabel('Global Ice Mass')
   hold off;

   %Save the I vs Theta figure to a file
   print(gcf, '-djpeg', 'colorCO2_IvTheta_SM91');
   %print(gcf, '-djpeg', 'colorOcean_IvTheta_SM91');
   %savefig('sols2D_SM90.fig')

   % Plot of Mu vs Theta
   %subplot(3,1,3)
   figure;
   hold on;
   for i=1:p
      if ismember(i,redt)
         plot(theta(i), Mu(i),'ro')
      elseif ismember(i,bluet)
         plot(theta(i),Mu(i),'bo')
      else
         plot(theta(i),Mu(i),'o')
      end %if
   end %for
   title('change of CO2')
   %title('change of ocean temp')
   ylabel('CO2 concentration')
   xlabel('Global Mean Ocean Temp.')
   hold off;
   
   %Save the Mu vs Theta figure to a file
   print(gcf, '-djpeg', 'colorCO2_MuvTheta_SM91');
   %print(gcf, '-djpeg', 'colorOcean_MuvTheta_SM91');
   %savefig('sols2D_SM90.fig')

end %if

%The following plots are for the solutions with the tectonic solution
if tectflag
   %3-D plot of the solutions
   figure;
   I = xtect(:,1);
   Mu = xtect(:,2);
   theta = xtect(:,3);
   plot3(I,Mu,theta,'-')

   %Save the 3-D plot figure to a file
   print(gcf, '-dpdf', 'sols3D_tect_SM90_250');
   %savefig('sols3D_tect_SM90.fig')

   %Projections on one of the variables; 2-D plots
   figure;
   subplot(3,1,1)
   plot(I,Mu,'-')
   subplot(3,1,2)
   plot(I,theta,'-')
   subplot(3,1,3)
   plot(Mu,theta,'-')

   %Save the projections figure to a file
   print(gcf, '-dpdf', 'sols2D_tect_SM90_250');
   %savefig('sols2D_tect_SM90.fig')
end %if
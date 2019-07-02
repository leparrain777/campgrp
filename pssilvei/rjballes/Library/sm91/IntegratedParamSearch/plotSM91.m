% Plots the results of Saltzman and Maasch's 1991 climate model.
%
% Date: 17 August 2014
% Author: Andrew Gallatin

% plot the parameters 
figure;
plot(parT,R,parT,S,'LineWidth',2.0)

% Save the parameters figure to a file IF printFlag == 1
if printFlag == 1
   paramName = strcat('/nfsbigdata1/campgrp/agallati/sm91/Polished/Plot/params',num2str(runID));
   print(gcf,'-dpdf',paramName);
end %if

% Plot the solutions
figure;
subplot(3,1,1)
plot(t,I,'LineWidth',2.0)
axis([0 500 0 10])
subplot(3,1,2)
plot(t,Mu,'LineWidth',2.0)
axis([0 500 150 450])
subplot(3,1,3)
plot(t,Theta,'LineWidth',2.0)
axis([0 500 3 7])

% Save the solutions figure to a file IF printFlag == 1
if printFlag == 1
   plotName = strcat('/nfsbigdata1/campgrp/agallati/sm91/Polished/Plot/sm91plot',num2str(runID));
   print(gcf,'-dpdf', plotName);
end %if
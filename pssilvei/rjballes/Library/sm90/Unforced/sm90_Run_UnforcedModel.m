% Run this script in matlab to produce the simulation and graphs 
% for the Saltzman 90 unforced model from the research paper.
% This script needs to have access to the following functions:
% 	sm90Unforced.m
%	sm90Tectonic.m

% The overall solution is broken down into two parts, 
% the tectionic-average equilibrium solutions and the Pleistocene departure equations.  
% Added together, these two parts make the full unforced system (no Milankovitch forces).

% Date: 10/16/2018
% Author: Raymart Ballesteros

sm90_unforced_params

tic

% Simulation of Pleistocene departure model:
options = odeset('Events',@sm90_co2_events);

[t,xprime,te,ye,ie] = ode45(@(t,x) sm90Unforced(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz),tspan,x0,options);

% Re-dimensionalizing the results
xprime(:,1) = xprime(:,1).*1.3;
xprime(:,2) = xprime(:,2).*26.3;
xprime(:,3) = xprime(:,3).*0.7;

%Re-dimensionalizing results at time of events
ye(:,1) = ye(:,1).*1.3;
ye(:,2) = ye(:,2).*26.3;
ye(:,3) = ye(:,3).*0.7;

% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
x = [3,Inf];
xfull = [3 Inf];

for i=1:size(t)
   x(1,i) = xprime(i,1);
   x(2,i) = xprime(i,2);
   x(3,i) = xprime(i,3);
   
   tectsol = sm90Tectonic(t(i));
   xfull(1,i) = xprime(i,1) + tectsol(1);
   xfull(2,i) = xprime(i,2) + tectsol(2);
   xfull(3,i) = xprime(i,3) + tectsol(3);
end

% Saving anamoly model data as a txt file
%fileID = fopen('SM90_Unforced_Model.txt','w');
%fprintf(fileID,'%7.7f %7.7f %7.7f\n',x);
%fclose(fileID);
x = x';
D = [te ye;t x];
%storeData(D,fileName,filePath,4);

yefull = [Inf,3];
for i=1:size(te)
   tectsol = sm90Tectonic(te(i));
   yefull(i,1) = ye(i,1) + tectsol(1);
   yefull(i,2) = ye(i,2) + tectsol(2);
   yefull(i,3) = ye(i,3) + tectsol(3);
end

%Saving full model data as a txt file
%fileID = fopen('runSM90full_250.txt','w');
%fprintf(fileID,'%7.7f %7.7f %7.7f\n',xfull);
%fclose(fileID);
xfull = xfull';
Dfull = [te yefull; t xfull];
%storeData(Dfull,fileName2,filePath,4);

toc

% Plotting in phase space
%figure;
%hold on;
%syms y z
%ezplot((z - z^2)/(0.9 - 0.5*z - z^2))
%plot(x(:,3)./0.7,x(:,2)./26.3,'k-')
%plot((x(:,3) - x(:,3).^2)/(0.9 - 0.5.*x(:,3) - x(:,3).^2),x(:,3))

%figure;
%hold on;
%plot3(x(:,2)./26.3,x(:,3)./0.7,x(:,1)./1.3,'k-')
%%plot3(x(:,2),x(:,3),x(:,1),'k-')
%syms x y z
%h1 = fimplicit3(-z+0.9.*y+z.^2-0.5.*y.*z-y.*z.^2);
%%%h2 = fimplicit3(-x-y-0.2*z);
%%%h3 = fimplicit3(-2.5*(x+z));
%h1.FaceAlpha = 0.25;
%%%h2.FaceAlpha = 0.5;
%%%h3.FaceAlpha = 0.5;
%ylabel('Theta')
%xlabel('Mu')
%zlabel('I')
%view(25,25)
%%%view(0,0)
%%view(0,90)

% Plot the parameters
if paramflag
   figure;
   plot(parT,P,parT,R,parT,S,parT,W,'LineWidth',2.0)

   % Save the parameters figure to a file
   print(gcf,'-dpdf','params_prac');
end %if

% Plot the solutions against time
if timeflag
   figure;
   subplot(3,1,1)
   hold on;
   %plot(t,x(:,1),'LineWidth',2.0)
   %plot(te,ye(:,1),'.','MarkerSize',10)
   plot(t,xfull(:,1),'LineWidth',2.0)
   plot(te,yefull(:,1),'.','MarkerSize',10)
   %axis([0 500 2 8])
   subplot(3,1,2)
   hold on;
   %plot(t,x(:,2),'LineWidth',2.0)
   %plot(te,ye(:,2),'.','MarkerSize',10)
   plot(t,xfull(:,2),'LineWidth',2.0)
   plot(te,yefull(:,2),'.','MarkerSize',10)
   %axis([0 500 150 450])
   subplot(3,1,3)
   hold on;
   %plot(t,x(:,3),'LineWidth',2.0)
   %plot(te,ye(:,3),'.','MarkerSize',10)
   plot(t,xfull(:,3),'LineWidth',2.0)
   plot(te,yefull(:,3),'.','MarkerSize',10)
   %axis([0 500 3 7])

   % Save the solutions figure to a file
   %print(gcf,'-dpdf', 'sols_prac');
   %print(gcf,'-dpdf', 'sm90Full_unforced_tempplot');
end %if

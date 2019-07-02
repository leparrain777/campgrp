% Run this script in matlab to produce the simulation and graphs 
% for the Saltzman 90 unforced model from the research paper.
% This script needs to have access to the following functions:
% 	sm90Unforced.m
%	sm90Tectonic.m

% The overall solution is broken down into two parts, 
% the tectionic-average equilibrium solutions and the Pleistocene departure equations.  
% Added together, these two parts make the full unforced system (no Milankovitch forces).

% Date: 10 July 2014
% Author: Andrew Gallatin

tic

% Note that the every step of t represents 10ka.
% Here, the simulation runs for 5 million years ago to present.
tspan = [0:0.1:500];

% Initial conditions are chosen arbitrarily based loosely on the Saltzman 1990 paper.
x0 = [0.001 0.001 0.001];

% Parameters dictated by the Saltzman 1990 paper.
% In this simulation:
%	param(1) := q
%	param(2) := u
%	param(3) := v
% The rest of the parameters that show up in the model are dealt with as 
% functions of time to achieve the bifurcation or stochastic modeling.  
param = [2.5 0.6 0.2];

% Set up the changing parameters:
parT = [0:0.1:500]';
P = 0.1778*(parT/100-0.5).^3 - 0.0548*(parT/100 -0.5).^2 - 10.58*(parT/100 - 0.5) + 33;
%P = 0.1778*(parT/100 - 0.5).^3 - 0.0548*(parT/100 - 0.5).^2 - 10.58*(parT/100 - 0.5) + 34.25;
R = (9/5)*(parT/100-0.5) - 6;
%R = (9/5)*(parT/100 - 0.5) - 6;
S = 2.05*(parT/100 - 0.5) - 7;
W = -(6/5)*(parT/100 - 0.5) + 6;
%W = -(4.5/5)*(parT/100 - 0.5) + 6;

% Set up the stochastic terms:
Rt = [0:5000]';
Rx = -0.025 + 0.05.*rand(5001,1);
Ry = -0.025 + 0.05.*rand(5001,1);
Rz = -0.025 + 0.05.*rand(5001,1);

% Simulation of Pleistocene departure model:
[t,xprime] = ode45(@(t,x) sm90Unforced(t,x,param,parT,P,R,S,W,Rt,Rx,Ry,Rz),tspan,x0);

% Re-dimensionalizing the results
xprime(:,1) = xprime(:,1).*1.3;
xprime(:,2) = xprime(:,2).*26.3;
xprime(:,3) = xprime(:,3).*0.7;

% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
x = [3,Inf];

for i = 1:size(t)
   tectsol = sm90Tectonic(t(i));
   x(1,i) = xprime(i,1) + tectsol(1);
   x(2,i) = xprime(i,2) + tectsol(2);
   x(3,i) = xprime(i,3) + tectsol(3);
end

x = x';

toc

% Plot the parameters 
figure;
plot(parT,P,parT,R,parT,S,parT,W,'LineWidth',2.0)
legend('p','r','s','w')

% Save the parameters figure to a file
%print(gcf,'-dpdf','sm90Full_params');
print(gcf,'-djpeg','sm90Full_params');

% Plot the solutions
figure;
subplot(3,1,1)
plot(t,x(:,1),'LineWidth',2.0)
axis([0 500 2 8])
ylabel('I')
subplot(3,1,2)
plot(t,x(:,2),'LineWidth',2.0)
axis([0 500 150 450])
ylabel('Mu')
subplot(3,1,3)
plot(t,x(:,3),'LineWidth',2.0)
axis([0 500 3 7])
xlabel('time (10 ky)')
ylabel('Theta')

% Save the solutions figure to a file
%print(gcf,'-dpdf','sm90Full_sols');
print(gcf,'-djpeg','sm90Full_sols');
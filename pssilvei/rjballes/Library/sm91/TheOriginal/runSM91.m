% Calculates the output of Saltzman and Maasch's 1991 climate model.

% Date: 17 August 2014
% Author: Andrew Gallatin

params

% Simulation of Pleistocene departure model:
[t,xprime] = ode45(@(t,x) sm91Full(t,x,param,parT,R,S,Rt,Rx,Ry,Rz,insolT,insol),tspan,x0);

% Re-dimensionalizing the results
xprime(:,1) = xprime(:,1).*2.0;
xprime(:,2) = xprime(:,2).*52.5;
xprime(:,3) = xprime(:,3).*0.9;


% Add the tectonic-average equilibrium solution to the Pleistocene departure model 
% to get the full solution for every value of t.
x = [3,Inf];
xfull = [3 Inf];

for i=1:size(t)
   x(1,i) = xprime(i,1);
   x(2,i) = xprime(i,2);
   x(3,i) = xprime(i,3);
end %for

for i = 1:size(t)
   tectsol = sm91Tectonic(t(i));
   xfull(1,i) = xprime(i,1) + tectsol(1);
   xfull(2,i) = xprime(i,2) + tectsol(2);
   xfull(3,i) = xprime(i,3) + tectsol(3);
end %for

%x = x';
%xfull = xfull';

% Separate out solutions.
t = tphys;
I = squeeze(x(1,:))';
Mu = squeeze(x(2,:))';
Theta = squeeze(x(3,:))';


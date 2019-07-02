% This script reads through data of model run and identifies the limit cycle

% Reading in data and putting it into an array
fileID = fopen('run4SM90_300.txt','r');
formatSpec = '%f %f %f';
sizeA = [3 Inf];
A = fscanf(fileID,formatSpec,sizeA);
fclose(fileID);
A = A';

% We first look at plot of I(ice mass) vs. Theta(ocean temperature)

% Poduces a plot of points for I vs. Theta for the first two cycles (arbitrarily chosen times)
% Finding time span for the second cycle starting from t=2900
i = 2900;
deltaTheta = A(i+1,3) - A(i,3);
while deltaTheta < 0
   i = i+1;
   deltaTheta = A(i+1,3) - A(i,3);
end %while
MinAt = i;
deltaTheta = A(i+1,3) - A(i,3);
while deltaTheta > 0
   i = i+1;
   deltaTheta = A(i+1,3) - A(i,3);
end %while
MaxAt = i;
while A(i,3) > A(2900,3)
   i = i+1;
end %while
t2 = i;
tspan2 = [2900:i]';
I2 = A(2900:t2,1);
Theta2 = A(2900:t2,3);

t1 = 420;
tspan1 = [320:t1]';
I1 = A(320:t1,1);
Theta1 = A(320:t1,3);
% Plotting cycle for t=320:420
figure();
%hold on;
subplot(3,2,1)
plot(Theta1,I1,'-')
title('Plot of Cycle 1')
xlabel('Theta')
ylabel('I')
%hold off;
subplot(3,2,3)
plot(tspan1,Theta1,'-')
xlabel('time (ka)')
ylabel('Ocean Temperature (Theta)')
subplot(3,2,5)
plot(tspan1,I1,'-')
xlabel('time (ka)')
ylabel('Ice Mass (I)')

% Plotting cycle for t=2900:i, where i was determined previously (above)
subplot(3,2,2)
hold on;
plot(Theta2,I2,'-')
plot(Theta2(MinAt-2900),I2(MinAt-2900),'go')
plot(Theta2(MaxAt-2900),I2(MaxAt-2900),'ro')
title('Plot of Cycle 2')
xlabel('Theta')
ylabel('I')
hold off;
subplot(3,2,4)
plot(tspan2,Theta2,'-')
xlabel('time (ka)')
ylabel('Ocean Temperature (Theta)')
subplot(3,2,6)
plot(tspan2,I2,'-')
xlabel('time (ka)')
ylabel('Ice Mass (I)')

% Saving figure of the cycle for plot of I vs Theta
print(gcf,'-dpdf','sm90_IvThetacycle300');

% Look at plot of I(ice mass) vs. Mu(CO2 concentration)
% Search for where the change of CO2 concentration (Mu) changes sign
m = 2900;
deltaMu = A(m+1,2)-A(m,2);

while deltaMu < 0
   m = m+1;
   deltaMu = A(m+1,2) - A(m,2);
end %while
MinAt = m;
deltaMu = A(m+1,2) - A(m,2);
while deltaMu >= 0
   m = m+1;
   deltaMu = A(m+1,2) - A(m,2);
end %while
MaxAt = m;
while A(m,2) > A(2900,2)
   m = m+1;
end %while
t2 = m;
tspan2 = [2900:t2]';
I2 = A(2900:t2,1);
Mu2 = A(2900:t2,2);

t1 = 420;
tspan1 = [320:t1]';
I1 = A(320:t1,1);
Mu1 = A(320:t1,2);
% Plotting cycle for t=320:420
figure();
subplot(3,2,1)
plot(Mu1,I1,'-')
title('Plot of Cycle 1')
xlabel('Theta')
ylabel('I')
subplot(3,2,3)
plot(tspan1,Mu1,'-')
xlabel('time (ka)')
ylabel('CO2 Concentration')
subplot(3,2,5)
plot(tspan1,I1,'-')
xlabel('time (ka)')
ylabel('Ice Mass')

% Plotting cycle for t=2900:m, where m is determined above
subplot(3,2,2)
hold on;
plot(Mu2,I2,'-')
plot(Mu2(MinAt-2900),I2(MinAt-2900),'go')
plot(Mu2(MaxAt-2900),I2(MaxAt-2900),'ro')
title('Plot of Cycle 2')
xlabel('Mu')
ylabel('I')
hold off;
subplot(3,2,4)
plot(tspan2,Mu2,'-')
xlabel('time (ka)')
ylabel('CO2 Concentration')
subplot(3,2,6)
plot(tspan2,I2,'-')
xlabel('time (ka)')
ylabel('Ice Mass')

% Saving figure of the cycle for plot of I vs Mu
print(gcf,'-dpdf','sm90_IvMucycle300');

% Look at plot of Mu(CO2 concentration) vs Theta(ocean temperature)

t1 = 420;
tspan1 = [320:t1]';
Mu1 = A(320:t1,2);
Theta1 = A(320:t1,3);
% Plotting cycle for t=320:420
figure();
subplot(3,2,1)
plot(Theta1,Mu1,'-')
title('Plot of Cycle 1')
xlabel('Theta')
ylabel('Mu')
subplot(3,2,3)
plot(tspan1,Theta1,'-')
xlabel('time (ka)')
ylabel('Ocean Temperature')
subplot(3,2,5)
plot(tspan1,Mu1,'-')
xlabel('time (ka)')
ylabel('CO2 Concentration')

% Plotting cycle for t=2900:t2
subplot(3,2,2)
plot(Theta2,Mu2,'-')
title('Plot of Cycle 2')
xlabel('Theta')
ylabel('Mu')
subplot(3,2,4)
plot(tspan2,Theta2,'-')
xlabel('time (ka)')
ylabel('Ocean Temperature')
subplot(3,2,6)
plot(tspan2,Mu2,'-')
xlabel('time (ka)')
ylabel('CO2 Concentration')

% Saving figure of the cycle for plot of Mu vs Theta
print(gcf,'-dpdf','sm90_MuvThetacycle300');

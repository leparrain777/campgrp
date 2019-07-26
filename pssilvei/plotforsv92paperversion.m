
figure(1)
clf
subplot(5,1,1)
t = ans(:,5);
plot(t,ans(:,1),'-')
%set(gca,'xdir','reverse')
title(strcat('SV92',' '));
ylabel('Ice mass')
subplot(5,1,2)
plot(t,ans(:,2),'-')
%set(gca,'xdir','reverse')
ylabel('Bedrock depression')
subplot(5,1,3)
plot(t,ans(:,3),'-')
%set(gca,'xdir','reverse')
ylabel('CO2')
subplot(5,1,4)
plot(t,ans(:,4),'-')
%set(gca,'xdir','reverse')
ylabel('Ocean temp')
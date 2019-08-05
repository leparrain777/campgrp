
figure(1)
clf
subplot(5,1,1)
t = ans(:,5);
for i = 1:length(t)
    cycleave(i) = mean(ans(max(1,i-750):i,6));
end
plot(t,ans(:,1),'-')
ylim([0 6.5e19])
%set(gca,'xdir','reverse')
title(strcat('SV92',' '));
ylabel('Ice mass')
subplot(5,1,2)
plot(t,ans(:,2),'-')
ylim([0 650])
%set(gca,'xdir','reverse')
ylabel('Bedrock depression')
subplot(5,1,3)
plot(t,ans(:,3),'-')
ylim([150 380])
%set(gca,'xdir','reverse')
ylabel('CO2')
subplot(5,1,4)
plot(t,ans(:,4),'-')
ylim([-1.75 1])
%set(gca,'xdir','reverse')
ylabel('Ocean temp')
subplot(5,1,5)
plot(t,cycleave,'-')
%ylim([-1.25 1.25])
%set(gca,'xdir','reverse')
ylabel('Cycle marks')
disp(1/cycleave(length(t)))
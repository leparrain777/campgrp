
figure(1)
clf
subplot(5,1,1)
t = ans(:,5);
cycleave = [1:1:length(t)];
for i = 1:length(t)
    cycleave(i) = mean(ans(max(1,i-500):i,6));
end
plot(t,ans(:,1),'-')
ylim([0 12e19])
xlim([0 5e6])
%set(gca,'xdir','reverse')
title(strcat('SV92',' '));
ylabel('Ice mass')
subplot(5,1,2)
plot(t,ans(:,2),'-')
ylim([0 1000])
xlim([0 5e6])
%set(gca,'xdir','reverse')
ylabel('Bedrock depression')
subplot(5,1,3)
plot(t,ans(:,3),'-')
ylim([-100 100])
xlim([0 5e6])
%set(gca,'xdir','reverse')
ylabel('CO2')
subplot(5,1,4)
plot(t,ans(:,4),'-')
ylim([-4 4])
xlim([0 5e6])
%set(gca,'xdir','reverse')
ylabel('Ocean temp')
subplot(5,1,5)
plot(t,cycleave,'-')
xlim([0 5e6])
%ylim([-1.25 1.25])
%set(gca,'xdir','reverse')
ylabel('Cycle marks')
disp(1/mode(cycleave(500:end)))
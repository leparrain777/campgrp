
 figure(randi([5 255]))
 clf
subplot(5,1,1)
endof = 0;
start = .8;
t = ans(:,5);
cycleave = [1:1:length(t)];
% for i = 1:length(t)
%     cycleave(i) = mean(ans(max(1,i-200):i,6));
% end
cycleave = smoothdata(ans(:,6),'gaussian',200);
plot(t,ans(:,1),'-')
ylim([0 8e19])
xlim([endof*1e6 start*1e6])
set(gca,'xdir','reverse')
title(strcat('SV92',' '));
ylabel('Ice mass')
subplot(5,1,2)
plot(t,ans(:,2),'-')
ylim([0 800])
xlim([endof*1e6 start*1e6])
set(gca,'xdir','reverse')
ylabel('Bedrock depression')
subplot(5,1,3)
plot(t,ans(:,3),'-')
ylim([-100 80])
xlim([endof*1e6 start*1e6])
set(gca,'xdir','reverse')
ylabel('CO2')
subplot(5,1,4)
plot(t,ans(:,4),'-')
ylim([-2 2])
xlim([endof*1e6 start*1e6])
set(gca,'xdir','reverse')
ylabel('Ocean temp')
subplot(5,1,5)
plot(t,cycleave,'-')
xlim([endof*1e6 start*1e6])
%ylim([-1.25 1.25])
set(gca,'xdir','reverse')
ylabel('Cycle marks')
disp(1/min(cycleave(500:end)))
disp(1/max(cycleave(500:end)))
disp(1/mean(cycleave(500:end)))
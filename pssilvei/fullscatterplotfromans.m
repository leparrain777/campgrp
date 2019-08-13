figure(3)
clf
scatter3(ans(500:end,5),ans(500:end,1),ans(500:end,3),10.^(ans(500:end,2)/300),ans(500:end,4)-mean(ans(500:end,4)))
set(gca,'YLim',[0 6.5e19])%,'ZLim',[160 380])
hold on
plot3(ans(500:end,5),ans(500:end,1),ans(500:end,3))
hold off
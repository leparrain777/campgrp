figure(figurecounter)
clf
scatter3(ans(:,5),ans(:,1),ans(:,3),10.^(ans(:,2)/300),ans(:,4)-mean(ans(:,4)))
set(gca,'YLim',[0 6.5e19],'ZLim',[-100 0])
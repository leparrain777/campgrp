stats = readData('statisticsOut.txt','/',4);
u = stats(:,1);
p = stats(:,2);
%ratio = stats(:,3);
freq = stats(:,4);

uspan = 0.5:0.02:1;
pspan = p(1:16);

for i=1:size(uspan,2);
    for j=1:size(pspan,1);
        temp(16*(i-1)+j,1)=uspan(i);
        temp(16*(i-1)+j,2)=pspan(j);
        filename = strcat('SM91_u=',num2str(uspan(i),2),'_p=',num2str(pspan(j),2),'EEMD_Data.txt');
        nmodes = readData(filename,'D:\Documents\Climate Research\campgrp\agallati\sm91\IntegratedParamSearch_442016/Data/',11);
        nmodesMEcc = nmodes(:,6)+nmodes(:,7);

        %Tuning Variance Early: [1250,2000] Late: [0,500]
        ratio(16*(i-1)+j,1) = var(nmodes(1:751,5))/var(nmodesMEcc(end-500:end));

    end
end

period = 1./freq;
ratio_error = abs(0.178471 - ratio)./0.178471;
period_error = abs(100-period)./100;
cost = ratio_error + 10.*period_error;

cost_matrix=[cost(1:16)'];
for i=1:size(uspan,2)-1;
        temp = [cost_matrix ; cost(16*i+1:16*i+16)'];
        cost_matrix = temp;
end

%cost_matrix = [cost(1:16)' ; cost(17:32)' ; cost(33:48)' ; cost(49:64)' ; cost(65:80)' ; cost(81:96)' ;  
%    cost(97:112)'; cost(113:128)'; cost(129:144)'; cost(145:160)';cost(161:176)';cost(177:192)';cost(193:208)';
%    cost(209:224)';cost(225:240)';cost(241:256)';cost(257:272)';cost(273:288)';cost(289:304)';cost(305:320)';
 %   cost(321:336)'];

contourf(pspan,uspan,cost_matrix,25);
colorbar;
title('Contour Plot of Cost Function');
xlabel('p Parameter');
ylabel('u Parameter');

%Find 'best' parameters
%Disp('Best Parameters')
[min,idx] = sort(cost);
min_idx = idx(1:10);
final = [u(min_idx)  p(min_idx)  ratio(min_idx)  period(min_idx)  cost(min_idx)]

%Find all p=1 stats
%Disp('p = 1 Stats')
p1 = find(p==1);
p1_stats = [u(p1)  p(p1)  ratio(p1)  period(p1)  cost(p1)]


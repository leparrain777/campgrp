step = .01;
lost = [0:step:2];
for n = lost
    name = strcat('sv92forcingrunsu=',num2str(n*1000));
    load(strcat('sv92forcingruns\',name),'-mat');
    helper = sum(ans(:,12) == 1)/2;
    index = round(n/step) + 1;
    cycleaves(index) = helper;
    %plotforsv92paperversion
end
addone = cycleaves < 5;
cycleaves = cycleaves + 1e10*addone;
figure
plot(5000000./cycleaves)
step = .01;
u = [0.0:step:2];
tau = [.3:step:1.5];
for n = u
    for m = tau
        %ics = [];
        name = strcat('sv92taugridu=',num2str(n*1000),'tau=',num2str(m*1000));
        load(strcat('sv92taugridthing\',name),'-mat');
        helper = sum(ans(:,12) == 1)/2;
        index1 = round(n/step) + 1;
        index2 = round(m/step) + 1;
        cycleaves(index1,index2) = helper;
        %plotforsv92paperversion
    end
end
addone = cycleaves < 5;
cycleaves = cycleaves + 1e10*addone;
figure
imagesc(5000000./cycleaves)
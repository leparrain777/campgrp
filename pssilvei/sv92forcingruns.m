lost = [0:.05:2];
for n = lost
    ans = sv92_run_model(32,n); %1 to run 1a, 21 to run 2a, 22 to run 2b, 23 to run 2c, 31 to run 3a, 32 to run 3b, 90 to run sm90, and 91 to run sm91.
    name = strcat('sv92forcingrunsu=',num2str(n));
    save(strcat('sv92forcingruns\',name),'ans','-mat');
    %plotforsv92paperversion
end
    
step = .01;
lost = [0:1:2/step];
parfor n = lost
    ans = sv92_run_model(32,n*step); %1 to run 1a, 21 to run 2a, 22 to run 2b, 23 to run 2c, 31 to run 3a, 32 to run 3b, 90 to run sm90, and 91 to run sm91.
    name = strcat('sv92forcingrunsu=',num2str(n*step*1000));
    parsave(strcat('sv92forcingruns\',name),ans);
    %plotforsv92paperversion
end
    
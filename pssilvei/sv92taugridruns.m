step = .01;
u = [0:1:2/step];
tau = [.3/step:1:1.5/step];
parfor n = u
    for m = tau
        %ics = [];
        ans = sv92_run_model(32,n*step,m*step); %1 to run 1a, 21 to run 2a, 22 to run 2b, 23 to run 2c, 31 to run 3a, 32 to run 3b, 90 to run sm90, and 91 to run sm91.
        name = strcat('sv92taugridu=',num2str(n*step*1000),'tau=',num2str(m*step*1000));
        parsave(strcat('sv92taugridthing\',name),ans);
        %plotforsv92paperversion
    end
end
    
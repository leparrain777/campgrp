u = [0:.05:2];
tau = [.3:.05:1.5];
for n = u
    for m = tau
        %ics = [];
        ans = sv92_run_model(32,n,m); %1 to run 1a, 21 to run 2a, 22 to run 2b, 23 to run 2c, 31 to run 3a, 32 to run 3b, 90 to run sm90, and 91 to run sm91.
        name = strcat('sv92taugridu=',num2str(n*1000),'tau=',num2str(m*1000));
        save(strcat('sv92taugridthing\',name),'ans','-mat');
        %plotforsv92paperversion
    end
end
    
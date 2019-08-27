step = .01;
u = [0.0:step:2];
tau = [.3:step:1.5];
for n = u
    for m = tau
        %ics = [];
        name = strcat('sv92taugridu=',num2str(n*1000),'tau=',num2str(m*1000));
        load(strcat('sv92taugridthing\',name),'-mat');
        hello = abs(fft(ans(:,2)-mean(ans(:,2))));
        [maximum,fftindex] = maxk(hello(1:2500),10);
        index1 = round(n/step) + 1;
        index2 = round(m/step) + 1;
        cycleaves(index1,index2) = fftindex(1);
        %plotforsv92paperversion
    end
end

figure
imagesc(5000000./cycleaves);
figure
surf(5000000./cycleaves);





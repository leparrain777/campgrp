step = .01;
u = [0.0:step:2];
tau = [.3:step:1.5];
%direct = 'sv92taugridthing\';
direct = 'sv92taugridthingperiodic\';
for n = u
    for m = tau
        %ics = [];
        name = strcat('sv92taugridu=',num2str(n*1000),'tau=',num2str(m*1000));
        load(strcat(direct,name),'-mat');
        hello = abs(fft(ans(:,2)-mean(ans(:,2))));
        [maximum,fftindex] = maxk(hello(1:2500),10);
        index1 = round(n/step) + 1;
        index2 = round(m/step) + 1;
        cycleaves(index1,index2) = fftindex(1);
        %plotforsv92paperversion
    end
end

figure
imagesc([.3:.01:1.5],[0:.01:2],5000./cycleaves(:,30:150));
set(gca, 'ydir','normal')
xlim([0.31 1.5])
colors = colorbar;
colors.Label.String = 'Dominant Periodicity (kyr)'
%title('SV92 - Largest FFT Coefficient Periodicity')
title('')
ylabel('Force Amplitude')
xlabel('\tau')
set(gcf,'color','w');
pbaspect('auto')

% figure
% surf(5000000./cycleaves);





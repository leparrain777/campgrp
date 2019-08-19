function [time, insol_r] = plot_Insol_Welch_Main(insol, tstart, tfinal, window)
%View the Welch's power spectral density estimate (pwelch) of different insolations.
%To use, choose what insolation you want to view (insol), the start time (tstart), the end time (tfinal), and the number of windows you want to use for pwelch (window).
%To overlay the plots, type "hold on" into the command line and then plot. To stop overlaying, type "hold off" into the command line.
%Author: Zachary Gelber

if insol == 1
	[time,insol_r] = read_PP04_Insolation('65N_21st_June.txt', tstart, tfinal);
end

if insol == 2
    [time,temp1]=readLaskarInsolation(6,tfinal,tstart);
    [~,temp2]=readLaskarInsolation(7,tfinal,tstart);
    [~,temp3]=readLaskarInsolation(8,tfinal,tstart);
    insol_r = temp1+temp2+temp3;
end

if insol == 3
    [time,temp1]=read_PP04_Insolation('65N_5thMo.txt',tstart,tfinal);
    [~,temp2]=read_PP04_Insolation('65N_6thMo.txt',tstart,tfinal);
    [~,temp3]=read_PP04_Insolation('65N_7thMo.txt',tstart,tfinal);
    [~,temp4]=read_PP04_Insolation('65N_8thMo.txt',tstart,tfinal);
    [~,temp5]=read_PP04_Insolation('65N_9thMo.txt',tstart,tfinal);
    insol_r = temp1+temp2+temp3+temp4+temp5;
end
if insol == 4
    [time,temp1]=read_PP04_Insolation('65N_5thMo.txt',tstart,tfinal);
    [~,temp2]=read_PP04_Insolation('65N_6thMo.txt',tstart,tfinal);
    [~,temp3]=read_PP04_Insolation('65N_7thMo.txt',tstart,tfinal);
    [~,temp4]=read_PP04_Insolation('65N_8thMo.txt',tstart,tfinal);
    [~,temp5]=read_PP04_Insolation('65N_9thMo.txt',tstart,tfinal);
    [~,temp6]=read_PP04_Insolation('65N_4thMo.txt',tstart,tfinal);
    [~,temp7]=read_PP04_Insolation('65N_10thMo.txt',tstart,tfinal);
    insol_r = temp1+temp2+temp3+temp4+temp5+temp6+temp7;
end

if insol == 5
	[time,insol_r] = integratedInsolation(tstart, tfinal);
end

insol_n = (insol_r - mean(insol_r))/std(insol_r);
num_windows = round(length(insol_r)/((window+1)/2));
[pxx1,freq1] = pwelch(insol_n, num_windows, [], [], 1);
loglog(freq1, pxx1);

function [time, insol] = integratedInsolation(tstart, tend)
% Gives the Huybers 2006 integrated insolation from tstart to tend.
% Example use for insolation for the past 5mya:
%        [insolT,insol] = integratedInsolation(0,5000);
[kyear day] = meshgrid(tstart:1:tend,1:1:365);
Fsw = daily_insolation(kyear,65,day);
Fsw(Fsw<275)=0;

insol = sum(Fsw,1)*86400*10^-9;
time = kyear;

end

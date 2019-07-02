function sm90_plot_eemd(nmodes,mode_num,saveFlag)
%sm90_plot_eemd(nmodes,mode_num,whiteNoise,runID,saveFlag)
%nmodes is the EEMD output
%mode_num is a vector with the IMF numbers listed to plot
%whiteNoise is the level of white noise in run
%runID is the number of the model run
%saveFlag is either a 1 or a 0 for whether to save the plot or not, respectively
%
%1 is the original Data
%2 - end-1 are the IMFs
%end is the residual

sm90_params
SM90_params_EEMD

len=size(nmodes,1);
for i=1:size(nmodes,2)
    nmodes(:,i) = nmodes(:,i)-mean(nmodes(:,i));
end
figure;  
plot([0:len-1],nmodes(:,mode_num(1)));
if length(mode_num) > 1
    hold on
    for i=mode_num(2:end)
        bot=min(nmodes(:,mode_num(i-1)));
        top=max(nmodes(:,mode_num(i)));
        nmodes(:,i:end)=nmodes(:,i:end)+bot-top-0.1;
        plot([0:len-1],nmodes(:,mode_num(i)));
    end
    hold off
end

title(sprintf('SM90 Run%d EEMD; p = %g, u = %g, %g White Noise',runID,param(1),param(5),whiteNoise));

if saveFlag
   fpath = '~/campgrp/rjballes/EEMDRuns/sm90/Figures/';
   fname0 = sprintf('sm90_run%d_EEMD',runID);
   fname = strcat(fpath,fname0);
   print(fname,'-djpeg')
   print(fname,'-dpdf','-bestfit')
end %if

end
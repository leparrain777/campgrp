function Only_Plot_EEMD(nmodes,mode_num)
%function Only_Plot_EEMD(nmodes,mode_num)
%nmodes is the EEMD output
%mode_num is a vector with the IMF numbers listed to plot
%
%1 is the original Data
%2 - end-1 are the IMFs
%end is the residual
len=size(nmodes,1);
for i=1:size(nmodes,2)
    nmodes(:,i) = nmodes(:,i)-mean(nmodes(:,i));
end
figure = plot([0:len-1],nmodes(:,mode_num(1)));
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


end

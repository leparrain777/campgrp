addMatlabpath;
clear all;
close all;

huybersflag = 0;
lrflag = 0;
tempflag = 0;
co2flag = 0;
pp04flag = 0;
tunedflag = 0;

figureflag = 0;
extrafigflag = 0;

endyear = 5000;


%--------------------------------------------------------------------------------------------------
for modestart = 3:6

    my_colors = [[0, 0.4470, 0.7410], [0.8500, 0.3250, 0.0980], [0.9290, 0.6940, 0.1250], [0.4940, 0.1840, 0.5560], [0.4660, 0.6740, 0.1880], [0.6350, 0.0780, 0.1840]];
    color_choice = my_colors(3*(modestart-2)-2+3:3*(modestart-2)+3);

    if huybersflag
        readhuyberseemd;
        sum_mode = sum(- nmodes(1:endyear,5:end),2);
        sum_mode = sum_mode - mean(sum_mode);
        title_amend = 'Huybers'
    end

    if lrflag
        readphaseeemd;
        sum_mode = sum(-nmodes(1:endyear,5:end),2);
        sum_mode = sum_mode - mean(sum_mode);
        title_amend = 'LR04 Untuned'
    end

    if tempflag;
        readtempeemd;
        endyear = 790
        sum_mode = sum(nmodes(1:endyear,5:end),2);
        sum_mode = smooth(sum_mode) - mean(sum_mode);
        title_amend = 'Temp/Deuterium'
    end

    if co2flag;
        readco2eemd;
        endyear = 720
        sum_mode = sum(nmodes(1:endyear,5:end),2);
        sum_mode = sum_mode - mean(sum_mode);
        title_amend = 'Vostok CO2 Composite'
    end

    if pp04flag
        nmodes = PP04_Read_EEMD(1);
        endyear = 4000
        sum_mode = sum(nmodes(50:endyear,4:end),2);
        sum_mode = sum_mode - mean(sum_mode);
        title_amend = 'PP04 Late Cycles'

    end

    if tunedflag;
        readtunedeemd;
        sum_mode = sum(-nmodes(1:endyear,modestart:end),2);
        sum_mode = sum_mode - mean(sum_mode);
        title_amend = 'LR04 Tuned';
    end
    
    sm90_params
    sm90_readeemd
    sum_mode = flipud(sum(nmodes(50:endyear,4:end),2));
    sum_mode = sum_mode - mean(sum_mode);
    title_amend = 'SM90 Late Cycles';
    %--------------------------------------------------------------------------------------------------

    slopes = sum_mode(2:end) - sum_mode(1:end-1);
    time_step = 1:length(slopes);
    %filter = (modestart <= 4) * .01 + (modestart > 4) * .01 / ((modestart - 1))
    filter = .01 %/ (modestart - 1)
    pos_slopes = slopes(slopes >filter);
    pos_times = time_step(slopes > filter);
    neg_slopes = slopes(slopes <-1 * filter);
    neg_times = time_step(slopes <-1 * filter);



    plot_step = 160:length(sum_mode)-161;

    pos_windowed_avg = [];
    for ii = plot_step
        new_avg = mean(pos_slopes(pos_times >= ii-160 & pos_times < ii+160));
        pos_windowed_avg = [pos_windowed_avg new_avg];
    end

    neg_windowed_avg = [];
    for ii = plot_step
        new_avg = mean(neg_slopes(neg_times > ii-160 & neg_times < ii+160));
        neg_windowed_avg = [neg_windowed_avg new_avg];
    end
    if extrafigflag
        figure;
        hold on
        plot(pos_slopes)
        plot(abs(neg_slopes))
        title('Slopes')
        hold off

        figure;
        hold on
        plot(plot_step,pos_windowed_avg)
        plot(plot_step,abs(neg_windowed_avg))
        title('Avg Slopes')
    hold off
    end
    subplot(2,3,modestart-2)
    hold on
    ratios = abs(neg_windowed_avg)./abs(pos_windowed_avg);
    maxr = mean(ratios)
    plot(plot_step,ratios, 'Color', color_choice)
    plot([5000, 0],[maxr, maxr], 'Color', color_choice)
    plot([5000, 0],[1,1], 'Color', 'k')
    title(sprintf('Ratio Slopes %d', modestart-1))
    hold off
    
    subplot(2,3,5)
    hold on
    ratios = abs(neg_windowed_avg)./abs(pos_windowed_avg);
    maxr = mean(ratios)
    plot(plot_step,ratios, 'Color', color_choice)
    plot([5000, 0],[maxr, maxr], 'Color', color_choice)
    plot([5000, 0],[1,1], 'Color', 'k')
    title('5000 Kyr Comparison')
    hold off
    
    maxp = mean(ratios(1:1000))
    subplot(2,3,6)
    hold on
    ratios = abs(neg_windowed_avg)./abs(pos_windowed_avg);
    plot(plot_step,ratios, 'Color', color_choice)
    plot([1000, 0],[maxp, maxp], 'Color', color_choice)
    plot([5000, 0],[1,1], 'Color', 'k')
    title('1000 Kyr Comparison')
    xlim([160,1000])
    hold off
    
end

%Author: Zachary Gelber - **/**/2019

clc
clear all

addMatlabpath

ReadMeFlag = 1;  %Choose if you want to save your results. Choosing to do so will save your parameters
		 %and values in a text file called 'PP04_%s_%s_%d_Multi_Run.txt' in your desired location.
run_num = 1;     %Set what run number this is. Only useful if saving output using the ReadMeFlag.
filePath = '/nfsbigdata1/campgrp/zgelber/Runs/Cycles/Multi_Run/';  %Choose where you want to save your output.

%Change the below parameters to see how different parameters affect cycle statistics%

% ================================ %

%Choose which variable you would like to vary. Make sure only one flag is on at a time%

    force_amplitude_begin = 0.2;
    force_amplitude_end = 0.8;
    force_amplitude_steps = 0.01;
    run_amount = 5;

    Vbegin = 0;
    Vend = 1.5;
    Abegin = 0;
    Aend = 1.5;
    Cbegin = -0.4;
    Cend = 1.2;

    tstart = 0000;
    tfinal = 5000;

    cycle_tstart = 0000;
    cycle_tfinal = 4000;


%Choose if you want to plot or not%
plot_flag = 1;
histo_flag = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

number_of_force_amplitudes = floor((force_amplitude_end - force_amplitude_begin)/force_amplitude_steps)+1;
histo_array = zeros(number_of_force_amplitudes, 16);
counter = 1;

edges = [60:5:140];

for force_amplitude=force_amplitude_begin:force_amplitude_steps:force_amplitude_end
    disp(force_amplitude)
    periods = [];
    for run_number=1:run_amount
        %disp(run_number)
        V = Vbegin + (Vend-Vbegin)*rand(1,1);
        A = Abegin + (Aend-Abegin)*rand(1,1);
        C = Cbegin + (Cend-Cbegin)*rand(1,1);
        %initial_condition_string = ['V = ', num2str(V), ' A = ', num2str(A), ' C = ', num2str(C)];
        %disp(initial_condition_string)
        n0=[V,A,C];
        PP04_Params_Multi_Run
        try
            Constants(16) = force_amplitude;
            [tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0, tstart, tfinal);
            New_Cycle_Stats_Multi
            assert(sum(Vout(tstart+1:tfinal)>0.5) > 150);
            periods = [periods, full_cycles];
        catch
            disp('fail')
        end
    end
    histo = histcounts(periods, edges);
    histo_array(counter, :) = histo;
    counter = counter + 1;
end

    if plot_flag == 1
        figure;
        [force_values, bins] = meshgrid([force_amplitude_begin:force_amplitude_steps:force_amplitude_end], [62.5:5:137.5]);
        s1 = surf(force_values, bins, histo_array');
        set(gca, 'XLim', [force_amplitude_begin,force_amplitude_end]);
        xlabel('Force Amplitude');
        ylabel('Period');
        zlabel('Count');
        title('Cool name to come');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ReadMeFlag == 1
    disp('TODO')
end



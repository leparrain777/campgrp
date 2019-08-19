%Author: Zachary Gelber - **/**/2019

clc
clear all

ReadMeFlag = 1;  %Choose if you want to save your results. Choosing to do so will save your parameters
		 %and values in a text file called 'PP04_%s_%s_%d_Multi_Run.txt' in your desired location.
run_num = 4;     %Set what run number this is. Only useful if saving output using the ReadMeFlag.
filePath = '/nfsbigdata1/campgrp/zgelber/Runs/Cycles/Multi_Run/';  %Choose where you want to save your output.

%Change the below parameters to see how different parameters affect cycle statistics%

% ================================ %

%Choose which variable you would like to vary. Make sure only one flag is on at a time%

    force_amplitude = 1.6;
    run_amount = 3;

    cycle_tstart = 0000;
    cycle_tfinal = 4000;

    tstart = 0000;
    tfinal = 5000;

    Vbegin = 0;
    Vend = 1.5;
    Abegin = 0;
    Aend = 1.5;
    Cbegin = -0.4;
    Cend = 1.2;

%Choose if you want to plot or not%
plot_flag = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    periods = [];

    for run_number=1:run_amount
        disp(run_number)
        counter = 1;
        V = Vbegin + (Vend-Vbegin)*rand(1,1);
        A = Abegin + (Aend-Abegin)*rand(1,1);
        C = Cbegin + (Cend-Cbegin)*rand(1,1);
        initial_condition_string = ['V = ', num2str(V), ' A = ', num2str(A), ' C = ', num2str(C)];
        disp(initial_condition_string)
        n0=[V,A,C];
        PP04_Params_Multi_Run
        Constants(16) = force_amplitude;
        try
            [tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0,tstart,tfinal);
        %try                             
            New_Cycle_Stats_Multi
            assert(sum(Vout(tstart+1:tfinal)>0.5) > 150);
            periods = [periods, full_cycles];
        catch
            toc
            disp('fail')
        end
    end

    %periods = periods(periods > 60);

    if plot_flag == 1
        figure()
        h1 = histogram(periods);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ReadMeFlag == 1
    disp('TODO')
end



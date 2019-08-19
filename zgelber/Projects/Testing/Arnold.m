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

    force_amplitude_begin = 0;
    force_amplitude_end = 1;
    force_amplitude_steps = 0.5;

    tau_begin = 0.5;
    tau_end = 1.5;
    tau_steps = 0.5;

    run_amount = 1;

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


force_amount = floor((force_amplitude_end - force_amplitude_begin)/force_amplitude_steps)+1;
tau_amount = floor((tau_end - tau_begin)/tau_steps)+1;

cluster_array = zeros(force_amount, tau_amount);

force_counter = force_amount;
tau_counter = 1;

for force_amplitude=force_amplitude_begin:force_amplitude_steps:force_amplitude_end
    disp('force amplitude')
    disp(force_amplitude)
    for tau=tau_begin:tau_steps:tau_end
        disp('tau')
        disp(tau)

        for run_number=1:run_amount
            %disp(run_number)
            n0=random_initial_conditions(Vbegin,Vend,Abegin,Aend,Cbegin,Cend);
            dwhere
            Constants=[tV,tC,tA,x,y,z,al,be,ga,de,a,b,c,d,k,force_amplitude,tau,g];
            Constants(16) = force_amplitude;
            Constants(17) = tau;
            try
                [tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04T_Main(Constants,insol,n0, tstart, tfinal);
                assert(sum(Vout(1:500)>0.5) > 150);
	        Cycle_Arnold;
                cluster_array(force_counter, tau_counter) = avg_cycle;
            catch
                disp('fail')
                cluster_array(force_counter, tau_counter) = 0;
            end
        end
        tau_counter = tau_counter + 1;
        if tau_counter > tau_amount
            tau_counter = 1;
        end
    end
    force_counter = force_counter - 1;
end

    if plot_flag == 1
        figure;
        x_axis = [tau_begin tau_end];
        y_axis = [force_amplitude_begin force_amplitude_end];
        imagesc(x_axis, y_axis, cluster_array);
        colorbar;
        xlabel('Tau');
        ylabel('Force Amplitude');
        title('Cool name to come');
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ReadMeFlag == 1
    disp('TODO')
end



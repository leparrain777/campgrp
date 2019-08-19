%Author: Zachary Gelber - **/**/2019

clc
clear all

addMatlabpath

Parameters_Q2Grid;

if ReadMeFlag == 1
    Write_Q2Grid;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


k1_amount = floor((k1_end - k1_begin)/k1_steps)+1;
k2_amount = floor((k2_end - k2_begin)/k2_steps)+1;

grid_array = zeros(k1_amount, k2_amount);

k1_counter = k1_amount;
k2_counter = 1;

for force_amplitude=force_amplitude_begin:force_amplitude_steps:force_amplitude_end
    disp('force amplitude')
    disp(force_amplitude)
    for tau=tau_begin:tau_steps:tau_end
        disp('tau')
        disp(tau)
        incomplete = true;
        while incomplete
            n0=random_initial_conditions(Vbegin,Vend,Abegin,Aend,Cbegin,Cend);
            Constants=[tV,tC,tA,x,y,z,al,be,ga,de,a,b,c,d,k,force_amplitude,tau,g];
            try
                [tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants, insol, n0, tstart, tfinal);
                if ReadMeFlag == 1
                    storeData([tout,Vout,Aout,Cout,Hout,Fout,NorthF], sprintf('PP04_FA:%g_Tau:%g_ModelOutput', force_amplitude, tau), filePathOutput, 7);
                end
                assert(sum(Vout(1:500)>0.5) > 150);
	        Cycle_Statistics_Grid;
                if scale_by_tau
 		    avg_cycle = avg_cycle/tau;
		end
                grid_array(force_counter, tau_counter) = avg_cycle;
                incomplete = false;
            catch
                disp('fail')
            end
        end
        tau_counter = tau_counter + 1;
        if tau_counter > tau_amount
            tau_counter = 1;
        end
    end
    force_counter = force_counter - 1;
end

    if ReadMeFlag == 1
        storeData(grid_array, sprintf('Run%d_GridArray.txt', run_num), filePath, force_amount);
    end

    if plot_flag == 1
        Plot_MeanGrid(tau_begin, tau_end, force_amplitude_begin, force_amplitude_end, grid_array);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



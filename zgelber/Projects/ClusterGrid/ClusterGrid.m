%Author: Zachary Gelber - **/**/2019

clc
clear all

addMatlabpath

Parameters_ClusterGrid;

if ReadMeFlag == 1
    Write_ClusterGrid;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


force_amount = floor((force_amplitude_end - force_amplitude_begin)/force_amplitude_steps)+1;
tau_amount = floor((tau_end - tau_begin)/tau_steps)+1;

grid_array = zeros(force_amount, tau_amount);

force_counter = force_amount;
tau_counter = 1;

for force_amplitude=force_amplitude_begin:force_amplitude_steps:force_amplitude_end
    disp('force amplitude')
    disp(force_amplitude)
    for tau=tau_begin:tau_steps:tau_end
        disp('tau')
        disp(tau)
        %temp_cluster_array = zeros(2, run_amount)
        if ReadMeFlag == 1
	    cd(filePathOutput)
	    mkdir(sprintf('FA:%g_Tau:%g', force_amplitude, tau));
            filePathOutputOutput = [filePathOutput, sprintf('FA:%g_Tau:%g/', force_amplitude, tau)];
        end
        for run_number=1:run_amount
            disp(run_number)
            n0=random_initial_conditions(Vbegin,Vend,Abegin,Aend,Cbegin,Cend);
            Constants=[tV,tC,tA,x,y,z,al,be,ga,de,a,b,c,d,k,force_amplitude,tau,g];
            try
                [tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants, insol, n0, tstart, tfinal);
                if ReadMeFlag == 1
                    storeData([tout,Vout,Aout,Cout,Hout,Fout,NorthF], sprintf('PP04_ModelOutput:%d', run_number), filePathOutputOutput, 7);
                end
                assert(sum(Vout(1:500)>0.5) > 150);
                %temp_cluster_array(1, run_number) = Vout(1);
                %temp_cluster_array(2, run_number) = Aout(1);
                %grid_array(force_counter, tau_counter) = cluster(temp_cluster_array, 0.1);
            catch
                disp('fail')
                %temp_cluster_array(1, run_number) = NaN;
                %temp_cluster_array(2, run_number) = NaN;
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
        %Plot_MeanGrid(tau_begin, tau_end, force_amplitude_begin, force_amplitude_end, grid_array);
    end

cd(current_dir)
disp('Done!')
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%Author: Zachary Gelber - 08/02/2019

clc              %Clears the command window.
clear all        %Clears all variables in the Workspace.

addMatlabpath    %Adds a path to certain directories so certain functions/scripts (like the 
                 %PP04 model) can be accessed by this script.


Parameters_Mean_Cycle_Windows;  %Calls the parameter file. Alter this file to change things like force amplitude.

if ReadMeFlag == 1              %If this flag is on, the data is saved to the file location specificied in the parameters file.
    Write_Mean_Cycle_Windows
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    initial_conditions = zeros(run_amount, 3);    						%The array holding the initial conditions for each run. Column 1 = V (total ice volume). Column 2 = A (Antarctic ice volume). Column 3 = C (CO2).
    number_of_windows = floor((window_tfinal-(size_of_windows*0.5))/(size_of_windows*0.5));     %The number of windows that will be looked at. Uses 50% overlap between windows.
    mean_window_array = zeros(run_amount, number_of_windows);					%The array holding the mean cycle length for each window and run. Rows are each run, while columns are each window.
    errors = [];										%The array holding the run number of any runs that failed for one reason or another. If empty then no runs failed.

    for run_number=1:run_amount
        %==========================%
        if rem(run_number, 25) == 0 
            disp(run_number)		%This displays the run number if it is a remainder of 25. Useful to check if the code is hanging or not. Can alter or remove as needed.
        end
        %==========================%

        counter = 1;
        V = Vbegin + (Vend-Vbegin)*rand(1,1);		%Creates a random set of initial conditions using the ranges specified in the parameter file.
        A = Abegin + (Aend-Abegin)*rand(1,1);
        C = Cbegin + (Cend-Cbegin)*rand(1,1);
        %initial_condition_string = ['V = ', num2str(V), ' A = ', num2str(A), ' C = ', num2str(C)];
        %disp(initial_condition_string)
        n0=[V,A,C];
        initial_conditions(run_number, :) = n0;
        try
            [tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0,tstart,tfinal);
            if ReadMeFlag == 1
                storeData([tout,Vout,Aout,Cout,Hout,Fout,NorthF], sprintf('PP04_ModelOutput_%d', run_number),filePathOutput,7);
            end

            for j=0:size_of_windows*0.0005:(window_tfinal-size_of_windows)*0.001
                cycle_tstart = floor(j*1000);
                cycle_tfinal = cycle_tstart+size_of_windows;
                try                             
                    Cycle_Statistics
                    assert(sum(Vout(cycle_tstart+1:cycle_tfinal)>0.5) > 150);
                    mean_window_array(run_number, counter) = avg_cycle;
                catch
                    mean_window_array(run_number, counter) = NaN;
                end
                counter = counter + 1;
            end
        catch
            errors = [errors, run_number];
            mean_window_array(run_number, :) = NaN;
        end
    end

    if run_amount ~= 1
        mean_vals = nanmean(mean_window_array);
    else
        mean_vals = mean_window_array;
    end

    if plot_flag == 1
        Plot_Mean_Cycle_Windows
    end

    if ReadMeFlag == 1
        storeData(initial_conditions, sprintf('PP04_%s_%g_%d_Window_InitialConditions.txt', descr, force_amplitude, run_num), filePath, 3);
        storeData(mean_window_array, sprintf('PP04_%s_%g_%d_Window_Output.txt', descr, force_amplitude, run_num), filePath, number_of_windows);
        if length(errors) > 0
            storeData(errors', sprintf('PP04_%s_%g_%d_Window_Errors.txt', descr, force_amplitude, run_num), filePath, 1);
        end 
    end

    disp('Done!')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




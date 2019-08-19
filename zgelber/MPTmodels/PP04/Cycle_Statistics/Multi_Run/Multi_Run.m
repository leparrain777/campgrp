%Author: Zachary Gelber - **/**/2019

clc
clear all

ReadMeFlag = 1;  %Choose if you want to save your results. Choosing to do so will save your parameters
		 %and values in a text file called 'PP04_%s_%s_%d_Multi_Run.txt' in your desired location.
run_num = 5;     %Set what run number this is. Only useful if saving output using the ReadMeFlag.
filePath = '/nfsbigdata1/campgrp/zgelber/Runs/Cycles/Multi_Run/';  %Choose where you want to save your output.

%Change the below parameters to see how different parameters affect cycle statistics%

% ================================ %

%Choose which variable you would like to vary. Make sure only one flag is on at a time%
vary_ratio_flag = 1;
vary_initial_condition_flag = 0;

if vary_ratio_flag == 1
    %Set a fixed initial condition here while your forcing parameter varies%
    n0 = [0, 0, 0.8]; %V (total ice volume), A (Antarctic ice), C (CO2 levels)% 

    %Change these to choose what forcing parameter you start and end at, as well as what step you are using%
    rbegin = 0.28;
    rend = 0.7;
    rsteps = 0.001;

    %Although you may want to calculate for very small step sizes, you may also want to plot a rougher average.
    %As an example, if your rsteps is 0.001 and your refine is 0.01, the code will calculate values for the 
    %0.001 step sizes, and in addition to plotting those, will also plot the average for 0.01 step sizes
    %using those 0.001 steps. If you do not wish to plot this, simply set refine equal to rsteps.
    refine = 0.1;
end

if vary_initial_condition_flag == 1
    %Set a fixed forcing parameter while your initial conditions vary%
    ratio = 1.09;

    %If you don't want to vary a particular variable, set the begin and end variable to be the same% 
    %Don't set the step variable to be 0, or else the code will not work%

    %Change these to choose what total ice volume you start and end at, as well as what steps you are using%
    Vbegin = 0;
    Vend = 1;
    Vsteps = 0.5;
    
    %Change these to choose what Antarctic ice volume you start and end at, as well as what steps you are using%
    Abegin = 0;
    Aend = 1;
    Asteps = 0.5;

    %Change these to choose what C02 level you start and end at, as well as what steps you are using%
    Cbegin = 0.8;
    Cend = 1;
    Csteps = 0.1;
end

%Change the time you want to calculate cycles statistics on%
tstart = 0000;    %kyr (0 is present day)
tfinal = 1000;  %kyr (0 is present day)

%Choose if you want to plot or not%
plot_flag = 1;

% ================================ %

counter = 1;
errors = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if vary_ratio_flag == 1
    run_amount = floor((rend-rbegin)/rsteps)+1;
    vals = zeros(run_amount, 2);

    for ratio = rbegin:rsteps:rend
        disp(ratio)
        try                              
            Cycle_Stats_Multi
            assert(sum(Vout(1:500)>0.5) > 150);
            vals(counter, 2) = avg_cycle;
        catch
            vals(counter, 2) = 0;
        end
        vals(counter, 1) = ratio;
       
%        num_of_120s = sum(full_cycles >= 115);
%        num_of_100s = sum(full_cycles < 115 | full_cycles > 85);
%        num_of_80s = sum(full_cycles >= 75 | full_cycles <=85);
               
%	vals(counter, 3) = num_of_120s;
%        vals(counter, 4) = num_of_100s;
%        vals(counter, 5) = num_of_80s;

        counter = counter + 1;
    end

    ratio_values = vals(:,1);
    mean_full_cycles = vals(:,2);
%    num_of_120s = vals(:,3);
%    num_of_100s = vals(:,4);
%    num_of_80s = vals(:,5);

    mean_full_cycles_to_plot = mean_full_cycles;

    if mean_full_cycles_to_plot(1) == 0
        check = 2;
        while mean_full_cycles_to_plot(check) == 0
            check = check + 1;
        end
        mean_full_cycles_to_plot(1) = mean_full_cycles_to_plot(check);
        error_insert = [ratio_values(1); mean_full_cycles_to_plot(1)];
        errors = [errors, error_insert];
    end


    for i=2:run_amount-1
        if mean_full_cycles_to_plot(i) == 0
            if mean_full_cycles_to_plot(i+1) ~= 0
                mean_full_cycles_to_plot(i) = (mean_full_cycles_to_plot(i-1)+mean_full_cycles_to_plot(i+1))/2;
	    else
	        mean_full_cycles_to_plot(i) = mean_full_cycles_to_plot(i-1)*0.9;
            end
            error_insert = [ratio_values(i); mean_full_cycles_to_plot(i)];
            errors = [errors, error_insert];
        end
    end

    modified_vals = vals;
    modified_vals(:,2) = mean_full_cycles_to_plot;
    refined_vals = Refine_Multi_Run(modified_vals, rbegin, rend, rsteps, refine);    

    if plot_flag == 1
        Plot_Multi_Run(modified_vals, refined_vals, errors, descr, tstart, tfinal);
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

elseif vary_initial_condition_flag == 1
    Vamount = floor((Vend-Vbegin)/Vsteps)+1;
    Aamount = floor((Aend-Abegin)/Asteps)+1;
    Camount = floor((Cend-Cbegin)/Csteps)+1;
    run_amount = Vamount*Aamount*Camount;
    vals = zeros(run_amount, 4);

    for V = Vbegin:Vsteps:Vend
        for A = Abegin:Asteps:Aend
            for C = Cbegin:Csteps:Cend
                initial_condition_string = ['V = ', num2str(V), ' A = ', num2str(A), ' C = ', num2str(C)];
                disp(initial_condition_string)
                n0 = [V,A,C];
                try
                    Cycle_Stats_Multi
                    assert(sum(Vout(1:500)>0.5) > 200);
                    vals(counter, 4) = avg_cycle;
                catch
                    vals(counter, 4) = 0;
                end
                vals(counter, 1) = V;
                vals(counter, 2) = A;
                vals(counter, 3) = C;
                counter = counter + 1;
            end
        end
    end
    
    Vrow = vals(:, 1);
    Arow = vals(:, 2);
    Crow = vals(:, 3);
    mean_full_cycles = vals(:,4);

    mean_full_cycles_to_plot = mean_full_cycles;

    if mean_full_cycles_to_plot(1) == 0
        check = 2;
        while mean_full_cycles_to_plot(check) == 0
            check = check + 1;
        end
        mean_full_cycles_to_plot(1) = mean_full_cycles_to_plot(check);
        error_insert = [Vrow(1); Arow(1); Crow(1); mean_full_cycles_to_plot(1)];
        errors = [errors, error_insert];
    end

    for i=2:run_amount-1
        if mean_full_cycles_to_plot(i) == 0
            if mean_full_cycles_to_plot(i+1) ~= 0
                mean_full_cycles_to_plot(i) = (mean_full_cycles_to_plot(i-1)+mean_full_cycles_to_plot(i+1))/2;
            else
                mean_full_cycles_to_plot(i) = mean_full_cycles_to_plot(i-1)*0.9;
            end
            error_insert = [Vrow(i); Arow(i); Crow(i); mean_full_cycles_to_plot(i)];
            errors = [errors, error_insert];
        end
    end

    if plot_flag == 1
        disp('No plot feature yet!')
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end

if ReadMeFlag == 1
    Write_Multi_Run;
end



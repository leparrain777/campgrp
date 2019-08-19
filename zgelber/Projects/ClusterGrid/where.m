%Author: Zachary Gelber - 08/02/2019

clc              %Clears the command window.
clear all        %Clears all variables in the Workspace.

addMatlabpath    %Adds a path to certain directories so certain functions/scripts (like the 
                 %PP04 model) can be accessed by this script.
pwhere;

run_amount = 100;
    Vbegin = 0;
    Vend = 1.5;
    Abegin = 0;
    Aend = 1.5;
    Cbegin = -0.4;
    Cend = 1.2;


tstart = 0000;
tfinal = 1500;
Constants(16) = 0.3; %force
Constants(17) = 1; %tau
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


    V_array = zeros(run_amount, tfinal+1);
    A_array = zeros(run_amount, tfinal+1);
    errors = [];
    for run_number=1:run_amount
        disp(run_number)		
        counter = 1;
        n0=random_initial_conditions(Vbegin,Vend,Abegin,Aend,Cbegin,Cend);
        try
            [tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04T_Main(Constants,insol,n0,tstart,tfinal);
            assert(sum(Vout(1:500)>0.5) > 150);
	    V_array(run_number, :) = Vout([1:tfinal+1]);
            A_array(run_number, :) = Aout([1:tfinal+1]);
        catch
            errors = [errors, run_number];
        end
    end

    figure;
    hold on
    for i=1:run_amount
        plot3([1:tfinal+1], A_array(i,:), V_array(i,:));
        scatter3(1, A_array(i,1), V_array(i,1));
    end
    hold off
    xlabel('time')
    ylabel('A')
    zlabel('V')
    set(gca, 'xlim', [0,50]);
    view(45, 20);
    set(gca, 'xdir', 'reverse');
    set(gca, 'ZDir', 'reverse');
    title_string = [descr, ' force amplitude: ', num2str(Constants(16)), ' tau: ', num2str(Constants(17))];
    title(title_string)
    input = [V_array(:,1), A_array(:,1)];
    output = cluster(input', 0.05);
    cluster_groups = unique(output(end, :))
    disp('Done!')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




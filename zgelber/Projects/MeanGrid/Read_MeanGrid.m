function grid_array = ReadMeanGrid(run_num, scale_by_tau, plot_flag)
current_dir = pwd;
filePath = '/nfsbigdata1/campgrp/zgelber/ProjectOutput/MeanGrid/';

cd(filePath)

if ~exist(sprintf('Run%d_MeanGrid', run_num), 'dir')
    cd(current_dir)
    error('This run doesn''t exist yet!')
end
filePath = [filePath, sprintf('Run%d_MeanGrid', run_num), '/'];
cd(sprintf('Run%d_MeanGrid', run_num))
fileName = sprintf('PP04_%d_MeanGrid.txt', run_num);
fname = strcat(filePath, fileName);
fid = fopen(fname);

force_line = 3;
tau_line = 4 - force_line;
cycle_line = 13 - (tau_line+force_line);

force_array = textscan(fid, '%s', 1, 'delimiter', '\n', 'headerlines', force_line-1);
tau_array = textscan(fid, '%s', 1, 'delimiter', '\n', 'headerlines', tau_line-1);
cycle_array = textscan(fid, '%s', 1, 'delimiter', '\n', 'headerlines', cycle_line-1);

force_string = strsplit(force_array{1}{1});
tau_string = strsplit(tau_array{1}{1});
cycle_string = strsplit(cycle_array{1}{1});

force_string = force_string([3,5,7]);
tau_string = tau_string([2,4,6]);
cycle_string = cycle_string([5,7]);

force_values = [str2num(force_string{1}), str2num(force_string{2}), str2num(force_string{3})];
tau_values = [str2num(tau_string{1}), str2num(tau_string{2}), str2num(tau_string{3})];
cycle_values = [str2num(cycle_string{1}), str2num(cycle_string{2})];

force_amplitude_begin = force_values(1);
force_amplitude_end = force_values(2);
force_amplitude_steps = force_values(3);
tau_begin = tau_values(1);
tau_end = tau_values(2);
tau_steps = tau_values(3);
cycle_tstart = cycle_values(1);
cycle_tfinal = cycle_values(2);

fclose(fid);

filePath = [filePath, 'ModelOutput/'];

force_amount = floor((force_amplitude_end - force_amplitude_begin)/force_amplitude_steps)+1;
tau_amount = floor((tau_end - tau_begin)/tau_steps)+1;

grid_array = zeros(force_amount, tau_amount);

force_counter = force_amount;
tau_counter = 1;

for force_amplitude=force_amplitude_begin:force_amplitude_steps:force_amplitude_end
    disp(force_amplitude)
    for tau=tau_begin:tau_steps:tau_end
       fileName = sprintf('PP04_FA:%g_Tau:%g_ModelOutput', force_amplitude, tau);
       Data = readData(fileName, filePath, 7);
       Hout = Data(:, 5);
       Cycle_Statistics_Grid;
       if scale_by_tau == 1
           avg_cycle = avg_cycle/tau;
       end
       grid_array(force_counter, tau_counter) = avg_cycle;

       tau_counter = tau_counter + 1; 
       if tau_counter > tau_amount
           tau_counter = 1;
       end
    end
    force_counter = force_counter - 1;
end

if plot_flag == 1
    Plot_MeanGrid(tau_begin, tau_end, force_amplitude_begin, force_amplitude_end, grid_array)
    title('testing')
end

cd(current_dir)
end

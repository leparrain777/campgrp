function Plot_EEMD(run_num)
% This function combines the functionality of
% PP04_Read_EEMD and Only_Plot_EEMD in order 
% to easily plot an EEMD of output data.
%
nmodes = PP04_Read_EEMD(run_num);
% Calls read script to read existing EEMD data txt file and create data array

Only_Plot_EEMD(nmodes, [1:size(nmodes,2)])
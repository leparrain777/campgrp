Mean_Cycle_Window README

This directory contains several scripts for running and analyzing windows of time from a PP04 model output.

files
    
    Analysis:

	Mean_Cycle_Windows.m        This is the main file. Call this script in order to run the code.
				    This file calculates the mean cycle length for a specified window of time from a PP04 model run.
				    By specifing a window of time (size_of_windows) and a run amount (run_amount) in the file
				    "Parameters_Mean_Cycle_Windows.m", this file does that many model runs (each with randomized initial conditions)
				    and then uses them to find the average cycle length for the specified window of time. The 
				    windows start at present day, and then move with 50% overlap (so if you specify windows of size 500 
				    (in kyr), the first window would be from 0-500, followed by 250-750, followed by 500-1000, and so on).
				    The result is a variable called "mean_window_array", where each row is a model run and each column represents
				    a window. If the plot flag is enabled, the columns are averaged and plotted in a line graph, where
				    the x-axis is the center of a window and the y-axis is the mean period of the glacial cycles for
				    that window. Note that sometimes a model run may hang or be locked into a warm state with no cycles.
				    The code has some measures to detect these instances, and if detected that particular run will be marked
				    with "NaN". Using the function "nanmean()" these values are ignored. You can still see them by viewing
				    "vals" however. The code also has a write routine using "Write_Mean_Cycle_Windows.m". After specifying
				    a location to save runs (filePath) and a run number (run_num) in the parameter file, the file will create a
				    new directory labeled "Run%" (% is whatever your run number is) with your parameters, model outputs, initial
				    conditions, and any errors that were detected.
				    For more options for this file, please read the instructions for "Parameters_Mean_Cycle_Windows.m" below.
                                    For more information on the write routine, please read the instructions for "Write_Mean_Cycle_Windows.m" below.

        Cycle_Stats_Multi.m         This file runs the PP04 model with the set parameters and evaluates the minimum, maximum, and
                                    average glacial cycle times for the run. It also find the minimum, maximum, and average
                                    times for warming events and cooling events respectively. The last stat it finds is a measure-
                                    ment of the asymmetry of the warming events and cooling events. Currently only the average
				    glacial cycle time is used. The other statistics calculated could also be used if desired
				    if modifications to the code were made.
        
	PP04_Params_Multi_Run.m     This is the parameter file that is called when running the PP04 model for Multi_Run.m. In 
				    this file you can change the other values of the PP04 model, in addition to the type of
				    insolation used.
   
    Plotting: 

	Plot_Multi_Run.m	    This file plots the mean cycle length of a specified time period versus the forcing parameter.
				    For parameters that cause a crash or create abnormal results, a blue star is plotted and is 
				    placed on a value between the previous and next ratio value. This is entirely for aesthetic
				    purposes, and is not indicative of its actual mean cycle length for this parameter.

    Miscellaneous:

	__README__Mean_Cycle_Window.txt     The README file for this directory. 
        
        


----------------------------------------------------- Zachary Gelber 07/22/19 ------------------------------------------------------

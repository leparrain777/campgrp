MeanGrid README

This directory contains several scripts for running and analyzing a grid of runs for the PP04 model.

files
    
    Analysis:

	MeanGrid.m		    This is the main file. Call this script in order to run the code.
				    This file runs a multitude of runs for a given range of force amplitude and tau values. Each combination 
				    of force amplitude and tau values does one successful run, and the mean cycle length is calculated 
				    for each run. An array is created containing each mean cycle length, where each row is a paritcular
				    force amplitude and each column is a particular tau value. A image with scaled colors is then created
				    using "imagesc()" to display the data.
				    You can change parameters like the range of force amplitude and tau values in the file. See "Parameters_MeanGrid.m"
				    below for more details.
				    A read and write routine also exist. See "Write_MeanGrid.m" and "Read_MeanGrid.m" below for more details.
				    All plotting is controlled by "Plot_MeanGrid.m". See below for more details.
	
	Parameters_MeanGrid.m	    This is the parameter file that "MeanGrid.m" uses. Below are a list of each changeable parameter and flag:
				    	ReadMeFlag - Set this flag to 1 if you want to save your model runs and array in the specified 
						     file location. Set to 0 otherwise.
				        filePath - Choose where your results will be saved if "ReadMeFlag" is set to 1.
					run_num - The run number the data will be saved under if "ReadMeFlag" is set to 1. Note that you
						  CANNOT save over another run number if it has been used. Change your run number or
						  delete the previous run to fix this.
					scale_by_tau - Choose whether or not you want to divide each mean cycle length result by its
						       corresponding tau value.
					force_amplitude_begin - The minimum of your range of force amplitude values you wish to test.
				        force_amplitude_end - The maximum of your range of force amplitude values you wish to test.
					force_amplitude_steps - The steps that will be taken in your range of force amplitude values
								you wish to test.
					tau_begin - The minimum of your range of tau values you wish to test.
					tau_end - The maximum of your range of tau values you wish to test.
					tau_steps - The steps that will be taken in your range of tau values you wish to test.
					Vbegin - The minimum of your V (total ice volume) values you may get in your random 
						 selection of initial conditions.
					Vend - The maximum of your V (total ice volume) values you may get in your random 
					       selection of initial conditions.
					Abegin - The minimum of your A (Antarctic ice volume) values you may get in your random 
						 selection of initial conditions.
					Aend - The maximum of your A (Antarctic ice volume) values you may get in your random 
					       selection of initial conditions.
					Cbegin - The minimum of your C (CO2) values you may get in your random 
						 selection of initial conditions.
					Cend - The maximum of your C (CO2) values you may get in your random 
					       selection of initial conditions.
					tstart - What time the model goes up to (i.e. if you do 0, the model will go to present day).
					tfinal - What time the model begins at (i.e. if you do 5000, the model will begin 5 million years ago).
					cycle_tstart - What time the model will analyze cycles up to (i.e. if cycle_tstart = 0 and
						       cycle_tfinal = 4000, the mean cycle length will be calculated from 4 million years ago 
						       to present day). Useful to remove the transient period.
					cycle_tfinal - What time the model will begin analyzing cycles.
					plot_flag - Set this flag to 1 if you want to plot when the model finishes running.
				     All parameters from the PP04 model can also be altered here, as well as the type of insolation.

	Write_MeanGrid.m	     Writes the model output for each run, a copy of the parameter file, and the resulting grid array
				     using the specified file location. The run is saved in a directory called "Run%_MeanGrid". It also
				     has a sub directory called "ModelOutput" that contains each model run, with labelled force 
				     amplitude and tau values for easy navigation.
					
	Read_MeanGrid.m		     Call using ReadMeanGrid(run_num, scale_by_tau_flag (0 or 1), plot_flag (0 or 1)). If the run number exists,
				     the model output will be read and the grid array will be recreated. The first argument "run_num" specifies
				     what run you want to read. The second argument "scale_by_tau_flag" specifies if you want to divide each
				     mean cycle length by its corresponding tau. The third argument "plot_flag" specifies if you want to plot
				     or not.
				
	Cycle_Statistics_Grid.m      Calculates the mean cycle length for a given run.														
    Plotting:

	Plot_MeanGrid.m		     This file plots a scaled colored image using the grid array from "MeanGrid.m". Uses "imagesc()".
				     The x_axis are tau values, while the y_axis are force amplitude values. A color bar is displayed
				     on the right of the plot to show what each color corresponds to. 

    Miscellaneous:
	
	addMatlabpath.m		    Adds a path to necessary directories to run the PP04 model. May have to alter if code is moved around.

	__README__MeanGrid.txt      The README file for this directory. 
        
        


----------------------------------------------------- Zachary Gelber 08/14/19 ------------------------------------------------------

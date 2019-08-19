Multi_Run README

This directory contains several scripts for running and analyzing multiple runs from the PP04 Model.

files
    
    Analysis:

	Multi_Run.m		    This file allows you to perform multiple runs from the PP04 model with varying parameters or 
				    initial conditions and report the mean cycle length for a specified time period. Each run is 
				    performed over a 5 million year time period, but you may set what time period the mean cycle
				    length is reported for (e.g. the mean cycle length for the last 500k years). Cycle_Stats_Multi.m
				    is called to perform the cycle statistics. You can choose to vary either the forcing parameters 
                                    (y and alpha from the PP04 paper) or the initial conditions of the total ice volume, Antarctic 
				    ice volume, and CO2 levels. For each variable you may choose a start point, end point, and step 
				    value. Note that if you do not want a certain value to vary (e.g. CO2 levels), set the start 
				    and end value equal to one another. Do not make the step value 0, otherwise the code will crash.

				    When varying the forcing parameter, you may choose a fixed initial condition. Similarly, when 
				    varying the initial condition, you may choose a fixed forcing parameter. There is a plot 
				    feature (using plot_Multi_Run.m) for varying the forcing parameter (which plots mean cycle 
				    length over the specified period versus the forcing parameter), but no such feature exists 
				    yet for varying the initial conditions. Note that some parameters will cause the model to 
				    output abnormal results, get stuck in an infinite loop, or simply crash. For the abnormal 
				    results and crashing, they are plotted with a blue star to indicate an error or abnormal 
				    result. Their placement on the plot is not at all indicative of their actual mean cycle length. 
				    They are simply plotted as the average of the previous and next value to keep the plot looking 
				    nice. You can see what values caused such errors by looking at the "errors" variable when the 
				    program finishes running. Unfortunately as of now, infinite loops cause the code to get stuck
				    as well.

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

	__README__Multi_Run.txt     The README file for this directory. 
        
        


----------------------------------------------------- Zachary Gelber 07/22/19 ------------------------------------------------------

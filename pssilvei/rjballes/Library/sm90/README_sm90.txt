SM90 Model README

This is a climate model from Saltzmann and Maasch, 1990

files:

    For Model Run:
        Forced Run
    
        sm90_params.m             This file sets the parameters to be used in the model
                                  run. It inclues the run number as well as all parameters
                                  and type of forcing.
        
        sm90.m                    This file sets up the system of differential equations
                                  for the model; to be called upon when using an ode solver
                                  to solve the system.
        
        sm90_co2_events.m         The ode solver has an option of determing the time and
                                  state of a desired event while solving the system of
                                  equations.  This file sets up determing the time and
                                  state of when the DE for the co2 term (ydot) equals zero;
                                  this is when the model supposedly transitions between
                                  warming and cooling phases.
        
        sm90_run_model.m          This file initiates the correct file paths and constructs
                                  a model run by setting the parameters, solving the system,
                                  printing the data (time steps, ice mass, CO2 concentration,
                                  ocean temp, and CO2 events) to a .txt file and generating
                                  figures if desired.
        
        readSM90Data.m            This file reads the previously stored data and outputs one
                                  array containing the time steps, ice mass, CO2 concentration,
                                  and ocean temp; a vector of the times steps of CO2 events;
                                  and an array of the ice mass, CO2, and ocean temp at the
                                  corresponding event times.
                                  
        sm90_tempplot.m           This file reads the stored data of the specified model
                                  run number and creates a figure of temporal plot for
                                  the three variables.

   
                
   
   For EEMD Run:   
    
       sm90_params_EEMD.m         This file sets the parameters for the EEMD including the
                                  the run number and forcing type used, which should
                                  correspond to the model run. Edit this accordingly before
                                  running an EEMD. It also prints a params .txt file to 
                                  EEMD_Runs.
                                  
       Run_SM90_EEMD.m            This file reads the data from the model run, calls the
                                  eemd function, stores the EEMD data in a .txt file in
                                  EEMD_Runs, and plots a figure if desired.
                                  
       sm90_plot_eemd.m           This file takes in the run number and plots the EEMD.     
      
       sm90_readeemd.m            This file reads the .txt file of a completed EEMD.
                                  
                                  

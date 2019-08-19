PP04 Model README

This is a climate model from Paillard and Perrenin, 2004

files:

    For Model Run:
    
        addMatlabpath.m           This file adds the structure of the model to the local file
                                  path. It is initiaed in Run_PP04_Model.
    
        PP04_Params_Model_Run.m   This file sets the parameters to be used in the model
                                  run. It inclues the run number as well as all parameters
                                  and type of forcing. It also prints a text file
                                  containg all chosen parameters in Model_Runs.
        
        PP04_Main.m               This file solves the system of ODE's for the given
                                  parameters and choice of forcing and prints the data to a 
                                  text file in Model_Runs using storeData.
        
        PP04_viewModel.m          This file reads the previously stored data and generates
                                  a figure of the three separate variables. It is only
                                  called if the ModelFigFlag is set to 1 in 
                                  PP04_Params_Model_Run
                                  
        Run_PP04_Model.m          This file initiates the correct file paths and constructs
                                  a model run by setting the parameters, solving the
                                  system, printing the data to a .txt file and generating
                                  figures if desired.

            ***Note***

                This routine is also reliant upon readData.m, storeData.m, and various read
                files for differnt types of forcing/insolation all located in 
                ~/campgrp/Lib/Matlab/DataReadFiles.    
                
   
   For EEMD Run:   
    
       PP04_Params_EEMD.m         This file sets the parameters for the EEMD including the
                                  the run number and forcing type used, which should
                                  correspond to the model run. Edit this accordingly before
                                  running an EEMD. It also prints a params .txt file to 
                                  EEMD_Runs.
        
       Only_Plot_EEMD.m           This file plots an EEMD by receiving the data and the
                                  desired number of modes.
                                  
       Run_PP04_EEMD.m            This file reads the data from the model run, calls the
                                  eemd function, stores the EEMD data in a .txt file in
                                  EEMD_Runs, and plots a figure if desired.
                                  
       Plot_EEMD.m                This file takes in the run number and plots the EEMD.     
      
       PP04_Read_EEMD.m           This file reads the .txt file of a completed EEMD. It
                                  takes a run number and returns the corresponding data.
                                  
                                  
------------------------------------------------------- Brian Knight 06/27/18 --------------------------------------------------------------
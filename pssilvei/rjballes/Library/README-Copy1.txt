Climate Research README
Andrew Gallatin
5/11/2016


Ashwin Model:
    dir: '/ashwin'
    To run the model execute the script 'runAshwin.m'. Requires 'ashwin.m', 'params.m'.
    Parameter search is contained in 'insolTestAshwin.m'
    Previous work stored in '/Data' and '/Plots'
    

SM90 Model:
    dir: '/sm90'
    Code for forced model in '/Forced' and unforced model in '/unforced'\
    To run forced model execute script 'sm90Sim.m'. Requires 'sm90.m'
    To run unforced model execute script 'sm90UnforcedSim.m'. Requires 'sm90Unforced.m'
    
    
SM91 Model:
    dir: '/sm91'
    '/IntegratedParamSearch' contains code required to run parameter searches with SM91.  
        '/IntegratedParamSearch/Data' and 'IntegratedParamSearch/Plots' contain all runs of SM91 with Huybers integrated insolation.
    '/TheAllTuned' contains code for SM91 with integrated insolation tuned for ratio and periodicity.
    '/TheIntegratedPaperParams' contains code for SM91 with the original paper parameters and integraded insolation.
    '/TheIntegratedRatio' contains code for SM91 with integrated insolation tuned for ratio (no periodicity tuning).
    '/TheLaskarRatio' contains code for SM91 with Laskar insolation runed for ratio.
    '/TheOriginal' contains code for SM91 with the original paper parameters.
    
    To run SM91 in any of the above directories execute 'runSM91.m'. 
        Requires 'params.m', 'sm91Full.m', 'PlotEEMDDataTrend.m', 'storeData.m', 'crossing.m'
        
Statistics:
    Note that most of the statistics have been taken from Ryan Smith's statistics suites.  Refer to his work for more information.
    Most directories in '/sm91' contain the required scripts for running statistics on the models.
    '/DO18Statistics' contains the code required to run statistics on the DO18 record.
    To run statistics on data, execute 'statMain.m'. 
        Requires 'statParam.m', 'statComputeScript.m', 'statFigScript.m'
        Modify 'statParam.m' as necessary for models.
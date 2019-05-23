Cycle_Statistics README

This directory contains several scripts for analyzing and plotting glacial cycles from the PP04 Model.

files
    
    Analysis:
        
        Cycle_Stats.m               This file runs the PP04 model with the set parameters and evaluates the minimum, maximum, and
                                    average glacial cycle times for the run. It also find the minimum, maximum, and average
                                    times for warming events and cooling events respectively. The last stat it finds is a measure-
                                    ment of the asymmetry of the warming events and cooling events.*Further improvements to this
                                    script would be to implement more interesting statics and values from Partial_Melts, as well
                                    as distributions a lot of the data from which we find these statistics.
        
        Partial_Melts.m             This file begins by running the PP04 model, it then finds the times of the warming and cooling
                                    events and uses them to calculate maximums and minimums of global ice volume (V) during
                                    cooling events to count the number of partial melts in each cycle. It also finds the cycles
                                    and coordinates which have local max/min distances from the analytical trigger line. This file
                                    may be used to count partial melts or assist in picking out unique cycles to analyze further
                                    by plotting using the plot scrips in this directory.
    
    Plotting: 
        
        Plot_Cycle.m                This file plots the nth cycle, corresponding to the nth element of the full_cycles array
                                    (i.e., if the full_cycles array has a very short cycle in the 10th index, calling
                                    Plot_Cycle(n) will plot the cycle of interest. Plot_Cycle(1) will plot the most recent cycle
                                    of the model run, while Plot_Cycle(end) will plot the oldest cycle in the run.
                                    Note: the file also runs the PP04 model, so many of these files could be condensed into a more
                                    efficient suite of stats and plots with some slight manipulation.
        
        MinTrigger_Plot.m           This file takes a cycle number, 'l', and begins by calling the Partial_Melts script to
                                    initialize values and find the points of minimum distance to the trigger in cycle 'l'. After
                                    finding the appropriate values it plots these minimum points and then calls Plot_Cycle on 'l'
                                    to plot the appropriate cycle along with the min trigger points. Note: this is inefficient for
                                    plotting multiple cycles using a subplot routine, but could be manipulated to fit that use
                                    better by taking in an array of cycles to plot.
                                    
        Plot_Slow_Cycles.m          This file is a brief subplot routine to view multiple cycles at once.
        
        


----------------------------------------------------- Brian Knight 07/19/18 ------------------------------------------------------
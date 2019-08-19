%Author: Zachary Gelber - 08/02/2019

% ================================ %

ReadMeFlag = 1;  %Choose if you want to save your results. Choosing to do so will save your parameters
		 %and values in a text file called 'PP04_(insolation)_(force amplitude)_(run number)_
                 %1k_Window.txt' in your desired location.
run_num = 1;     %Set what run number this is. Only useful if saving output using the ReadMeFlag.
filePath = '/nfsbigdata1/campgrp/zgelber/ProjectOutput/Q2Grid/';  %Choose where you want to your output.

% ================================ %

    
    force_amplitude = 0.5;          %Choose what force amplitude you would like to use.
  
    k1_begin = 0;
    k1_end = 2;
    k1_steps = 0.01;

    k2_begin = 0;
    k2_end = 2;
    k2_steps = 0.01;

    %For each run, a random random is selected for V (total ice volume), A (Antarctic ice volume), and C (CO2)
    %from the ranges given below. Note that V and A are typically truncated at 0, so it is recommened not to go lower.
    Vbegin = 0;
    Vend = 1.5;
    Abegin = 0;
    Aend = 1.5;
    Cbegin = -0.4;
    Cend = 1.2;

    %Choose how long you want to run the PP04 model for. It is recommended you run the model for about a million
    %years longer than you need (up to 5000) to account for the transient. For example, if you are only 
    %interested in the last 2 million years, you may only want to run the model from present day (0000) to
    %3000k years ago. You can still run the full model if you desire, but you may waste time doing so.
    tstart = 0000;
    tfinal = 5000;

    cycle_tstart = 0000;
    cycle_tfinal = 4000;

% ================================ %
        %For non-drift runs, set k=0. For drift runs, it is recommended to set k=8.5*10^-5, although other values
        %can be used if desired.

%Time constants
tV=15;       %15
tC=5;       %5
tA=12;         %12
%Constants
x=1.3;          %1.3
y=0.5;         %0.5        %.15
z=0.8;          %0.8
al=0.15;        %0.15       %0.05
be=0.5;         %0.5
ga=0.5;         %0.5
de=0.4;         %0.4        %0.454
a=0.3;          %0.3
b=0.7;          %0.7
c=0;         %0.01  %Possibly overfitting. Set to 0.
d=0.27;         %0.27
k=0*8.5*10^-5; %0*10^-5; %8.5*10^-5;
g=0*2*10^-5; %10*10^-5;            %-2.0*10^-5;     %0

% ================================ %

%Insolation Flags
%Note, only one flag should be on at a time;
insolNoneFlag = 0;
insol1MoFlag = 0;
insol3MoFlag = 0;
insol5MoFlag = 0;
insol7MoFlag = 0;
insolHuybersIntegratedFlag = 0;
insolPeriodicFlag = 1;

if insolNoneFlag == 1
    descr = 'insolNone';
    insol = 0;
elseif insol1MoFlag == 1
    descr = 'insol1Mo';
    insol = 1;
elseif insol3MoFlag == 1
    descr = 'insol3Mo';
    insol = 2;
elseif insol5MoFlag == 1
    descr = 'insol5Mo';
    insol = 3;
elseif insol7MoFlag == 1
    descr = 'insol7Mo';
    insol = 4;
elseif insolHuybersIntegratedFlag == 1
    descr = 'insolHuybersIntegrated';
    insol = 5;
elseif insolPeriodicFlag == 1
    descr = 'insolPeriodic';
    insol = 6;
end

% ================================ %


%Choose if you want to plot or not%
plot_flag = 1;

%Turn this flag on if you are a chill guy%
chill_flag = 1;

% ================================ %

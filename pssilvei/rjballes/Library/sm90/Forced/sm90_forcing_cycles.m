% This script reads in the data from model run of various strengths of forcing, and computes the average periodicity of cyces timed by events of where derivative of CO2 variable is zero. 
% We also look at individual cycles to find interesting behavior.


avg_cycle_times = [];
for k=47:54
   % General Flags and runID
   runID = k;

   % Identifies data of model runs by the forcing used
   %descr = 'insolHuybersIntegrated';
   descr = 'insolLaskar';
   %descr = 'solsticeLaskar';
   %descr = 'unforced';

   fileName = sprintf('SM90_%s_%d_forcing_Model.txt',descr,runID);
   filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/ForcingSearch/';

   [data,fullMat,iceMat,eventsMat] = sm90_find_cycles(fileName,filePath);

   % Separating the variables
   t = data(:,1);
   I = data(:,2);  %./1.3;
   Mu = data(:,3);  %./26.3;
   Theta = data(:,4);  %./0.7;

   tmin_co2 = fullMat(:,1);
   tmax_co2 = fullMat(:,2);

   maxI_k = iceMat(:,1);
   minI_k = iceMat(:,2);
   next_maxI_k = iceMat(:,3);

   tmin = eventsMat(:,1);
   ye_min = eventsMat(:,2:4);
   tmax = eventsMat(:,5);
   ye_max = eventsMat(:,6:8);


   % Finding lengths of full cycles, and warm/cool phases, adn partial melts
   full_times = [];
   warm_times = [];
   cool_times = [];
   idMax_parI = [];
   idMin_parI = [];
   for i=1:length(tmin_co2)-1
      %full = t(tmin_co2(i+1)) - t(tmin_co2(i));
      %warm = t(tmax_co2(i)) - t(tmin_co2(i));
      %cool = t(tmin_co2(i+1)) - t(tmax_co2(i));
      
      full = tmin(i+1) - tmin(i);
      warm = tmax(i) - tmin(i);
      cool = tmin(i+1) - tmax(i);
         
      % Constructing vecotrs of lengths of full cycles, warming and cooling phases
      full_times = [full_times 10*full];
      warm_times = [warm_times 10*warm];
      cool_times = [cool_times 10*cool];
         
   end %for
   
end %for
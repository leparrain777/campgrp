% This script produces a matrix of all time-state variables of interest
% Need the following scripts to run:
%   sm90_find_cycles.m

% General Flags and runID
runID = 7;
% Identifies data of model runs by the forcing used
descr = 'insolHuybersIntegrated';
%descr = 'insolLaskar';

fileName = sprintf('SM90_%s_%d_Model.txt',descr,runID);
filePath = '/nfsbigdata1/campgrp/rjballes/ModelRuns/sm90/Forced/';

sm90_find_cycles

% Creates an array of the following variables (in that order):
% tstart, Istart, Mustart, Thetastart := values at start of cycle
% tswitch, Iswitch, Muswitch, Thetaswitch := values at switch of phase of cycle
% tend, Iend, Muend, Thetaend := values at end of cycle
% tmax, Imax, Mumax, Thetamax := values at maximum ice mass
% tmin, Imin, Mumin, Thetamin := values at minimum ice mass
% deltat1 := (tswitch-tstart) 
% delta2 := (tend - tswitch)
% delta3 := Imax - Imin
% delta4 := (Imax-Imin)/Imax
Data = [25,Inf];
for j=1:length(MinAt)-1
   Data(1,j) = t(MinAt(j));
   Data(2,j) = t(MaxAt(j));
   Data(3,j) = t(MinAt(j+1));
   Data(4,j) = t(MinAt(j+1)) - t(MinAt(j));
   Data(5,j) = t(MaxAt(j)) - t(MinAt(j));
   Data(6,j) = t(MinAt(j+1)) - t(MaxAt(j));
   Data(7,j) = t(maxIat(j));
   Data(8,j) = t(minIat(j));

   Data(9,j) = I(MinAt(j));
   Data(10,j) = I(MaxAt(j));
   Data(11,j) = I(MinAt(j+1));
   Data(12,j) = I(maxIat(j));
   Data(13,j) = I(minIat(j));
   Data(14,j) = I(maxIat(j)) - I(minIat(j));
   Data(15,j) = (I(maxIat(j)) - I(minIat(j)))/I(maxIat(j));

   Data(16,j) = Mu(MinAt(j));
   Data(17,j) = Mu(MaxAt(j));
   Data(18,j) = Mu(MinAt(j+1));
   Data(19,j) = Mu(maxIat(j));
   Data(20,j) = Mu(minIat(j));

   Data(21,j) = Theta(MinAt(j));
   Data(22,j) = Theta(MaxAt(j));
   Data(23,j) = Theta(MinAt(j+1));
   Data(24,j) = Theta(maxIat(j));
   Data(25,j) = Theta(minIat(j));

end %for

% Reorganizes matrix so each row is a cycle and each column is a variable
D = Data';

% Creating the correlation matrix of the variables
corrMat = corrcoef(D);

% Plotting heat map of coefficient matrix
var_names = ["Tstart","Tswitch","Tend","Tfull","Wt","CT","tmaxI","tminI", "Istart", "Iswitch", "Iend", "Imax","Imin","dI","dI/I",...
"Mustart","Muswitch","Muend","Mumax","Mumin","Thetastart","Thetaswitch","Thetaend","Thetamax","Thetamin"];
var_names = cellstr(var_names); % Constructs character array
%var_names = fliplr(var_names);

heatmap = HeatMap(corrMat, 'RowLabels', var_names, 'ColumnLabels', var_names, 'Symmetric', 0);
addTitle(heatmap, 'SM90 Correlations Between Time-State Variables, Deltas');
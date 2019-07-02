function run_sm90_strength_eemd(runID)

descr = 'insolLaskar'
fileReadName = sprintf('SM91_%s_%d_Model.txt',descr,runID);
fileReadPath = '~/campgrp/rjballes/ModelRuns/sm91/';

[Data,~,~] = readSM91Data(fileReadName,fileReadPath,4); % Edit the 7 for the number of columns in your output, this will just read each column

x1 = Data(:,2); 
% I am assuming here that Global Ice Mass is the first column of your output, if not, change Data(:,1)
% *NOTE*: this can also be used for analysis of deep ocean temp for comparison with Toby's Temp Data Analysis, might be more interesting?
    
tviews=0;
tviewf=5000; % however long of a run you are doing (kyrs)
data=-1.*x1(1:tviewf+1); % Negative sign may or may not be necessary, depedning on your data's orientation?

%if sum(strength == forcing_coeff) == 0
%    error('please enter a valid strength of forcing used')
%else
%    count = find(strength == forcing_coeff);
%end % if


% -------------------------------- %

whiteNoise = 0.4 % 40 percent
iterations=(whiteNoise*100)^2;
nmodes = eemd(data,whiteNoise,iterations);
fileName = sprintf('SM91_Run%d_EEMD.txt',runID);
filePath = '~/campgrp/rjballes/EEMDRuns/sm91/ForcingSearch/';
storeData(nmodes,fileName,filePath,size(nmodes,2));

%if EEMDFigFlag == 1
%    figure
%    Only_Plot_EEMD(nmodes,[1:size(nmodes,2)]);
%end % if

% -----------------------------------

disp('done')

end % function
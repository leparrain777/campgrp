clc
clear all
addMatlabpath
PP04_Params_EEMD

if lr04DataFlag ~= 1    
  Data = readData(fileReadName,fileReadPath,7);
  Vout=Data(:,2);
else
  Data = lrdata;
  Vout=Data(2,:);
end
  
tviews=0;
tviewf=2000;
data=-1*Vout(1:tviewf+1);

% --------------------------------

nmodes = eemd(data,whiteNoise,iterations);
fileName = sprintf('PP04_Run%d_EEMD.txt',run_num);
storeData(nmodes,fileName,filePath,size(nmodes,2));

if ReadMeFlag == 1
	fprintf(fid, 'Number of IMFs:\n%d\n', size(nmodes, 2));
	fprintf(fid, 'Number of data points:\n%d\n', size(nmodes, 1));
	fprintf(fid, '\n\nNotes:\n');
	fclose(fid);
end

if EEMDFigFlag == 1
    figure
    Only_Plot_EEMD(nmodes,[1:size(nmodes,2)]);
    title_str = ['Run ', num2str(run_num), ' ', descr, ' White Noise: ', num2str(100*whiteNoise), '%'];
    title(title_str);
end

% -----------------------------------

disp('done')

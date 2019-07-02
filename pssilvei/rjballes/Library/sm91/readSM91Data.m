function [Data,te,ye] = readSM91Data(fileName,filePath,cols)

% This function reads text file of data from SM91 model runs
% Takes in the name of the file, its path, and the number of columns
% Produces an array D of the data, a column vector te of extrema of co2, and an array ye
% of the state variables at the event times.

fname = strcat(filePath,fileName);

x = '%g';
y = '';
for i=1:cols
    y = sprintf('%s %s',y,x);
end
fid = fopen(fname,'r');

Data = fscanf(fid,y,[cols,inf]);              %Scan the data into a colxInf array
fclose(fid);

%Data(Data == -99999) = NaN;
Data = Data';

te = Data(1:end-5001,1);
ye = Data(1:end-5001,2:4);
Data = Data(end-5000:end,:);

end

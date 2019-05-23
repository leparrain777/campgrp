function Data = readData(fileName,filePath,col)
% function [Data] = readData(fileName,filePath,col)
% This function takes as input a file name, file path, and the number of
% of your Data vector, then reads the data from the file into Data.

fname = strcat(filePath,fileName);

x = '%g';
y = '';
for i=1:col
    y = sprintf('%s %s',y,x);
end
fid = fopen(fname,'r');

Data = fscanf(fid,y,[col,inf]);              %Scan the data into a colxInf array
fclose(fid);

%Data(Data == -99999) = NaN;
Data = Data';
end

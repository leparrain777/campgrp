function storeData(Data,fileName,filePath,col)
% function storeData(Data,fileName,filePath,col)
% This function takes as input your Data matrix, the fileName you wish to print
% it to, the filePath, and the number of columns you wish to store it with.
DataT = Data';

x = '%g';
fmt = '';
for i=1:col
    fmt = sprintf('%s %s',fmt,x);
end
fmt = strcat(fmt,'\n');

fname = strcat(filePath,fileName);
fid = fopen(fname,'w');

fprintf(fid,fmt,DataT);
fclose(fid);

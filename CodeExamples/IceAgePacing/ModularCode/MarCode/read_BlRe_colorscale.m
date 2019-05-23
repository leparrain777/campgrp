function cmapBlRe = read_BlRe_colorscale;
%
% function colorRGB = read_BlRe_colorscale;
%   reads in rgb values for BlRe (Blue-Red) colormap
%   96 colors
%
filepath = './';
filename = sprintf('%sBlRe_colorscale_rgb,txt',filepath);
%
fid = fopen(filename, 'r');
%
nheader = 2;
for i=1:nheader
    aline = fgets(fid);
end %for
%
fmt = '%i %i %i';
temp=fscanf(fid,fmt,[3 Inf]);
cmapBlRe = temp'./256;
fclose(fid);
%
end


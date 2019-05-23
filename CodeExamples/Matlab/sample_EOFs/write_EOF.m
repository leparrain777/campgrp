function [] = write_EOF(EOF_spatial,PC, nEOFwrt, time, lat, lon)

% write PC
nt = length(time);
s_data = zeros(nt,nEOFwrt);
s_data(:,1) = time;
for f = 2:nEOFwrt;
    s_data(:,f) = squeeze(PC(:,f));
end
fid = fopen('temp_PC','w');
fprintf(fid,'%10.4f%10.4f\n',s_data);
fclose(fid);

% write EOF
for g = 1:nEOFwrt;
    e1 = EOF_spatial(:,:,g);
    id = strcat('temp_EOF', '_', int2str(g));
    fid = fopen(id,'w');
    fprintf(fid,'%10.4f',lat);
    fprintf(fid,'\n');
    fprintf(fid,'%10.4f',lon);
    fprintf(fid,'\n');
    for ilat = 1:14
        fprintf(fid,'%10.4f',e1(ilat,:));
        fprintf(fid,'\n');
    end;
    fclose(fid);
end
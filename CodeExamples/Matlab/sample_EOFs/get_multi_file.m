function[d] = get_multi_file(ti, tf, level, name, fpath)
t_total = (1+(tf-ti))*12;
d = zeros([t_total 46 72]);
for i=ti:tf;
    for j =1:12;
        fname = strcat(fpath,int2str(i),'-', sprintf('%2.2i', j), '.nc');
        nc = netcdf(fname);
        t = ((i-ti)*12)+j;
        v = nc{name}(:,:,:);
        d(t,:,:) = squeeze(v(level,:,:));
        close(nc)
    end
end

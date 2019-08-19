if vary_ratio_flag == 1
    descr_2 = 'r';
elseif vary_initial_condition_flag == 1
    descr_2 = 'i';
end

    fileName = sprintf('PP04_%s_%s_%d_Multi_Run.txt', descr, descr_2, run_num);
    fname = strcat(filePath,fileName);
    fid = fopen(fname, 'w');
    fprintf(fid, 'PP04_%s_%s_%d_Multi_Run\n', descr, descr_2, run_num);
    fprintf(fid, '\nMulti Run Parameters\n\n');
    if vary_ratio_flag == 1
        fprintf(fid, 'Initial Conditions:\nV: %f, A: %f, C: %f\n\n', n0(1), n0(2), n0(3));
        fprintf(fid, 'rbegin: %f\n', rbegin);
        fprintf(fid, 'rend: %f\n', rend);
        fprintf(fid, 'rsteps: %f\n', rsteps);
        fprintf(fid, 'refine: %f\n\n', refine);
    elseif vary_initial_condition_flag == 1
        fprintf(fid, 'Forcing Ratio: %f\n', ratio);
        fprintf(fid, 'Vbegin: %f\n', Vbegin);
        fprintf(fid, 'Vend: %f\n', Vend);
        fprintf(fid, 'Vsteps: %f\n', Vsteps);
        fprintf(fid, 'Abegin: %f\n', Abegin);
        fprintf(fid, 'Aend: %f\n', Aend);
        fprintf(fid, 'Asteps: %f\n', Asteps);
        fprintf(fid, 'Cbegin: %f\n', Cbegin);
        fprintf(fid, 'Cend: %f\n', Cend);
        fprintf(fid, 'Csteps: %f\n\n', Csteps);
    end
    fprintf(fid, 'tstart: %f\n', tstart);
    fprintf(fid, 'tfinal: %f\n', tfinal);

    fprintf(fid, '\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n');

DataT = vals';

x = '%g';
fmt = '';
for i=1:2
    fmt = sprintf('%s %s',fmt,x);
end
fmt = strcat(fmt,'\n');
fprintf(fid, fmt, DataT);

    fclose(fid);

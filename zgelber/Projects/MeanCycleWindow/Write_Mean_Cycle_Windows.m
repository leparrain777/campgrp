current_dir = pwd;

cd(filePath)
if exist(sprintf('Run%d', run_num), 'dir')
    error('This run number has already been used. To prevent this error, change your run number or delete the directory using this run number')
end

mkdir(sprintf('Run%d', run_num))
cd(sprintf('Run%d', run_num))
mkdir ModelOutput

filePath = [filePath, sprintf('Run%d/', run_num)];
filePathOutput = [filePath, 'ModelOutput/'];

    fileName = sprintf('PP04_%s_%g_%d_MeanCycleWindow.txt', descr, force_amplitude, run_num);
    fname = strcat(filePath,fileName);
    fid = fopen(fname, 'w');
    fprintf(fid, 'PP04_%s_%g_%d_MeanCycleWindow_Parameters\n', descr, force_amplitude, run_num);
        fprintf(fid, 'Force Amplitude: %g\n', force_amplitude);
        fprintf(fid, 'Runs Averaged: %g\n', run_amount);
        fprintf(fid, 'Vbegin: %g\n', Vbegin);
        fprintf(fid, 'Vend: %g\n', Vend);
        fprintf(fid, 'Abegin: %g\n', Abegin);
        fprintf(fid, 'Aend: %g\n', Aend);
        fprintf(fid, 'Cbegin: %g\n', Cbegin);
        fprintf(fid, 'Cend: %g\n', Cend);
        fprintf(fid, '\nModel Run Insolation:\n');
        fprintf(fid,'%s\n',descr);
        fprintf(fid,'\nConstants:\n');
        fprintf(fid,'tV = %g\n',tV);
        fprintf(fid,'tA = %g\n',tA);
        fprintf(fid,'tC = %g\n',tC);
        fprintf(fid,'x  = %g\n',x);
        fprintf(fid,'y  = %g\n',y*force_amplitude);
        fprintf(fid,'z  = %g\n',z);
        fprintf(fid,'al = %g\n',al*force_amplitude);
        fprintf(fid,'be = %g\n',be);
        fprintf(fid,'ga = %g\n',ga);
        fprintf(fid,'de = %g\n',de);
        fprintf(fid,'a  = %g\n',a);
        fprintf(fid,'b  = %g\n',b);
        fprintf(fid,'c  = %g\n',c);
        fprintf(fid,'d  = %g\n',d);
        fprintf(fid,'k  = %g\n',k);
        fprintf(fid,'g  = %g\n',g);
        fprintf(fid,'\n\nNotes:\n');
        fprintf(fid, '\n%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n\n');
    fclose(fid);

cd(current_dir)





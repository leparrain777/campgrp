%
% Save Ice-Age TS output to file
%
sfname = sprintf('%s%s',sfpath,basefilename);
%
fid = fopen(sfname,'w');
%
% Header
fprintf(fid,'Ice Age PP: run #%i\n',runNumber');
fprintf(fid,'Model: %s, Forcing: %s\n',mname, fname);
%
% Maximal Lyapunov Exponents
fprintf(fid,'Maximal Lyapunov Exponents: mrun integrations\n');
switch nIC
    case 1
        fmt = '%12.8f\n';
    otherwise
        fmt = [repmat('%12.8f ',[1 nIC-1]) '%12.8f\n'];
end
fprintf(fid, fmt, lyap);
%
% Time Series
fprintf(fid,'Time Series Data\n');
fprintf(fid,'Each IC integration: nt rows X ny+1 columns\n');
fprintf(fid,'  Col.1: time; Col.2 - ny+1: state variables\n');
fprintf(fid,'Repeat for each integration: nrun blocks of data\n');
fprintf(fid,'ny nt nrun\n');
fprintf(fid,'%i %i %i\n',[ny nt nIC]);
fmt = [repmat('%12.8f ',[1 ny]) '%12.8f\n'];
for irun = 1:nIC
    temp = squeeze(yy(:,:,irun));
    fprintf(fid, fmt, [tt'; temp]);
end %for
%
fclose(fid);

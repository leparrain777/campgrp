%
% Save Ice-Age TAU output to file
%
sfname = sprintf('%s%s',sfpath,basefilename);
%
fid = fopen(sfname,'w');
%
% Header
fprintf(fid,'Ice Age LYA: run #%i\n',runNumber');
fprintf(fid,'Model: %s, Forcing: %s\n',mname, fname);
%
fprintf(fid,'nk1 nk2\n');
fprintf(fid,'%i %i\n', nk1, nk2);
%
% Tau Values
fprintf(fid,'k1:\n');
fmt = [repmat('%12.8f ',[1 nk1-1]) '%12.8f\n'];
fprintf(fid, fmt, k1);
%
% Amplitude Values
fprintf(fid,'k2:\n');
fmt = [repmat('%12.8f ',[1 nk2-1]) '%12.8f\n'];
fprintf(fid, fmt, k2);
%
% Maximal Lyapunov Exponents
fprintf(fid,'Maximal Lyapunov Exponents:\n');
fprintf(fid,'  Columns: k2; Rows: k1\n');
fmt = [repmat('%12.8f ',[1 nk1-1]) '%12.8f\n'];
for jj = 1:nk2
  fprintf(fid, fmt, lyap(jj,:));
end % for
%
%
% Winding number
fprintf(fid,'Winding:\n');
fprintf(fid,'  Columns: k2; Rows: k1\n');
fmt = [repmat('%12.8f ',[1 nk1-1]) '%12.8f\n'];
for jj = 1:nk2
  fprintf(fid, fmt, wind(jj,:));
end % for
%
fclose(fid);

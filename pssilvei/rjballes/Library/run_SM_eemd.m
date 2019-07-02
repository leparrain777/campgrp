addMatlabpath_rjballes
%sm90_params
%sm90_model_forcing
sm90_u_vals = 0.32:0.003:0.37;
sm90_runs = 116:170;

%sm91_params
%sm91_model_forcing
sm91_u_vals = 0.54:0.003:0.57;
sm91_runs = 64:74;

%count = 1;
for i = sm90_runs
   run_sm90_strength_eemd(i);
end %for


%for k = sm91_runs
%   run_sm91_strength_eemd(k);
%end %for

exit;
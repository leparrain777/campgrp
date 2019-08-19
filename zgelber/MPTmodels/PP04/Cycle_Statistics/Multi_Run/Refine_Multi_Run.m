function modified_vals = Refine_Multi_Run(vals, rbegin, rend, rsteps, refine)
ratio_vals = vals(:,1);
mean_full_cycles = vals(:,2);

excess = (rend-rbegin+rsteps)/refine;
modified_amount = floor(excess);
if excess - floor(excess) < 10^-12
    modifeid_vals = zeros(modified_amount, 2);
else
    modified_vals = zeros(modified_amount + 1, 2);
end

new_steps = floor(refine/rsteps);
for i=1:modified_amount
    modified_vals(i, 1) = mean(ratio_vals(((i-1)*new_steps)+1:i*new_steps));
    modified_vals(i, 2) = mean(mean_full_cycles(((i-1)*new_steps)+1:i*new_steps));
end

if excess - floor(excess) > 10^-12
    modified_vals(end, 1) = mean(ratio_vals(modified_amount*new_steps+1:end));
    modified_vals(end, 2) = mean(mean_full_cycles(modified_amount*new_steps+1:end));
end


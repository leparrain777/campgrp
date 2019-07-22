
parfor hello = 1:16
    bigun(:,:,hello) = sv92_run_model((hello + 34) *10);
end
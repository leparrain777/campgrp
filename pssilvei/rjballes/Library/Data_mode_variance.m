function var_ratios = Data_mode_variance()
% Data_mode_variance collects the mode variance ratio for 3 data sets, Huybers, LR04, LR04 untuned, for 500kya, 800kya, 1000kya time series


huybersflag = 1;
lr_tunedflag = 1;
lr_untunedflag = 1;

figflag = 0;

if lr_untunedflag == 1
    
    fileName = sprintf('lr04_untuned_eemd.txt');
    filePath = '~/campgrp/brknight/Data/';
    nmodes= readData(fileName,filePath,11);
    
    huybers_var_ratio = [];
    
    for i = [500,800,1000]
        
        var_fast = var(nmodes(1:i,4)+nmodes(1:i,5));
        var_slow = var(nmodes(1:i,6)+nmodes(1:i,7));
        
        huybers_var_ratio = [huybers_var_ratio, var_fast/var_slow];
        
    end % for
    
    if figflag == 1
        Only_Plot_EEMD(nmodes,1:11)
    end % if

end % if

if lr_tunedflag == 1
    
    fileName = sprintf('lr04_tuned_eemd.txt');
    filePath = '~/campgrp/brknight/Data/';
    nmodes= readData(fileName,filePath,13);
    
    tuned_var_ratio = [];
    
    for i = [500,800,1000]
        
        var_fast = var(nmodes(1:i,4)+nmodes(1:i,5));
        var_slow = var(nmodes(1:i,6)+nmodes(1:i,7));
        
        tuned_var_ratio = [tuned_var_ratio, var_fast/var_slow];
        
    end % for

    if figflag == 1
        Only_Plot_EEMD(nmodes,1:13)
    end % if
     
end % if

if huybersflag == 1
    
    fileName = sprintf('huyberseemd.txt');
    filePath = '~/campgrp/brknight/Data/';
    nmodes= readData(fileName,filePath,11);
    
    untuned_var_ratio = [];
    
    for i = [500,800,1000]
        
        var_fast = var(nmodes(1:i,4)+nmodes(1:i,5));
        var_slow = var(nmodes(1:i,6)+nmodes(1:i,7));
        
        untuned_var_ratio = [untuned_var_ratio, var_fast/var_slow];
        
    end % for
    
    if figflag == 1
        Only_Plot_EEMD(nmodes,1:11)
    end % if

end % if

var_ratios = [huybers_var_ratio;tuned_var_ratio;untuned_var_ratio];
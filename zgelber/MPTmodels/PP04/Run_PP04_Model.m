clc
clear all

addMatlabpath
PP04_Params_Model_Run

%n0=[0,0,0.8];
[tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0,tstart,tfinal);

fileName = sprintf('PP04_%s_%d_Model.txt',descr,run_num);
storeData([tout,Vout,Aout,Cout,Hout,Fout,NorthF],fileName,filePath,7);

if ModelFigFlag == 1
    PP04_viewModel(fileName,filePath,0,5000);
end

disp('done')

if ModelFigFlag == 1
    title(sprintf('Run %g, %s, n0=[0,0,0.8] y=%g, al=%g, c=%g', run_num, descr, Constants(5),...
        Constants(7),Constants(13)))
end

% figure
% hold on
% col = 'b';
% temp_plot_phase
% insol=0;
% [~,Vout,Aout,~,Hout,~,~] = PP04_Main(Constants,insol,n0);
% col='k';
% temp_plot_phase
% hold off
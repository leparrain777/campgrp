% plot evolution of T_f that is used in the model.  See caption of
% figure 2 in the paper for where the information from this plot
% went into the paper.
clear all; close all
T_F_0=2.0;
C_T_f=10.0;
time=[-1500:1:0]
T_F=min(T_F_0+C_T_f*time/1000,-3.0);
plot(time,T_F)

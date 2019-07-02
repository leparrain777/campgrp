
tic

figure;
[eemdFig,nmodes] = PlotEEMD(I,0.5,2000,6);

eemdFig = gcf;
print(eemdFig,'-dpdf','sm91eemd');

fileName = 'sm91eemdOut.txt';
filePath = '/nfsbigdata1/campgrp/agallati/sm91/Polished/Data/';
etime = [-5000:1:0]';
storeData([etime,nmodes],fileName,filePath,14);

toc

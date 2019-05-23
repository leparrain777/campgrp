function PP04_viewModel(fileName,filePath,tviews,tviewf)
%function PP04_viewModel(fileName,filePath,tviews,tviewf)
%This program displays a model as a graph
%tviews is the most recent time, tviewf is the oldest time
%0 <= tviews < tviewf <= 2000

Data = readData(fileName,filePath,7);
tout=Data(:,1);
Vout=Data(:,2);
Aout=Data(:,3);
Cout=Data(:,4);
Hout=Data(:,5);
Fout=Data(:,6);
%NorthF=Data(:,7);

figure('units','normalized','position',[0 0 1 1]);

% subplot(4,1,1)
% plot(tout,NorthF)
% axis([tviews,tviewf,min(NorthF),max(NorthF)])
% ylabel('Normalized Insolation');
trig=[];
for i=tviews+1:tviewf-1
    if Hout(i+1)<Hout(i)
        if isempty(trig) || trig(end)~= i-1
            trig=[trig,i];
    end
end

subplot(3,1,1)
plot(tout,Vout,tout,Aout)
axis ij
axis([tviews,tviewf,min([Vout;Aout]),max([Vout;Aout])])
ylabel('Ice Volume, Ice Sheet');

subplot(3,1,2)
plot(tout,Cout)
axis([tviews,tviewf,min(Cout),max(Cout)])
ylabel('CO2');

subplot(3,1,3)
plot(tout,Fout,tout,(Hout-1)*.3)
axis([tviews,tviewf,min(-.3,min(Fout)),max(Fout)])
xlabel('Age')
ylabel('F parameter');

if length(trig)>1
    for i=1:length(trig)-1
        text(trig(i),-0.07*mod(i,4)-0.05,sprintf('%g',trig(i+1)-trig(i)));
    end
end

end
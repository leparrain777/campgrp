function [tout,Vout,Aout,Cout,Hout,Fout,NorthF] = PP04_Main(Constants,insol,n0)
%PP04 model main file
%Author: Zach Cooperband

%Time constants
tV=Constants(1);
tC=Constants(2);
tA=Constants(3);
%Constants
x=Constants(4);
y=Constants(5);
z=Constants(6);
al=Constants(7);
be=Constants(8);
ga=Constants(9);
de=Constants(10);
a=Constants(11);
b=Constants(12);
c=Constants(13);
d=Constants(14);
k=Constants(15);
if length(Constants) == 16
    g=Constants(16);
else
    g=0;
end

%Other conditions
tstart=0000;
tfinal=5000;
refine=4;

% ===== Forcing ===== %
[~,SouthF]=read_PP04_Insolation('60S_21st_Feb.txt',tstart,tfinal);

if insol == 0
    NorthF = zeros(tfinal+1,1);
    SouthF = zeros(tfinal+1,1);
    time1 = [0:tfinal]';
end
if insol == 1
    [time1,NorthF]=read_PP04_Insolation('65N_21st_June.txt',tstart,tfinal);
end
if insol == 2
    [time1,temp1]=readLaskarInsolation(6,tfinal,tstart);
    [~,temp2]=readLaskarInsolation(7,tfinal,tstart);
    [~,temp3]=readLaskarInsolation(8,tfinal,tstart);
    NorthF = temp1+temp2+temp3;
end
if insol == 3
    [time1,temp1]=read_PP04_Insolation('65N_5thMo.txt',tstart,tfinal);
    [~,temp2]=read_PP04_Insolation('65N_6thMo.txt',tstart,tfinal);
    [~,temp3]=read_PP04_Insolation('65N_7thMo.txt',tstart,tfinal);
    [~,temp4]=read_PP04_Insolation('65N_8thMo.txt',tstart,tfinal);
    [~,temp5]=read_PP04_Insolation('65N_9thMo.txt',tstart,tfinal);
    NorthF = temp1+temp2+temp3+temp4+temp5;
end
if insol == 4
    [time1,temp1]=read_PP04_Insolation('65N_5thMo.txt',tstart,tfinal);
    [~,temp2]=read_PP04_Insolation('65N_6thMo.txt',tstart,tfinal);
    [~,temp3]=read_PP04_Insolation('65N_7thMo.txt',tstart,tfinal);
    [~,temp4]=read_PP04_Insolation('65N_8thMo.txt',tstart,tfinal);
    [~,temp5]=read_PP04_Insolation('65N_9thMo.txt',tstart,tfinal);
    [~,temp6]=read_PP04_Insolation('65N_4thMo.txt',tstart,tfinal);
    [~,temp7]=read_PP04_Insolation('65N_10thMo.txt',tstart,tfinal);
    NorthF = temp1+temp2+temp3+temp4+temp5+temp6+temp7;
end
if insol == 5
    [time1,NorthF] = integratedInsolation(tstart,tfinal);
    time1=time1';
    NorthF=NorthF';
end
timecheck = [0:9]';
if time1(1:10) ~= timecheck
    disp('error, possible insolation mistake')
    time1(1:10)
    timecheck
end

NorthF=flipud(NorthF);
SouthF=flipud(SouthF);
if insol ~= 0
    NorthF=(NorthF-mean(NorthF))/std(NorthF);
    SouthF=(SouthF-mean(SouthF))/std(SouthF);
end

% ===== ODE SOLVE ===== %

options=odeset('Events',@events,'Refine',refine,'NonNegative',[1,2]);
tnow=0;
tout=tnow;
Vout=n0(1);
Aout=n0(2);
Cout=n0(3);
Fout=max(a*n0(1)-b*n0(2)-c*SouthF(1)+d+k*(-tfinal),0);
if Fout>0
    Fglacial=1;
    Hout=0;
else
    Fglacial=-1;
    Hout=1;
end
teout=[];
neout=[];

while tnow~=tfinal-tstart
    %Solve until an event
    [t,n,te,ne,~] = ode45(@ode,[tnow,tfinal-tstart],n0,options);
    
    nt=length(t);
    tout=[tout;t(2:nt)];
    Vout=[Vout;n(2:nt,1)];
    Aout=[Aout;n(2:nt,2)];
    Cout=[Cout;n(2:nt,3)];
    for i=2:nt
        %Linear Approx
        p=floor(t(i))+1;
        f=ceil(t(i))+1;
        I60=SouthF(p)+(t(i)+1-p)*(SouthF(f)-SouthF(p));
        Fnext=max(a*n(i,1)-b*n(i,2)-c*I60+d+k*(t(i)-tfinal));
        Fout=[Fout;Fnext];
        
        if Fglacial<1
            Hout=[Hout;1];
        else
            Hout=[Hout;0];
        end
    end

    teout=[teout;te];
    neout=[neout;ne];

    n0=n(nt,:);
    Fglacial=Fglacial*-1;
    
    options = odeset(options,'InitialStep',t(nt)-t(nt-refine),...
                     'MaxStep',t(nt)-t(1));
    tnow=t(nt);
end

%Interpolate to regular intervals:
interv=[0:tfinal];
Vout=flipud(interp1(tout,Vout,interv,'pchip')');
Aout=flipud(interp1(tout,Aout,interv,'pchip')');
Cout=flipud(interp1(tout,Cout,interv,'pchip')');
Hout=flipud(interp1(tout,Hout,interv,'pchip')');
Fout=flipud(interp1(tout,Fout,interv,'pchip')');
tout=interv';
NorthF=flipud(NorthF);
SouthF=flipud(SouthF);
             



% -------------------------------------
    function dndt = ode(t,n)
        dndt=zeros(3,1);
    %Linear Approx
    p=floor(t)+1;
    f=ceil(t)+1;
    I60=SouthF(p)+(t+1-p)*(SouthF(f)-SouthF(p));
    I65=NorthF(p)+(t+1-p)*(NorthF(f)-NorthF(p));
    dndt(1)=(-x*n(3)-y*I65+z-n(1))/tV;
    dndt(2)=(n(1)-n(2))/tA;
    if Fglacial<0
        H=1;
    else
        H=0;
    end
    dndt(3)=(al*I65-be*n(1)+ga*H+de+g*(t-tfinal)-n(3))/tC;
    end
% -------------------------------------
    function [value,isterminal,direction] = events(t,n)
    % Locate the time when v=vend and stop integration.
    %Linear Approx
    p=floor(t)+1;
    f=ceil(t)+1;
    I60=SouthF(p)+(t+1-p)*(SouthF(f)-SouthF(p));
    
    value=a*n(1)-b*n(2)-c*I60+d+k*(t-tfinal);
    isterminal = 1;
    direction=0;
    end
% -------------------------------------

end
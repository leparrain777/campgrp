%PP04_Params_Multi_Run

%Change the parameters here
% ================================ %

%Model Run Control
	%For non-drift runs, set k=0. For drift runs, it is recommended to set k=8.5*10^-5, although other values
	%can be used if desired.

%Time constants
tV=15;       %15
tC=5;       %5
tA=12;         %12
%Constants
x=1.3;          %1.3
y=0.5;         %0.5        %.15
z=0.8;          %0.8
al=0.15;        %0.15       %0.05
be=0.5;         %0.5
ga=0.5;         %0.5
de=0.4;         %0.4        %0.454
a=0.3;          %0.3
b=0.7;          %0.7
c=0;         %0.01  %Possibly overfitting. Set to 0.
d=0.27;         %0.27
k=0*8.5*10^-5; %0*10^-5; %8.5*10^-5;
g=0*2*10^-5; %10*10^-5;            %-2.0*10^-5;     %0        
Constants=[tV,tC,tA,x,y,z,al,be,ga,de,a,b,c,d,k,0,g];

% ================================ %

%Insolation Flags
%Note, only one flag should be on at a time;
insolNoneFlag = 0;
insol1MoFlag = 0;
insol3MoFlag = 0;
insol5MoFlag = 0;
insol7MoFlag = 0;
insolHuybersIntegratedFlag = 1;

if insolNoneFlag == 1
    descr = 'insolNone';
    insol = 0;
elseif insol1MoFlag == 1
    descr = 'insol1Mo';
    insol = 1;
elseif insol3MoFlag == 1
    descr = 'insol3Mo';
    insol = 2;
elseif insol5MoFlag == 1
    descr = 'insol5Mo';
    insol = 3;
elseif insol7MoFlag == 1
    descr = 'insol7Mo';
    insol = 4;
elseif insolHuybersIntegratedFlag == 1
    descr = 'insolHuybersIntegrated';
    insol = 5;
end

% ================================ %



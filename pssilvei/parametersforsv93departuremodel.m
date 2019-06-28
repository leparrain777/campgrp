timeofrunstart= -2000000;
%Start time of run in years. Should always be negative.

global timefromrunstart;
timefromrunstart=0;
%Should always be 0 in this file, but we change it in other scripts.

syms t; t = timefromrunstart;
%Make t a short name for timefromrunstart.


bedrockdepression=@() t+1;
syms D(t) ; D(t) = bedrockdepression; D(t)
syms mu(t) ; mu(t) = atmosphericcarbondioxideconcentration; mu(t)
syms I(t) ; I(t)=globalicemass; I(t)
syms theta(t) ; theta(t)=deepoceantemperature; theta(t)


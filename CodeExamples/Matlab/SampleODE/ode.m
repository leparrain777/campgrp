function xprime = ode(t,x,param,r,s,ftime,f)
% This is a sample ode function to illustrate passing parameters 
% through ode45 and using time-dependent forcing terms.

% Here, p,q,r,s are fixed parameters.  These are passed through ode45 as seen in sampleScript.m
% There are two ways that make passing parameters easy:
%	1. using a vector to store parameters and passing that vector 
%		(E.g. param)
%	2. passing the parameters directly
%		(E.g. r,s)

% Set up of parameters:
p = param(1);
q = param(2);
r = r; % not needed
s = s; % not needed

% Now we can use p,q,r,s in the equation for the model just like any other variable.

% For time-dependent terms like f, you need to pass a list of times that f is evaluated 
% as well as the values of f at those times
%	E.g. ftime is a list of times at which f has been evaluated
%	     f is a list of values that correspond to each time in ftime

% Set up forcing term (in the diff eq, f(t) is force):
% Note: using interp1 to interpolate a value at time t
% 	Remember that ode45 dictates the value of t, so it may not be in ftime.
force = interp1(ftime,f,t);

% This interpolates the values of f at an arbitrary time t (used by ode45).
% Now we can use force in the equation for the model just like any other variable.

% The differential equation: dx/dt = p*x^2 + q*r*x - s*f(t)
xprime = p - q*r*x + s*force;

end

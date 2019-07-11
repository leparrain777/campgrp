% The tectonic-average (equilibrium) solution found in the Saltzman 1990 paper.
% sol(1) is ice mass stable-state solution at time t
% sol(2) is CO2 concentration stable-state solution at time t
% sol(3) is deep ocean temperature stable-state solution at time t
%
% This is a dimensionalized model.

% Date: 30 June 2014
% Author: Andrew Gallatin

function sol = sm90Tectonic(t);

sol = [
   17.0 - 15.9*tanh(0.004*(-35*(t/100) + 425)) ;
   -35*(t/100) + 425 ;
   -0.7 + 7.9*tanh(0.004*(-35*(t/100) + 425))
];

end

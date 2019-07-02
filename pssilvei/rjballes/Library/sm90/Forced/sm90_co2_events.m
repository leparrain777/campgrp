function [extrs,isterminal,direction] = sm90_co2_events(t,x)

% This function is to be used when solving the SM90 system.
% This events function finds the local max/min of co2 where
% the derivative of co2 is zero.

extrs = -1.0*x(3) + 0.9*x(2) + 1*(x(3)^2) - 0.5*x(2)*x(3) - (x(3)^2)*x(2);  % Find where ydot=0
isterminal = 0;  % Does not terminate when finds event
direction = 0;  % Want both max and min

end
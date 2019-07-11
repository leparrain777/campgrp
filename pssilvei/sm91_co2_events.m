function [extrs,isterminal,direction] = sm91_co2_events(t,x)

% This function is to be used when solving the SM91 system.
% This events function finds the local max/min of co2 where
% the derivative of co2 is zero.

extrs = -1*x(3) + 1.3*x(2) - 0.6*x(2)^2 - x(2)^3;  % Find where ydot=0
isterminal = 0;  % Does not terminate when finds event
direction = 0;  % Want both max and min

end
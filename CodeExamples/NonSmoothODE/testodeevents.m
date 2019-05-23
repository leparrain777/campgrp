function [value,isterminal,direction]=testodeevents(t,y,p)
% function [value,isterminal,direction]=testodeevents(t,y,p)
%
%	sets the thresholds at which transitions from growth to decay
%        or vice versa occur
%
%     Inputs:
%       p(1) = state: the current state: 0-growth, 1-decay
%       p(6) = ymax:  threshold for growth-decay transition
%       p(7) = ymin:  threshold for decay-growth transition
%      
%     Outputs:
%	there can be many events, each supplies an element to
%	the following 3 output arrays
%      value(i):  value of the i-th event-function (formula)
%	       event occurs when value=0 is crossed during integration
%      isterminal(i): if 1 - stop integration, 0 - don't stop
%      direction(i):  if +1 - event only if value increases through zero
%                     if -1 - event only if value decreases through zero
%                     if 0  - event if zero crossed in either direection
%
state = p(1);
ymax  = p(6);
ymin  = p(7);
%
%	1st event (the only one in this case)
switch state
  case {0}   % growth to decay transition
    value(1) = y-ymax;     % stop if y > ymin
    isterminal(1) = 1;     % stop the integration
    direction(1) = 1;      % only stop if increasing
  case {1}   % decay to growth transition
    value(1) = y-ymin;     % stop if y < ymin
    isterminal(1) = 1;     % stop the integration
    direction(1) = -1;     % only stop if decreasing
end

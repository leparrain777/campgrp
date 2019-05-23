function dydt = testode(t, y, p);
% function dydt = testode(t, y, p);
%
%
state = p(1);
%
switch state
  case {0} % Growth State (a>0)
    a = p(2);
    b = p(3);
  case {1} % Decay state (a<0)
   a = p(4);
   b = p(5);
end
dydt = a*y + b;
%

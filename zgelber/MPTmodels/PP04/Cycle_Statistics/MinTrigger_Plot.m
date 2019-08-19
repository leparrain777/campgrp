function MinTrigger_Plot(l)

% Takes a cycle number, from ppmelts, and colors in the supposed points of minimum trigger distance
% This is to eisure the Partial_Melts algorithm is working properly

% initialization
Partial_Melts

% finds location of points with minimum distance from the trigger line
m = find(min_dist(1,:) == l);
q = min_dist(2, m);


hold on

% Plots minimum trigger points
if trig_warm(1) > trig_cool(1)
    plot(Aout(trig_cool(l+1)-q),Vout(trig_cool(l+1)-q), '.r', 'MarkerSize', 20, 'HandleVisibility', 'off') % Don't show in legend
else
    plot(Aout(trig_cool(l)-q),Vout(trig_cool(l)-q), '.r', 'MarkerSize', 20, 'HandleVisibility', 'off') % " "
end

Plot_Cycle(l)

hold off
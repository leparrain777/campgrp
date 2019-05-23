%
%   Script for generating simple figures for a review sheet
%	standalone: just run as is, no other scripts/functiosn needed
%
clear all;  % clears all variables from worksapce
close all;  % closes all figures
%
printflg = 1;   % control flag for printing figures (0 - don't print)
fignum = 0;     % initialize figure number counter
%
fignum = fignum+1;  % increment figure number counter
figure(fignum);     % open new figure
%
%                   Create plot of a subdivided rectangle
x = [0:0.01:2]';    
y = x./2;
%
H = plot(x,y*0,'k','LineWidth', 2.0);
hold on             % allows overplotting (multiple curves)
plot(x, y*0+1, 'k','LineWidth', 2.0);
plot(x*0, y, 'k','LineWidth', 2.0);
plot(x*0+.5, y, 'k','LineWidth', 2.0);
plot(x*0+1, y, 'k','LineWidth', 2.0);
plot(x*0+1.5, y, 'k','LineWidth', 2.0);
plot(x*0+2, y, 'k','LineWidth', 2.0);
hold off            % ends overplotting
%
set(gca, 'Visible', 'off');     % Remove the axes completely
%
if (printflg)                              % if printflg != 0, print
    fname = sprintf('Fig%i',fignum);       % base filename
    print('-deps', strcat(fname,'.eps'));  % print eps figure to file
    print('-dpdf', strcat(fname,'.pdf'));  % print pdf figure to file
end %if
%
%                     New figure
fignum = fignum+1;  % increment figure number counter
figure(fignum);     % open new figure
%
t = [0:0.1:360]';
y = (350-68)*exp(-t/60)+68;
%
h = plot(t, y, 'k', 'LineWidth', 2.0);
hold on;
plot(t, y*0.0+68, 'k--');       % add horizontal asymptote (light, dashed)
hold off;
xlim([0 360]);                  % change displayed bounds in x
ylim([0 360]);                  % change displayed bounds in y
%
yticks = get(gca,'YTick');      % get default locataions for y tickmarks
yticks = sort([yticks, 68]);    % add 68 to the default yticks (in order)
set(gca, 'YTick', yticks);      % use new set of yticks
%
xl = xlabel('t (min)');         % add labels to axes
yl = ylabel('T (\circF)');      % recognizes a few Latex commands!
set(gca,'FontWeight','bold','FontSize',11);
set(xl,'FontWeight','bold','FontSize',11);
set(yl,'FontWeight','bold','FontSize',11);
%
if (printflg)                              % if printflg != 0, print
    fname = sprintf('Fig%i',fignum);       % base filename
    print('-deps', strcat(fname,'.eps'));  % print eps figure to file
    print('-dpdf', strcat(fname,'.pdf'));  % print pdf figure to file
end %if
%
%                     New figure
fignum = fignum+1;  % increment figure number counter
figure(fignum);     % open new figure
%
x = [-1:0.1:6]';
y = 1 - 0.25*(x-3).^2;
%
h = plot(x, y, 'k', 'LineWidth', 2.0);
hold on
plot(x,y*0,'k--');
plot(x*0,2*y,'k--');              % add axes inside plot
hold off
%
% xlim([0 360]);                  % change displayed bounds in x
 ylim([-2 1.5]);                  % change displayed bounds in y
%
% yticks = get(gca,'YTick');      % get default locataions for y tickmarks
% yticks = sort([yticks, 68]);    % add 68 to the default yticks (in
% order)
% set(gca, 'YTick', yticks);      % use new set of yticks
%
xl = xlabel('x');         % add labels to axes
yl = ylabel('y');      % recognizes a few Latex commands!
legend('y = df / dx');
set(gca,'FontWeight','bold','FontSize',11);
set(xl,'FontWeight','bold','FontSize',11);
set(yl,'FontWeight','bold','FontSize',11);
%
if (printflg)                              % if printflg != 0, print
    fname = sprintf('Fig%i',fignum);       % base filename
    print('-deps', strcat(fname,'.eps'));  % print eps figure to file
    print('-dpdf', strcat(fname,'.pdf'));  % print pdf figure to file
end %if

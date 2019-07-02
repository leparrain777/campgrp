function partial_melts(sum_mode, high_sd, low_sd, title_amend)
addMatlabpath_rjballes;
t_time = 1:length(sum_mode);


figureflag = 1;

[fullmax, fullmin] = extrema(sum_mode);

if fullmax(2,1) > fullmin(2,1)
    if fullmax(end-1,1) > fullmin(end-1,1)
        fullmax = fullmax(1:end-1,:);
        fullmin = fullmin(2:end,:);
        disp('used 1')
    else % fullmax(end-1,1) < fullmin(end-1,1)
        fullmax = fullmax(1:end-1,:);
        fullmin = fullmin(2:end-1,:);
        disp('used 2')
    end % if
else % if maxes(2,1) < mins(2,1)
    if fullmax(end-1,1) > fullmin(end-1,1)
        fullmax = fullmax(2:end-2,:);
        fullmin = fullmin(2:end-1,:);
        disp('used 3')
    else % fullmax(end-1,1) < fullmin(end-1,1)
        fullmax = fullmax(2:end-1,:);
        fullmin = fullmin(2:end-1,:);
        disp('used 4')
    end % if
end % if

if length(fullmax) ~= length(fullmin)
   dupl = [];
   for k=1:length(fullmin)-1
      if fullmin(k,2) == fullmin(k+1,2)
         dupl = [dupl k];
      end %if
   end %for
   fullmin(dupl,:) = [];
   
   dupl=[];
   for k=1:length(fullmax)-1
      if fullmax(k,2) == fullmax(k+1,2)
         dupl = [dupl k];
      end %if
   end %for
   fullmax(dupl,:) = [];
end %if

my_std = std(sum_mode);

tmax = t_time(fullmax(1:end,1));
maxEO = fullmax(1:end,2);
tmin = t_time(fullmin(1:end,1));
minEO = fullmin(1:end,2);

melts = maxEO(1:end) - minEO(1:end);
%melts = melts(melts > low_sd*my_std)

isfull = (melts > high_sd*my_std);
issmall = (melts < low_sd*my_std);
issmall
sum(isfull)
tfull = tmax(isfull);
tpartial = tmax(~isfull & ~issmall);

dtfull = -(tfull(1:end-1) - tfull(2:end));

tmaxfull = tmax(isfull)
tminfull = tmin(isfull)

fullmelttimes = (tmaxfull(2:end) - tminfull(2:end))
if sum(fullmelttimes<0) > 0
    fullmelttimes = tminfull(2:end)-tmaxfull(2:end)
end % if
builds = maxEO(2:end) - minEO(1:end-1);
fullbuildtimes = (tmaxfull(2:end) - tminfull(1:end-1));

melt_ratio = fullbuildtimes./ fullmelttimes
mean(melt_ratio)



[r, p] = corrcoef(maxEO(isfull), minEO(isfull))

% We need an absolute measure of ice volume to do a ratio
%[j, k] = corrcoef(melts(isfull)./minEO(isfull), minEO(isfull))

dtpartial = [];

for i = flip(2:(length(tfull)))
    add_dtpartial = tfull(i) - tpartial(tpartial < tfull(i) & tpartial > tfull(i-1));
    
    dtpartial = [dtpartial, add_dtpartial];

end




if figureflag

    hold on;

    %% Plotting results
    
    figure(1)
    clf(1)
    hold on;
    Msize = 15;
    plot(t_time, sum_mode)
    plot(tmax(isfull), maxEO(isfull), 'r.', 'MarkerSize', 35);
    plot(tmax(~isfull & ~issmall), maxEO(~isfull & ~issmall), 'm.', 'MarkerSize', Msize);
    plot(tmin(isfull), minEO(isfull), 'b.', 'MarkerSize', 35);
    plot(tmin(~isfull & ~issmall), minEO(~isfull & ~issmall), 'c.', 'MarkerSize', Msize);
    %plot(spline(tmax,maxEO,1:950),'r.') 
    %plot(spline(tmin,minEO,1:950), 'b.') 
    title(sprintf('Data with max / mins - %s', title_amend))
    hold off;


    hold on;
    figure(2)
    clf(2)
    hist(melts(~issmall), 25)
    title(sprintf('Distribution of Melts - Line at %d SDs - %s', high_sd, title_amend))
    line([high_sd*my_std, high_sd*my_std], [0, 4])
    hold off;


    figure(3)
    clf(3)
    hist(dtfull);
    title(sprintf('Distribution of Time between Full Melts - Cutoff at %d SDs - %s', high_sd, title_amend))

    figure(4)
    clf(4)
    scatter(maxEO(isfull), minEO(isfull))
    title(sprintf('Max/Min Ice Volumes of Full Melts - Cutoff at %d SDs - %s', high_sd, title_amend))

    figure(5)
    clf(5)
    [m, l] = corrcoef(melts(isfull), minEO(isfull))
    scatter(minEO(isfull), melts(isfull))
    title(sprintf('Max Ice Volumes/Delta V of Full Melts - Cutoff at %d SDs - %s', high_sd, title_amend))

    figure(6)
    clf(6)
    hist(dtpartial)
    title(sprintf('Distribution of Time between Full Melts and Partial Melts - Cutoff at %d SDs - %s', high_sd, title_amend))
end
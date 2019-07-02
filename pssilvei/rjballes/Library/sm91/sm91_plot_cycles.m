% This script plots cycles for SM91

% Plotting cycles for I vs Mu
fig1 = figure;
for k=1:25    
   t1 = tmin_co2(k);
   t2 = tmin_co2(k+1);
   e1 = tmax_co2(k);
   %e2 = ;
   %e3 = ;
   subplot(5,5,k)
   hold on;
   plot(Mu(t1:t2),I(t1:t2),'k-')
   plot(Mu(t1),I(t1),'ro')
   plot(Mu(e1),I(e1),'bo')
   plot(Mu(t2),I(t2),'ro')
   %plot([Mu(t1) Mu(e1)],[I(t1) I(e1)],'g--')
   title([' ' num2str(10*t(tmin_co2(k))) ' to ' num2str(10*t(tmin_co2(k+1))) ' (ka) Cycle'])
   hold off;
end %for
fig2 = figure;
for k=26:min(50,length(tmin_co2)-1)      
   t1 = tmin_co2(k);
   t2 = tmin_co2(k+1);
   e1 = tmax_co2(k);
   %e2 = ;
   %e3 = ;
   subplot(5,5,k-25)
   hold on;
   plot(Mu(t1:t2),I(t1:t2),'k-')
   plot(Mu(t1),I(t1),'ro')
   plot(Mu(e1),I(e1),'bo')
   plot(Mu(t2),I(t2),'ro')
   %plot([Mu(t1) Mu(e1)],[I(t1) I(e1)],'g--')
   title([' ' num2str(10*t(tmin_co2(k))) ' to ' num2str(10*t(tmin_co2(k+1))) ' (ka) Cycle'])
   hold off;
end %for

%for k=1:25
%   %if k<26      
%   t1 = MinAt(k);
%   t2 = MinAt(k+1);
%   e1 = MaxAt(k);
%   subplot(5,5,k)
%   hold on;
%   plot(Mu(t1:t2),I(t1:t2),'k-')
%   plot(Mu(t1),I(t1),'ro')
%   plot(Mu(e1),I(e1),'bo')
%   plot(Mu(t2),I(t2),'ro')
%   %plot([Mu(t1) Mu(e1)],[I(t1) I(e1)],'g--')
%   title([' ' num2str(t(t1)) ' to ' num2str(t(t2)) ' (ka) Cycle'])
%   hold off;
%end %for
%fig2 = figure;
%stp = min(50,length(MaxAt));
%for k=26:stp     
%   t1 = MinAt(k);
%   t2 = MinAt(k+1);
%   e1 = MaxAt(k);
%   subplot(5,5,k-25)
%   hold on;
%   plot(Mu(t1:t2),I(t1:t2),'k-')
%   plot(Mu(t1),I(t1),'ro')
%   plot(Mu(e1),I(e1),'bo')
%   plot(Mu(t2),I(t2),'ro')
%   %plot([Mu(t1) Mu(e1)],[I(t1) I(e1)],'g--')
%   title([' ' num2str(t(t1)) ' to ' num2str(t(t2)) ' (ka) Cycle'])
%   hold off;
%end %for

%% Plotting cycles for I vs Mu
%if IvMuflag
%   figure;
%   if partflag
%      for k=1:size(tspan,2)-1
%         if (tspan(k)>=parStart & tspan(k+1)<=parEnd)
%            tstart = tspan(k);
%            tend = tspan(k+1);
%            mint = MinAt(k);
%            maxt = MaxAt(k);
%            subplot(5,5,k)
%            hold on;
%            plot(Mu(tstart:tend),I(tstart:tend),'-')
%            title(['Plot of Cycle ' num2str(k) ' '])
%            xlabel('CO2 concentration')
%            ylabel('global ice mass')
%            plot(Mu(mint),I(mint),'go')
%            plot(Mu(maxt),I(maxt),'ro')
%            hold off;
%         end %if
%      end %for
%   else
%      for k=1:size(tspan,2)-1
%         tstart = tspan(k);
%         tend = tspan(k+1);
%         mint = MinAt(k);
%         maxt = MaxAt(k);
%         subplot(6,5,k)
%         hold on;
%         plot(Mu(tstart:tend),I(tstart:tend),'-')
%         title(['Plot of Cycle ' num2str(k) ' '])
%         xlabel('CO2 concentration')
%         ylabel('global ice mass')
%         plot(Mu(mint),I(mint),'go')
%         plot(Mu(maxt),I(maxt),'ro')
%         hold off;
%      end %for
%   end %if

%   % Saving figure of the cycle for plot of I vs Mu
%   %print(gcf,'-djpeg','sm90_IvMucycles_integInsol');
%   savefig('sm90_IvMucycles_integInsol.fig')
%end %if

%% Plotting cycles for ice mass v ocean temp
%if IvThetaflag
%   figure();
%   if partflag
%      for k=1:size(tspan,2)-1
%         if (tspan(k)>=parStart & tspan(k+1)<=parEnd)
%            tstart = tspan(k);
%            tend = tspan(k+1);
%            mint = MinAt2(k);
%            maxt = MaxAt2(k);
%            subplot(6,5,k)
%            hold on;
%            plot(Theta(tstart:tend),I(tstart:tend),'-')
%            title(['Plot of Cycle ' num2str(k) ' '])
%            xlabel('global mean ocean temp')
%            ylabel('global ice mass')
%            plot(Theta(mint),I(mint),'go')
%            plot(Theta(maxt),I(maxt),'ro')
%            hold off;
%         end %if
%      end %for
%   else
%      for k=1:size(tspan,2)-1
%         tstart = tspan(k);
%         tend = tspan(k+1);
%         mint = MinAt2(k);
%         maxt = MaxAt2(k);
%         subplot(6,5,k)
%         hold on;
%         plot(Theta(tstart:tend),I(tstart:tend),'-')
%         title(['Plot of Cycle ' num2str(k) ' '])
%         xlabel('global mean ocean temp')
%         ylabel('global ice mass')
%         plot(Theta(mint),I(mint),'go')
%         plot(Theta(maxt),I(maxt),'ro')
%         hold off;
%      end %for
%   end %if

%   % Saving figure of the cycle for plot of I vs Theta
%   %print(gcf,'-dpdf','sm90_IvThetacycles_forced');
%   savefig('sm90_IvThetacycles_forced.fig')
%end %if

%% Look at plot of Mu(CO2 concentration) vs Theta(ocean temperature)
%if MuvThetaflag
%   figure();
%   if partflag
%      for k=1:size(tspan,2)-1
%         if (tspan(k)>=parStart & tspan(k+1)<=parEnd)
%            tstart = tspan(k);
%            tend = tspan(k+1);
%            mint = MinAt(k);
%            maxt = MaxAt(k);
%            subplot(6,5,k)
%            hold on;
%            plot(Theta(tstart:tend),Mu(tstart:tend),'-')
%            title(['Plot of Cycle ' num2str(k) ' '])
%            ylabel('CO2 concentration')
%            xlabel('global mean ocean temp')
%            plot(Theta(mint),Mu(mint),'go')
%            plot(Theta(maxt),Mu(maxt),'ro')
%            hold off;
%         end %if
%      end %for
%   else
%      for k=1:size(tspan,2)-1
%         tstart = tspan(k);
%         tend = tspan(k+1);
%         mint = MinAt(k);
%         maxt = MaxAt(k);
%         subplot(6,5,k)
%         hold on;
%         plot(Theta(tstart:tend),Mu(tstart:tend),'-')
%         title(['Plot of Cycle ' num2str(k) ' '])
%         ylabel('CO2 concentration')
%         xlabel('global mean ocean temp')
%         plot(Theta(mint),Mu(mint),'go')
%         plot(Theta(maxt),Mu(maxt),'ro')
%         hold off;
%      end %for
%   end %if

%   % Saving figure of the cycle for plot of Mu vs Theta
%   %print(gcf,'-dpdf','sm90_MuvThetacycles_forced');
%   savefig('sm90_MuvThetacycles_forced.fig')
%end %if
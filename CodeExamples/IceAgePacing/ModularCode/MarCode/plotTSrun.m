    fignum = 0;
    
    % Plot each IC seperately
    mruns=min(4,nIC);
    
    if (plotpoinc==false)
        % plot ensemble
        fignum=fignum+1;
        figure(fignum);
        clf;
        title(sprintf('kt1=%.4f kt2=%.4f',p.kt1,p.kt2));
        
        for ip =1:p.N
            subplot(p.N,1,ip);
            for ii=1:mruns
                if (ii==1)
                    plot(tt(:),squeeze(yy(ip,:,ii)),'r');
                    hold on;
                elseif(ii==2)
                    plot(tt(:),squeeze(yy(ip,:,ii)),'b');
                elseif(ii==3)
                    plot(tt(:),squeeze(yy(ip,:,ii)),'g');
                elseif(ii>3)
                    plot(tt(:),squeeze(yy(ip,:,ii)),'k');
                end
            end
            ylabel(p.vname(ip));
            if ip==1
                title(sprintf('kt1=%.4f kt2=%.4f',p.kt1,p.kt2));
            end
            if ip==1
                ylim([p.vrange1(1) p.vrange1(2)]);
            elseif ip==2
                ylim([p.vrange2(1) p.vrange2(2)]);
            end
            hold off;
        end
        xlabel('t');
        
        if (savefigs)   % save figures to file
            savefigure(ffpath, basefilename, fignum);
        end %if
        
        
        
        for irun = 1:mruns
            %
            fignum=fignum+1;
            figure(fignum);
            clf;
            subplot(3,1,1);
            
            plot(tt(:),yy(1,:,irun),'r');
            ylabel(p.vname(1));
            title(sprintf('kt1=%.4f kt2=%.4f run %d',p.kt1,p.kt2,irun));
            %
            %lyap convergent
            subplot(3,1,2);
            tskip = 20;
            plot(tt(tskip:end),yy(end,tskip:end,irun)'./(tt(tskip:end)+1-tstart),'r');
            ylabel('L(t)/t');
            xlabel('t');
            
            %forcing
            subplot(3,1,3);
            tskip = 20;
            plot(tt,arrayfun(@(t) forcingF(t,p),tt),'r');
            ylabel('\Lambda(t)');
            xlabel('t');
            %
            if (savefigs)   % save figures to file
                savefigure(ffpath, basefilename, fignum);
            end %if
        end %for
    else
        % plot P-section at obliquity freq traj 1 only
        fignum=fignum+1;
        figure(fignum);
        clf;
        tskip = 41;
        
        plot(yy(1,1:tskip:end,1),yy(2,1:tskip:end,1),'r.');
        hold on;
        xlabel(p.vname(1));
        ylabel(p.vname(2));
        %xlim([p.vrange1(1) p.vrange1(2)]);
        %ylim([p.vrange1(2) p.vrange1(2)]);
        hold off;
        
        if (savefigs)   % save figures to file
            savefigure(ffpath, basefilename, fignum);
        end %if
    end
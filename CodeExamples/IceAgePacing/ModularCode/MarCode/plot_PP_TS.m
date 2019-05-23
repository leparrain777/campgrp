    fignum = 0;
    %
    IceVol = squeeze(yy(1,:,:));
    AntIce = squeeze(yy(2,:,:));
    AtmCO2 = squeeze(yy(3,:,:));
    LyaExp = squeeze(yy(end,:,:));
    %
    switch nIC
        case 1
            % Plot (only) integration
            %
            fignum=fignum+1;
            figure(fignum);
            clf;
            subplot(4,1,1);
            % plot model state variables
            plot(tt(:),IceVol(:),'r',tt,AntIce(:),'b',tt(:),AtmCO2(:),'k');
            ylabel('y');
            title(sprintf('kt1=%.4f kt2=%.4f',p.kt1,p.kt2));
            %
            %lyap convergent
            subplot(4,1,2);
            plot(tt(:),LyaExp(:));
            ylabel('ll');
    
            %lyap convergent
            subplot(4,1,3);
            tskip = 20;
            plot(tt(tskip:end),LyaExp(tskip:end)'./(tt(tskip:end)+1));
            ylabel('ftle');
            xlabel('t');
    
            %forcing
            subplot(4,1,4);
            tskip = 20;
            plot(tt,arrayfun(@(t) forcingF(t,p),tt));
            ylabel('F(t)');
            xlabel('t');
            %
            if (savefigs)   % save figures to file
                savefigure(ffpath, basefilename, fignum);
            end %if
            %
            % Phase plane 
            fignum = fignum+1;
            figure(fignum);
            clf;
            %
            mColor = 4;
            ColorOrder = lines(mColor);
            ColorIndex = 1;
            %
            H=plot3(IceVol,AntIce,AtmCO2,...
                'Color', ColorOrder(ColorIndex, :));
            ColorIndex = ColorIndex+1;
            if (ColorIndex > mColor)
                ColorIndex = 1;
            end %if
            xlabel('V');
            ylabel('A');
            zlabel('C');
            %
            set(gca,'box','on');
            if (savefigs)   % save figures to file
                savefigure(ffpath, basefilename, fignum);
            end %if
        otherwise
            % Plot first 2 IC integrations seperately
            mruns = 3
            for irun = 1:mruns
                %
                fignum=fignum+1;
                figure(fignum);
                clf;
                subplot(4,1,1);
                % plot model state variables
                plot(tt(:),IceVol(:,irun),'r',tt(:),AntIce(:,irun),'b',tt(:),AtmCO2(:,irun),'k');
                ylabel('y');
                title(sprintf('kt1=%.4f kt2=%.4f',p.kt1,p.kt2));
                %
                %lyap 
                subplot(4,1,2);
                plot(tt(:),LyaExp(:,irun));
                ylabel('ll');
    
                %lyap convergent
                subplot(4,1,3);
                tskip = 20;
                plot(tt(tskip:end),LyaExp(tskip:end,irun)./(tt(tskip:end)+1));
                ylabel('ftle');
                xlabel('t');
    
                %forcing
                subplot(4,1,4);
                tskip = 20;
                plot(tt,arrayfun(@(t) forcingF(t,p),tt));
                ylabel('F(t)');
                xlabel('t');
                %
                if (savefigs)   % save figures to file
                    savefigure(ffpath, basefilename, fignum);
                end %if
            end %for
            %
            %  Plot ICs together
            fignum = fignum+1;
            figure(fignum);
            clf;
            %        %
            subplot(3,1,1)
            plot(tt,IceVol);
            xlabel('t');
            ylabel('V');
            %
            subplot(3,1,2)
            plot(tt,AntIce);
            xlabel('t');
            ylabel('A');
            %
            subplot(3,1,3)
            plot(tt,AtmCO2);
            xlabel('t');
            ylabel('C');
            %
            if (savefigs)   % save figures to file
                savefigure(ffpath, basefilename, fignum);
            end %if
            %
            % Plot V vs A vs t
            fignum=fignum+1;
            figure(fignum);
            clf;
            %
            H=plot3(repmat(tt,[1 nIC]),IceVol,AntIce);
            xlabel('t');
            ylabel('V');
            zlabel('A');
            xlim([tt(1) tt(end)])
            %set(gca,'CameraPosition',[3.6651e+03 -3.0812 1.8803]);
            %set(gca,'CameraTarget',[1250 0.5500 0.5500]);
            %set(gca,'CameraViewAngle', 9.7002);
            %set(gca,'DataAspectRatio', [5.0000e+03*1.2 4 2]);
            %set(gca,'PlotBoxAspectRatio', [1 0.5 0.5]);
            set(gca,'box','on');
            %
            if (savefigs)   % save figures to file
                savefigure(ffpath, basefilename, fignum);
            end %if
            %
            % Phase plane - first 2 integrations
            fignum = fignum+1;
            figure(fignum);
            clf;
            %
            mColor = 4;
            ColorOrder = lines(mColor);
            ColorIndex = 1;
            hold on;
            mrun = 2
            for j=1:2
                H=plot3(IceVol(:,j),AntIce(:,j),AtmCO2(:,j),...
                    'Color', ColorOrder(ColorIndex, :));
                ColorIndex = ColorIndex+1;
                if (ColorIndex > mColor)
                    ColorIndex = 1;
                end %if
                xlabel('V');
                ylabel('A');
                zlabel('C');
            end % for
            hold off;
            set(gca,'box','on');
            if (savefigs)   % save figures to file
                savefigure(ffpath, basefilename, fignum);
            end %if
    end % case


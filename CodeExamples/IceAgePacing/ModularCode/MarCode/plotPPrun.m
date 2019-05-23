    fignum = 0;
    
    % Plot each IC seperately
    mruns = min(4,nIC)
    
    % plot ensemble
    fignum=fignum+1;
    figure(fignum);
    clf;   
    % phase portrait
    %title(sprintf('kt1=%.4f kt2=%.4f',p.kt1,p.kt2));
    hold on;
    for i=1:nIC
        plot(squeeze(yy(1,:,i)),squeeze(yy(2,:,i)),'b');
        xlim([p.vrange1(1) p.vrange1(2)]);
        ylim([p.vrange2(1) p.vrange2(2)]); 
    end
    %% draw arrow at start
    dv=squeeze(yy(:,2,:)-yy(:,1,:));
    yyy=squeeze(yy(:,1,:));
    quiver(yyy(1,:),yyy(2,:),dv(1,:),dv(2,:),1);
        
    %% draw arrow at end
    %quiver(yy(1,end,:),yy(2,end,:),yy(1,end,:)-yy(1,end-1,:),yy(2,end,:)-yy(2,end-1,:),2);
    ylabel(p.vname(2));
    xlabel(p.vname(1));
    % now draw nullclines?
    if p.model==3 || p.model==4 || p.model==7
        % x and y-nullcline approx
        nNC=31;
        yy1=p.vrange1(1):(p.vrange1(2)-p.vrange1(1))/nNC:p.vrange1(2);
        yy2=p.vrange2(1):(p.vrange2(2)-p.vrange2(1))/nNC:p.vrange2(2);
        [xq,yq] = meshgrid(yy1,yy2);
        vq=zeros(size(xq));
        for ii=1:nNC+1
            for jj=1:nNC+1
            yyy=[xq(ii,jj),yq(ii,jj),0,1.0,0];
            fn = fn_lyaps(0,yyy,p);
            vq1(ii,jj)=fn(1);
            vq2(ii,jj)=fn(2);
            end
        end
        %quiver(yy1,yy2,vq1,vq2,0.2);
        contour(yy1,yy2,vq1,[0 0],'g-.','LineWidth',2);
        contour(yy1,yy2,vq2,[0 0],'r-','LineWidth',2);
    end
        
    hold off;
    
    if (savefigs)   % save figures to file
         savefigure(ffpath, basefilename, fignum);
    end %if

%     
%     
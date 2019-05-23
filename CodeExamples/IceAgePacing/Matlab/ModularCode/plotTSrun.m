    figure(1);
    clf;
    subplot(4,1,1);
    
    %first compt
    if p.N==3
        plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b',tt(:),yy(3,:),'k');
    elseif p.N==2
        if p.model==7
            plot(tt(:),sin(yy(1,:)),'r',tt(:),yy(2,:),'b');    
        else
            plot(tt(:),yy(1,:),'r',tt(:),yy(2,:),'b');    
        end
    else 
        plot(tt(:),sin(yy(1,:)),'r');
    end
    ylabel('y');
    title(sprintf('kt1=%.4f kt2=%.4f',p.kt1,p.kt2));
    %
    %lyap convergent
    subplot(4,1,2);
    plot(tt(:),yy(end,:));
    ylabel('ll');
    
    %lyap convergent
    subplot(4,1,3);
    tskip = 20;
    plot(tt(tskip:end),yy(end,tskip:end)./(tt(tskip:end)+1));
    ylabel('ftle');
    xlabel('t');
    
    %forcing
    subplot(4,1,4);
    tskip = 20;
    plot(tt,arrayfun(@(t) forcingF(t,p),tt));
    ylabel('F(t)');
    xlabel('t');

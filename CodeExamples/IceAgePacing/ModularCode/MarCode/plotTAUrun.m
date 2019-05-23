    fignum = 0;
    %
    fignum=fignum+1;
    figure(fignum);
    clf;
    %
    imagesc(arrTau,arrAmp,lyap,[-0.015,0.015]);
    colorbar;
    axis xy;
    xlabel('\tau');
    ylabel('k');
    %
    if (savefigs)   % save figures to file
        %ffname = sprintf('%s%s_Fig%i', ffpath, basefilename, fignum);
        savefigure(ffpath,basefilename,fignum);
        %print(sprintf('%s.pdf',ffname),'-dpdf');
        %system(sprintf('pdfcrop %s.pdf',ffname))
        %print(sprintf('%s.eps',ffname),'-depsc2');
    end %if
    
        % now plot mean period
    fignum=fignum+1;
    figure(fignum);
    clf;
    %
    %H=imagesc(k1,k2,(2*pi)./wind,[0,200]);
    H=imagesc(arrTau,arrAmp,(2*pi)./wind,[20,150]);
    colorbar;
    colormap colorcube;
    axis xy;
    xlabel('\tau');
    ylabel('\kappa');
    %
    if (savefigs)   % save figures to file
        savefigure(ffpath,basefilename,fignum);
%         ffname = sprintf('%s%s_Fig%i', ffpath, basefilename, fignum);
%         savefig(ffname);
%         print(sprintf('%s.pdf',ffname),'-dpdf');
%         % crop and remove original version
%         system(sprintf('pdfcrop %s.pdf',ffname));
%         system(sprintf('del %s.pdf',ffname));
%         print(sprintf('%s.eps',ffname),'-depsc2');
    end %if


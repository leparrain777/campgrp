    fignum = 0;
    % first plot lyas
    fignum=fignum+1;
    figure(fignum);
    clf;
    %
    imagesc(k1,k2,lyap,[-0.015,0.015]);
    %imagesc(k1,k2,lyap,[-0.05,0.05]);
    colorbar;
    axis xy;
    xlabel('K_1');
    ylabel('K_2');
    %
    if (savefigs)   % save figures to file
        ffname = sprintf('%s_Fig%i', basefilename, fignum);
        savefigure(ffpath,ffname,fignum);
%         print(sprintf('%s.pdf',ffname),'-dpdf');
%         % crop and remove original version
%         system(sprintf('pdfcrop %s.pdf',ffname));
%         system(sprintf('del %s.pdf',ffname));
%         print(sprintf('%s.eps',ffname),'-depsc2');
    end %if
    
    % now plot mean period
    fignum=fignum+1;
    figure(fignum);
    clf;
    %
    %H=imagesc(k1,k2,(2*pi)./wind,[0,200]);
    H=imagesc(k1,k2,(2*pi)./wind,[20,150]);
    colorbar;
    colormap colorcube;
    axis xy;
    xlabel('K_1');
    ylabel('K_2');
    %
    if (savefigs)   % save figures to file
        ffname = sprintf('%s_Fig%i', basefilename, fignum);
        savefigure(ffpath,ffname,fignum);
%         
%         ffname = sprintf('%s%s_Fig%i', ffpath, basefilename, fignum);
%         savefig(ffname);
%         print(sprintf('%s.pdf',ffname),'-dpdf');
%         % crop and remove original version
%         system(sprintf('pdfcrop %s.pdf',ffname));
%         system(sprintf('del %s.pdf',ffname));
%         print(sprintf('%s.eps',ffname),'-depsc2');
    end %if


printflg = 1;
%
plot(t,y,'+-');
xlabel('t');
ylabel('y');
title(sprintf('Run #%i', runnum));
%
if (printflg)
 fname0 = sprintf('Fig1.r%i', runnum);
 print('-dpdf', [fname0,'.pdf']);
 print('-deps', [fname0,'.eps']);
end  % if

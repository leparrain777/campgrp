function [FO]=forcingF(t,p)
% astro forcing same for all models
switch p.forcing
    case 1
        % periodic ( sum of 2 sinusoids)
        FO=p.kt1*sin(t*p.omega1)+p.kt2*sin(t*p.omega2);
    case 2
        % integrated summer insolation
        FO=p.kt1*ppval(p.insolcf, t);
    case 3
        % de Saedeleer, Crucifix, Wieczorek forcing
        F1=(p.dcwcoeffs(1:15,2).*sin(p.dcwcoeffs(1:15,1)*t)+p.dcwcoeffs(1:15,3).*cos(p.dcwcoeffs(1:15,1)*t));
        F2=(p.dcwcoeffs(16:35,2).*sin(p.dcwcoeffs(16:35,1)*t)+p.dcwcoeffs(16:35,3).*cos(p.dcwcoeffs(16:35,1)*t));
        % normalization and sum
        FO=(p.kt1*sum(F1)/p.f1norm + p.kt2*sum(F2)/p.f2norm);
    otherwise
        keyboard;
end % switch p.forcing

end



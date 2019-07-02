% This script ...

% Creates an array of the following variables (in that order):
% tstart, Istart, Mustart, Thetastart := values at start of cycle
% tswitch, Iswitch, Muswitch, Thetaswitch := values at switch of phase of cycle
% tend, Iend, Muend, Thetaend := values at end of cycle
% tmax, Imax, Mumax, Thetamax := values at maximum ice mass
% tmin, Imin, Mumin, Thetamin := values at minimum ice mass
% deltat1 := (tswitch-tstart) 
% delta2 := (tend - tswitch)
% delta3 := Imax - Imin
% delta4 := (Imax-Imin)/Imax
%Data = [24,Inf];
%for j=1:size(MinAt)-1
%   Data(1,j) = t(MinAt(j));
%   Data(2,j) = t(MaxAt(j));
%   Data(3,j) = t(MinAt(j+1));
%   Data(4,j) = t(MaxAt(j)) - t(MinAt(j));
%   Data(5,j) = t(MinAt(j+1)) - t(MaxAt(j));
%   Data(6,j) = t(maxIat(j));
%   Data(7,j) = t(minIat(j));

%   Data(8,j) = I(MinAt(j));
%   Data(9,j) = I(MaxAt(j));
%   Data(10,j) = I(MinAt(j+1));
%   Data(11,j) = I(maxIat(j));
%   Data(12,j) = I(minIat(j));
%   Data(13,j) = I(maxIat) - I(minIat);
%   Data(14,j) = (I(maxIat) - I(minIat))/I(maxIat);

%   Data(15,j) = Mu(MinAt(j));
%   Data(16,j) = Mu(MaxAt(j));
%   Data(17,j) = Mu(MinAt(j+1));
%   Data(18,j) = Mu(maxIat(j));
%   Data(19,j) = Mu(minIat(j));

%   Data(20,j) = Theta(MinAt(j));
%   Data(21,j) = Theta(MaxAt(j));
%   Data(22,j) = Theta(MinAt(j+1));
%   Data(23,j) = Theta(maxIat(j));
%   Data(24,j) = Theta(minIat(j));

%end %for
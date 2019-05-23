function[CatMPDSI] = Catenate(MPDSI,refnum_start,refnum_end)

start = find(MPDSI == refnum_start);
finish = find(MPDSI == refnum_end);

stateMPDSI = MPDSI(start:finish,2:13);

Dim = length(stateMPDSI);

for n = 1:Dim
    for m = 1:12
        if stateMPDSI(n,m) == -99.99
           stateMPDSI(n,m) = NaN;
        end
    end
end

CatMPDSI = stateMPDSI(1,1:12);

for n = 1:Dim-1
    CatMPDSI = cat(2,CatMPDSI,stateMPDSI(1+n,1:12));
end

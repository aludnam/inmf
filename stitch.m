function resIm=stitch(rf,pow)
%pow=20;
%rf=4; % should be power of 2

d=dir('P*');
[NW,SE]=resSize(d);
sizeRes=rf*(SE-NW+1); % Size of the result.
resIm=zeros(sizeRes);

for ii=1:length(d)
    fprintf('Processing patch %s\n', d(ii).name)
    sd = dir([d(ii).name '/results_run*']);
    n=0;
    for jj=1:length(sd)                
        try
            load ([d(ii).name '/' sd(jj).name '/w'])
            load ([d(ii).name '/' sd(jj).name '/h'])
            load ([d(ii).name '/' sd(jj).name '/peval'])
            [outtmp,nxi,nyi]=makeHiRes(w,h,peval.nx,peval.ny,rf,pow);
            if n==0
                out=zeros(nxi,nyi);
            end            
            out = out+outtmp;
            n=n+1;        
        end        
    end
    out=out/max(n,1); % to get mean value of the evaluations
    
    cTL=rf*(peval.cornerNW-1)+1;        % counts stats from 1
    
    cTLloc=[1,1]*rf*peval.patchOverlap/2+1;   % coordinates in the patch
    cBRloc=size(out)-rf*peval.patchOverlap/2;     % coordinates in the patch
    sloc=cBRloc-cTLloc;                         % size of the patch with removed half of the overlap on each side    
    resIm(cTL(1):cTL(1)+sloc(1),cTL(2):cTL(2)+sloc(2))=out(cTLloc(1):cBRloc(1),cTLloc(2):cBRloc(2));
end
end

function [cNW,cSE]=resSize(d)
% Determine the corners of the result.
cNW=[inf,inf];
cSE=[1,1];
for ii=1:length(d)
    load ([d(ii).name '/results_run1/peval'])
    cNW=min(cNW,peval.cornerNW);
    cSE=max(cSE,peval.cornerSE);
end
cNW=cNW-peval.patchOverlap/2;
cSE=cSE-peval.patchOverlap/2;
end
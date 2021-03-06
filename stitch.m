function resIm=stitch(resDir,rf,pow)
% Makes high-resolution image from iNMF estimated sources. Stitches results from different patches. 
%
% resIm=stitch(resDir,rf,pow)
%
% resIm - Visualisation of the iNMF results.
% resDir - Directory with stored results (default resDir='./').
% rf - Resample factor (default rf=4).
% pow - Power to which the resampled individual soureces should be rased (default pow=10).

if ~exist('resDir','var'); resDir='./'; end
if ~exist('rf','var'); rf=4; end
if ~exist('pow','var'); pow=10; end

fprintf('Resampling the results %g times.\n',rf)
fprintf('Taking the estimated sources to the power of %g.\n',pow)

d=dir([resDir '/P*']);
[NW,SE]=resSize(resDir,d);
sizeRes=rf*(SE-NW+1); % Size of the result.
resIm=zeros(sizeRes);

for ii=1:length(d)
    fprintf('Processing patch %s', [resDir '/' d(ii).name])
    sd = dir([resDir '/' d(ii).name '/results_run*']);
    n=0;
    out=[];
    for jj=1:length(sd)
        %try
            load ([resDir '/' d(ii).name '/' sd(jj).name '/w'])
            load ([resDir '/' d(ii).name '/' sd(jj).name '/h'])
            load ([resDir '/' d(ii).name '/' sd(jj).name '/peval'])
            [outtmp,nxi,nyi] = makeHiRes(w,h,peval.nx,peval.ny,rf,pow);
            fprintf '.'
            wxy = makeWindow(size(outtmp),rf*peval.patchOverlap);
            if n==0
                out=zeros(nxi,nyi);
            end
            out = out + wxy.*outtmp;
            %out = max(out,wxy.*outtmp);
            n=n+1;
        %end
    end
    out=out/max(n,1);                   % get the mean value of the evaluations
    
    cTL=rf*(peval.cornerNW-1)+1;        % counts starts from 1
            
    c1=cTL(1):cTL(1)+size(out,1)-1;
    c2=cTL(2):cTL(2)+size(out,2)-1;
    resIm(c1,c2)=resIm(c1,c2)+out;    
    fprintf('\n')
end
end

function [cNW,cSE]=resSize(resDir, d)
% Determine the corners of the result.
cNW=[inf,inf];
cSE=[1,1];
for ii=1:length(d)
    resDirs=dir([resDir '/' d(ii).name]);
    resDirLast=resDirs(end).name;
    load ([resDir '/' d(ii).name '/' resDirLast '/peval'])
    cNW=min(cNW,peval.cornerNW);
    cSE=max(cSE,peval.cornerSE);
end
end

function wxy=makeWindow(s,overlapIm)
ov=overlapIm-1; % overlap starts from zero (removing the border pixels due to possible artefacts)

[x,y]=meshgrid(1:s(2),1:s(1));

mx1=x<=ov;
mx2=(s(2)-x)<ov;
wx1=1/ov*(x-1).*mx1+~mx1;
wx2=1/ov*(s(2)-x).*mx2+~mx2;
wx=min(wx1,wx2);

my1=y<=ov;
my2=(s(1)-y)<ov;
wy1=1/ov*(y-1).*my1+~my1;
wy2=1/ov*(s(1)-y).*my2+~my2;
wy=min(wy1,wy2);

wxy=wx.*wy;
end
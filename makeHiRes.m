function [out,nxi,nyi]=makeHiRes(w,h,nx,ny,rf,pow)
% [out,nxi,nyi]=makeHiRes(w,h,nx,ny,rf,pow)
% Makes high resolution image from the results of iNMF algorithm. 
% 
% out:  result 
% nxi:  x-dimension of the result
% nyi:  y-dimension of the result
%
% w:    spatial components - each column represents one source
% h:    temporal components - each row represents intensity profile
% nx:   number of pixels along x direction (strored in peval.nx)
% ny:   number of pixels along y direction (strored in peval.ny)
% rf:   resample factor (rf = 4 is usually sufficient
% pow:  power factor (used as w.^pow)

[wi,nxi,nyi]=interpW(w,nx,ny,rf);
out=reshape(normL(wi.^pow)*mean(h,2),nxi,nyi);
end

function [wi,nxi,nyi]=interpW(w,nx,ny,intFac)
%[wi,nxi,nyi]=interpW(w,nx,ny,intFac)

K=size(w,2); 
wr=reshape(w,nx,ny,K); 

[xCoarse, yCoarse] = meshgrid(0:ny-1,0:nx-1);
nxi=intFac*nx; 
nyi=intFac*ny; 
%[xFine, yFine] = meshgrid(linspace(0,nx-1,nxi),linspace(0,ny-1,nyi));
[xFine, yFine] = meshgrid(linspace(0,ny-1,nyi),linspace(0,nx-1,nxi));
wri=zeros(nxi,nyi,K); 
for k=1:K
    wri(:,:,k) = interp2(xCoarse,yCoarse,wr(:,:,k),xFine,yFine,'bicubic');
end
wi_tmp=reshape(wri,nxi*nyi,K);
wi=normL(wi_tmp,1,1);
end
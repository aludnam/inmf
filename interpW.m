function [wi,nxi,nyi]=interpW(w,nx,ny,intFac)

K=size(w,2); 
wr=reshape(w,nx,ny,K); 

[xCoarse, yCoarse] = meshgrid(0:ny-1,0:nx-1);
step=1/intFac;
[xFine, yFine] = meshgrid(0:step:(ny-1),0:step:(nx-1));
nxi=intFac*(nx-1)+1; 
nyi=intFac*(ny-1)+1; 
wri=zeros(nxi,nyi,K); 
for k=1:K
    wri(:,:,k) = interp2(xCoarse,yCoarse,wr(:,:,k),xFine,yFine,'bicubic');
end

wi_tmp=reshape(wri,nxi*nyi,K);
wi=normL(wi_tmp,1,1);
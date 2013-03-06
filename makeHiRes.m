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
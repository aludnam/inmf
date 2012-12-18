function [nPatchX,nPatchY]=npatch(sx,sy,patchSizeX,patchSizeY,patchOverlap)
% [nPatchX,nPatchY]=npatch(sx,sy,patxhSizeX,patchSizeY,patchOverlap)
% Determines the number of patches in the image. 

nPatchX = ceil((sx-patchSizeX)/(patchSizeX-patchOverlap))+1;
nPatchY = ceil((sy-patchSizeY)/(patchSizeY-patchOverlap))+1;

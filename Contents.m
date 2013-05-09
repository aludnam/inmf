% INMF
%
% Files
%   addColorBox           - Adds color box to an image. 
%   ddivergence           - Computes generalised Kullback-Leibler divergence KL(A|B) between matrices A and B.
%   estimateK             - Estimates number of compontents from the magnitude of the principal components. 
%   imageTiles            - Tiles the frames of the 3D image.
%   inmf                  - Non-negative matrix factorisation with iterative restarts. This function is called by inmf_main.m.
%   inmf_main             - NMF evaluation with iterative restarts.
%   makeHiRes             - Makes high resolution image from the results of iNMF algorithm. 
%   nmf                   - Non-negative matrix factorisation updates minimising KL divergence KL(V|WH).
%   normL                 - Normalizes marix M along dimension dim according to the L-norm norm such that sum(M.^Lnorm,dim)=1. 
%   npatch                - Determines the number of patches in the image. 
%   patchCorner           - Computes top-left (TL) and bottom-right (BR) coordinates of the patch. 
%   setDefaultValuesPeval - Sets default values of the parameters for inmf evaluation.
%   showPatches           - Shows division of the data into smaller patches. 
%   stitch                - Makes high-resolution image from iNMF estimated sources. Stitches results from different patches. 

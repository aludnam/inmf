function inmf_main(dataIn,peval,savethis,verbose)
% inmf_main(dataIn,peval,savethis,verbose)
% NMF evaluation with iterative restarts. 
%
% dataIn:   Time series of two-diemnsional images (as a MATLAB variable). 
%
% peval:    (optional) Parameters of the evaluation. Set peval.Kinput to
%           specifiy the number of sources). Type "help nmf" for more
%           details on peval. 
%
% savethis: (optional) Set to 1 to save the results. 
%
% verbose:  (optional) Set to 1 to print information during evaluation. Set
%           to 2 to show results during evaluation.            


if ~exist('peval','var'); peval=[]; end
if ~exist('savethis','var'); savethis=0; end
if ~exist('verbose','var'); verbose=1; end

[sx,sy,st]=size(dataIn);
peval=setDefaultValuesPeval(peval);

% compute number of patches:
[nPatchX,nPatchY]=npatch(sx,sy,peval.patchSizeX,peval.patchSizeY,peval.patchOverlap);

for patchX = 1:nPatchX
    for patchY = 1:nPatchY                
                        
        % Compute top-left (TL) and bottom-right (BR) corner:                
        [peval.cornerTL, peval.cornerBR]=patchCorner(patchX,patchY,peval.patchSizeX,peval.patchSizeY,peval.patchOverlap,sx,sy);                
                
        % Extract patch from the data:
        dpix = dataIn(peval.cornerTL(1):peval.cornerBR(1), peval.cornerTL(2):peval.cornerBR(2),:);
        
        [peval.nx, peval.ny, peval.nt]=size(dpix);                
        
        % Reshape data into 2D data matrix by concatenating rows of pixels in each frame:
        d=reshape(dpix,peval.nx*peval.ny,peval.nt);
        
        % Number of sources:  
        if isfield(peval, 'Kinput') 
            peval.K=peval.Kinput; % Number of sources is given by user.  
        else 
            peval.K = estimateK(d,peval.threhold_pca,verbose); % Estimation of the number of sources.
        end
        
        % Initialising log-file:
        if savethis                        
            peval.path_results = [cd '/P' num2str(patxhX) num2str(patxhX) '/results_K' num2str(peval.K)];
            peval.fid=initlog(peval.path_results);
        else
            peval.fid = 1; %Messages only on the screen. 
        end
        
        if verbose 
            printmsg(nPatchX,nPatchY,peval);
        end
        
        % iNMF algorithm:
        [w,h,peval]=inmf(d,peval.K,peval,verbose);
        
        % Saving data:
        if savethis
            savedata(peval.path_results,w,h,peval)
        end
    end
end
end

function peval=setDefaultValuesPeval(peval)

if ~isfield(peval, 'threhold_pca'); peval.threhold_pca=3e-3; end % Threshold on the determinatino of components.
if ~isfield(peval, 'patchSizeX'); peval.patchSizeX = 25; end
if ~isfield(peval, 'patchSizeY'); peval.patchSizeY = 25; end
if ~isfield(peval, 'patchOverlap'); peval.patchOverlap=5; end

end

function printmsg(nPatchX,nPatchY,peval)

mfprintf(peval.fid,'Patch [%g %g]:\n',nPatchX, nPatchY);
mfprintf(peval.fid,'Top-left cornere of the patch [%g %g]\n',peval.cornerTL); 
mfprintf(peval.fid,'Bottom-right cornere of the patch [%g %g]\n',peval.cornerBR); 
mfprintf(peval.fid,'Patch size is [%g %g] pixels.\n',peval.nx, peval.ny); 
mfprintf(peval.fid,'Number of sources: %g\n',peval.K); 
if isfield(peval,'path_results')
    mfprintf(peval.fid,'Results saved in : %s\n',peval.path_results); 
end
end
        
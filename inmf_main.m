function inmf_main(dataIn,peval,savethis,verbose)
% inmf_main(dataIn,peval,savethis,verbose)
% NMF evaluation with iterative restarts.
%
% dataIn:   Time series of two-diemnsional images (as a MATLAB variable).
%
% peval:    (optional) Parameters of the evaluation:
%           peval.nRuns - specifiy the number of runs of inmf
%           peval.bg - specify the background
%           peval.patchSizeX - specify the size of the patch
%           peval.patchSizeY - specify the size of the patch
%           peval.patchOverlap - specify the overlap of the patches
%           peval.Kinput - specify number of sources. if specified this way it will be the same for all patches! 
%           ....
%           See "setDefaultValuesPeval.m" for default values.
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

maxMeanDataIn=max(max(mean(dataIn,3)));

for indexRun=1:peval.nRuns
    for patchX=1:nPatchX
        for patchY=1:nPatchY
            close all % closes open figures
            % Compute top-left (NW) and bottom-right (SE) corner:
            [peval.cornerNW, peval.cornerSE]=patchCorner(patchX,patchY,peval.patchSizeX,peval.patchSizeY,peval.patchOverlap,sx,sy);
            
            % Extract patch from the data:
            dpix=dataIn(peval.cornerNW(1):peval.cornerSE(1), peval.cornerNW(2):peval.cornerSE(2),:);
            [peval.nx, peval.ny, peval.nt]=size(dpix);
            
            % Estimate bg: not working wery well better to supply some rough
            % estimate from mean(dataIn,3)
            
            % Ignore the patch if not bright enough:
            mmd=max(max(mean(dpix,3)));
            if mmd/maxMeanDataIn<peval.threshold_patchBrightness;
                continue
            end
            
            % Reshape data into 2D data matrix by concatenating rows of pixels in each frame:
            d=reshape(dpix,peval.nx*peval.ny,peval.nt);
            
            % Number of sources:
            if isfield(peval, 'Kinput')
                peval.K=peval.Kinput; % Number of sources is given by user.
            else
                peval.K=estimateK(d,peval.threshold_pca); % Estimation of the number of sources.
            end
            
            % Creates directory for saving the results. 
            if savethis
                peval.path_results = [cd '/P' num2str(patchX) num2str(patchY) '/results_run' num2str(indexRun)];
                mkdir(peval.path_results)                             
            end
            
            peval.computed=datestr(now);
            
            if verbose
                printmsg(patchX,patchY,peval);
            end
            
            tic
            % iNMF algorithm:
            [w,h,peval]=inmf(d,peval.K,peval,verbose);
            
            peval.elapsedTimeSec=toc;
            
            % Saving data:
            if savethis
                savedata(peval.path_results,w,h,peval)
            end
        end
    end
end
end

function printmsg(patchX,patchY,peval)

fprintf('Patch [%g %g]:\n',patchX, patchY);
fprintf('Top-left cornere of the patch [%g %g]\n',peval.cornerNW);
fprintf('Bottom-right cornere of the patch [%g %g]\n',peval.cornerSE);
fprintf('Patch size is [%g %g] pixels.\n',peval.nx, peval.ny);
fprintf('Number of sources: %g\n',peval.K);
if isfield(peval,'path_results')
    fprintf('Results saved in : %s\n',peval.path_results);
end
end

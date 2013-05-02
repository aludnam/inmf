function inmf_main(dataIn,outputDir,peval,verbose)
% NMF evaluation with iterative restarts.
%
% inmf_main(dataIn,outputDir,peval,verbose)
%
% dataIn:   Time series of two-dimensional images (as a MATLAB variable).
%
% outputDir: (optional) Directory to save the results (default "./").
%
% peval:    (optional) Parameters of the evaluation:
%           peval.runs - specifiy the number of runs of inmf
%           peval.bg - specify the background
%           peval.patchSizeX - specify the size of the patch
%           peval.patchSizeY - specify the size of the patch
%           peval.patchOverlap - specify the overlap of the patches
%           peval.threshold_pca - threshold for the estimation of number of components from PCA.
%           peval.Kinput - specify number of sources. If specified this way it will be the same for all patches!
%           ....
%           See "setDefaultValuesPeval.m" for default values.
%
% verbose:  (optional) Set to 1 to print information during evaluation. Set
%           to 2 to show the estimated w_k during evaluation (default verbose=1).
%
% Example:
% peval.bg = 100; % specify background estimate
% outputDir = 'results'
% inmf_main(dataIn,outputDir,peval) 
%
% Runs iNMF algorithm on dataIn (3D matrix - video of the data) with specified background 100 photons/frame/pixel. Results
% will be stored in directory outputDir

if ~exist('peval','var'); peval=[]; end
if ~exist('outputDir','var'); outputDir='./'; end
if ~exist('verbose','var'); verbose=1; end

[sx,sy,st]=size(dataIn);
peval=setDefaultValuesPeval(peval);

% compute number of patches:
[nPatchX,nPatchY]=npatch(sx,sy,peval.patchSizeX,peval.patchSizeY,peval.patchOverlap);

maxMeanDataIn=max(max(mean(dataIn,3)));

for indexRun=peval.runs
    for patchX=1:nPatchX
        for patchY=1:nPatchY            
            % Compute top-left (NW) and bottom-right (SE) corner:
            [peval.cornerNW, peval.cornerSE]=patchCorner(patchX,patchY,peval.patchSizeX,peval.patchSizeY,peval.patchOverlap,sx,sy);
            
            % Extract patch from the data:
            dpix=dataIn(peval.cornerNW(1):peval.cornerSE(1), peval.cornerNW(2):peval.cornerSE(2),:);
            [peval.nx, peval.ny, peval.nt]=size(dpix);
                                    
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
            
            peval.computed=datestr(now);
            
            if verbose
                printmsg(patchX,patchY,peval);
            end
            
            tic
            
            % iNMF algorithm:
            [w,h,peval]=inmf(d,peval.K,peval,verbose);
            
            peval.elapsedTimeSec=toc;
            
            % Saving data:
            peval.path_results = [outputDir '/P' num2str(patchX) num2str(patchY) '/results_run' num2str(indexRun)];            
            savedata(peval.path_results,w,h,peval)
        end
    end
end
end

function printmsg(patchX,patchY,peval)

fprintf('Patch [%g %g]:\n',patchX, patchY);
fprintf('Top-left corner of the patch [%g %g]\n',peval.cornerNW);
fprintf('Bottom-right corner of the patch [%g %g]\n',peval.cornerSE);
fprintf('Patch size is [%g %g] pixels.\n',peval.nx, peval.ny);
fprintf('Number of sources: %g\n',peval.K);
end

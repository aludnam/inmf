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
%           peval.Kinput - directly specify number of sources (ignoring peval.threshold_pca)           
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

if ~isfield(peval, 'patch_range')
    % compute number of patches:
    [nPatchX,nPatchY]=npatch(sx,sy,peval.patchSizeX,peval.patchSizeY,peval.patchOverlap);
    [X,Y] = meshgrid(1:nPatchX,1:nPatchY);    
    peval.patch_range = [X(:),Y(:)];
    peval.patch
end

maxMeanDataIn=max(max(mean(dataIn,3)));


for indexRun=peval.runs
    for n = 1:size(peval.patch_range,1)
        patchX = peval.patch_range(n,1);
        patchY = peval.patch_range(n,2);
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
            if isfield(peval, 'Kmax')
                peval.K=min(peval.K,peval.Kmax);
            end
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
end % of main function

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:

function printmsg(patchX,patchY,peval)
fprintf('%s\n',datestr(now));
fprintf('Patch [%g %g]:\n',patchX, patchY);
fprintf('Top-left corner of the patch [%g %g]\n',peval.cornerNW);
fprintf('Bottom-right corner of the patch [%g %g]\n',peval.cornerSE);
fprintf('Patch size is [%g %g] pixels.\n',peval.nx, peval.ny);
fprintf('Number of sources: %g\n',peval.K);
end

function savedata(pathRes,w,h,peval)
% Saves iNMF results into a direcotry defined by 'pathRes'.
%
% savedata(pathRes,w,h,peval)

if ~exist('pathRes','var')
    pathRes=cd; % Default direcotry.
    peval.path_results = pathRes;
end 

fprintf('Results saved in : %s\n',pathRes);
mkdir(peval.path_results)

save([peval.path_results '/w'],'w');
save([peval.path_results '/h'],'h');
save([peval.path_results '/peval'],'peval');

% Save peval as a peval.txt file. 
fid = fopen([peval.path_results '/peval.txt'],'wt');
fn =fieldnames(peval);
for ii = 1: length(fn)
    name = fn{ii};
    value = getfield(peval,fn{ii});
    if ischar (value)
        fprintf (fid, [name ' = ''' value '''\n']);
    else
        if length(value)==1
            fprintf (fid, [name ' = %g \n'], value);
        else
            fprintf (fid, [name ' = [']);
            fprintf (fid, '%g ', value);
            fprintf (fid, ']\n');            
        end
    end
end    
end
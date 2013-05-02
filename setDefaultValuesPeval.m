function peval=setDefaultValuesPeval(peval)
% peval=setDefaultValuesPeval(peval) 
%
% Sets default values of the parameters for inmf evaluation.

if ~isfield(peval, 'runs'); peval.runs=1; end % Index of a run of the whole inmf algorithm.
if ~isfield(peval, 'patchSizeX'); peval.patchSizeX = 25; end
if ~isfield(peval, 'patchSizeY'); peval.patchSizeY = 25; end
if ~isfield(peval, 'patchOverlap'); peval.patchOverlap=5; end
if ~isfield(peval, 'threshold_pca'); peval.threshold_pca=3e-3; end % Threshold for the estimation of number of components from PCA.
if ~isfield(peval, 'threshold_patchBrightness'); peval.threshold_patchBrightness=.25; end % Threshold to determine if there is any signal in the patch (the brightness of the patch compared to mean(dataIn(:))).
if ~isfield(peval, 'dterm'); peval.dterm = 1; end % Termination criterion.
if ~isfield(peval, 'maxiter'); peval.maxiter = 1000; end % Maximum number of iterations. 
if ~isfield(peval, 'fixBg_w'); peval.fixBg_w=1; end % Last (background) component w not updated.
if ~isfield(peval, 'fixBg_h'); peval.fixBg_h=0; end % Last (background) component h not updated.
if ~isfield(peval, 'checkTermCycle'); peval.checkTermCycle=100; end % How often to check the termination criterion and print the value of KL divergence (if verbose>0).

end

function [w,h]=nmf(v,winit,hinit,peval)
% Non-negative matrix factorisation updates minimising KL divergence KL(V|WH)
% References : D.D. Lee and H.S. Seung. Algorithms for non-negative matrix
% factorization. Advances in neural information processing systems, 13, 2001.
%
% v    : N x T data matrix (N-pixels, T-time frames)
% w    : N x K spatial factor (sources)
% h    : K x T time factor (intensities)
% K is the rank of factorisation (number of sources).
%
% fixvec - vector which component should be fixed: eg [2 3] will
% fix second and third component while varying the first...

checkv(v)
N=size(v,1); T=size(v,2); K=size(winit,2);
peval=setDefaultValuesPeval(peval);
[dovec_w, dovec_h]=setDoVec(K,peval.fix_bg_w,peval.fix_bg_h);


end

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:

function checkv(v)
% test for negative values in v
if min(v(:)) < 0
    error('Data entries can not be negative!');
end
end

function peval=setDefaultValuesPeval(peval)

if ~isfield(peval, 'dterm'); peval.dterm = 1; end %termination criterion
if ~isfield(peval, 'ddterm'); peval.ddterm = 1; end %termination criterion
if ~isfield(peval, 'maxiter'); peval.maxiter = 1000; end
if ~isfield(peval,'showimage'); peval.showimage =0; end %showing progres images
if peval.bgcomp
    if ~isfield(peval, 'fix_bg_w')
        peval.fix_bg_w=1; % last (background) component w is fixed and not updated
    end
    if ~isfield(peval, 'fix_bg_h')
        peval.fix_bg_h=1; % last (background) component h is fixed and not updated
    end
end
end

function [dovec_w, dovec_h]=setDoVec(K,fix_bg_w,fix_bg_h)
if fix_bg_w
    dovec_w=1:K-1;
else
    dovec_w=1:K;
end
if fix_bg_h
    dovec_h=1:K-1;
else
    dovec_h=1:K;
end
end




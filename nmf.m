function [w,h,peval]=nmf(v,w,h,peval,verbose)
% [w,h,peval]=nmf(v,w,h,peval,verbose)
% Non-negative matrix factorisation updates minimising KL divergence KL(V|WH)
% References : D.D. Lee and H.S. Seung. Algorithms for non-negative matrix
% factorization. Advances in neural information processing systems, 13, 2001.
%
% v    : N x T data matrix (N-pixels, T-time frames)
% w    : N x K spatial factor (sources)
% h    : K x T time factor (intensities)
% K is the rank of factorisation (number of sources).
%
% peval - (optional) setting of the evaluation parameters, if not specified
% parameters are set to default values (see nested function setDefaultValuesPeval).

checkin(v,w,h)

if ~exist('peval','var'); peval=[];end
if ~exist('verbose','var'); verbose=1;end
peval=setDefaultValuesPeval(peval); % set default values if not specified on input

K=size(w,2); % number of components
[dovec_w, dovec_h]=setDoVec(K,peval.fixBg_w,peval.fixBg_h);

dall=zeros(1, ceil(peval.maxiter/peval.checkTermCycle));
indexd=1;

for ii=1:peval.maxiter
    
    % h update:
    y1=w'*(v./(w*h));
    sw = sum(w,1)';
%     h(dovec_h,:)= bsxfun(@rdivide,h(dovec_h,:).*y1(dovec_h,:),sw(dovec_h));
    h(dovec_h,:)= (h(dovec_h,:).*y1(dovec_h,:))./repmat(sw(dovec_h),[1,size(h,2)]);
    h=max(h,eps); % adjust small values to avoid undeflow
    
    % w update:
    y2=(v./(w*h))*h';
    sh=sum(h,2)';
%     w(:,dovec_w)=bsxfun(@rdivide,w(:,dovec_w).*(y2(:,dovec_w)),sh(dovec_w));
    w(:,dovec_w)=(w(:,dovec_w).*y2(:,dovec_w))./repmat(sh(dovec_w),[size(w,1),1]);
    w=max(w,eps); % adjust small values to avoid undeflow
    
    % L1 normalization of w:
    sw = sum(w,1)'; % summation after the update of w...
%     w = bsxfun(@rdivide, w, sw');
%     h = bsxfun(@times, h, sw); % this is to keep the product WH constant after normalisation of w
    w=w./repmat(sw',[size(w,1),1]); 
    h=h./repmat(sw, [1,size(h,2)]);
    
    % Check termination and print values of KL divergence.
    if rem(ii,peval.checkTermCycle)==0
        d = ddivergence(v, w*h);
        if d < peval.dterm % Check termination.
            break
        end
        if verbose
            fprintf('Cycle %g D-divergence %g\n',ii,d)
            if verbose > 1
                fignum=100;                
                imageTiles(reshape(w,peval.nx,peval.ny,peval.K),fignum);
%                 plotKL(ii,d,101)
            end
        end
        
    end
end

peval.ddiv_end = ddivergence(v, w*h); % final values of the d-divergence
peval.numiter = ii;

if ii==peval.maxiter
    mfprintf(peval.fid,'\nMaximum number of iterations (%g) reaached!\n', ii)
end

mfprintf(peval.fid,'\nTermination D-divergence value is (%g).\n', peval.ddiv_end)

end % of main function

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:

function checkin(v,w,h) % Test for negative values in v, w and h.

if any([min(v(:))<0, min(w(:))<0, min(h(:)) < 0])
    error('Data entries can not be negative!');
end
end

function peval=setDefaultValuesPeval(peval)

if ~isfield(peval, 'dterm'); peval.dterm = 1; end %termination criterion
if ~isfield(peval, 'maxiter'); peval.maxiter = 1000; end
if ~isfield(peval, 'fixBg_w'); peval.fixBg_w=1; end % last (background) component w not updated
if ~isfield(peval, 'fixBg_h'); peval.fixBg_h=0; end % last (background) component h not updated
if ~isfield(peval, 'checkTermCycle'); peval.checkTermCycle=50; end % how often to check the termination criterion (KL divergence)
if ~isfield(peval, 'fid'); peval.fid=[]; end %

end

function [dovec_w, dovec_h]=setDoVec(K,fixBg_w,fixBg_h)
dovec_w=1:K-fixBg_w;
dovec_h=1:K-fixBg_h;
end

function plotKL(d,ii,h)
figure(h);
hold on;
plot(ii,d,'.');
grid on;
end




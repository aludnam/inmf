function [w,h,peval]=inmf(d,K,peval,verbose)
% [w,h,peval]=inmf(d,K,peval,verbose)
% Non-negative matrix factorisation with iterative restarts. This function
% is called by inmf_main.m.
%
% INPUT
% d:        Data in (2D matrix NXT, N is number of pixels, T is number of time frames).
% K:        Number of components (rank of factorisation).
% peval:    Parameters of the evaluation (see setDefaultValuesPeval.m for default values).
%
% OUTPUT
% w:        Spatial components. 
% h:        Temporal components.
% peval:    Parameters of the evaluation.

if ~exist('peval','var'); peval=[];end
if ~exist('verbose','var'); verbose=1;end
if isfield(peval,'ddiv'); peval.ddiv=[];end
if ~isfield(peval,'bg'); peval.bg = min(mean(d,2));end % If the background is not provided...

[N,T]=size(d);
meanv=mean(d(:));

for restart=1:K
    
    % Random initialisation + last component as a flat background:
    [winit,hinit]=initwh(N,T,K,meanv,peval.bg);    
    
    if restart>1        
        [sx, isx] = sort(sum(w.^2,1), 'descend'); % L2 norm sorting of w.        
        winit(:,1:restart-1)=w(:,isx(1:restart-1));
        hinit(1:restart-1,:)=h(isx(1:restart-1),:);        
    end
    
    printmsg(restart,K)
    
    % NMF algorithm:
    [w,h,peval]=nmf(d,winit,hinit,peval,verbose);
    
    peval.ddiv(restart) = ddivergence(d, w*h); % Final values of the d-divergence.
end

end % of main function

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:
function printmsg(restart,K)
fprintf('\n===================================\n')
fprintf('\nRestart %g/%g: L2 sorted components [1:%g] reused.\n', restart,K,restart);
end
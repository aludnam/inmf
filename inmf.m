function [w,h,peval]=inmf(d,K,peval,verbose)

if ~exist('peval','var'); peval=[];end
if ~exist('verbose','var'); verbose=1;end
if isfield(peval,'ddiv'); peval.ddiv=[];end
if ~isfield(peval,'bg'); peval.bg = min(mean(d,2));end % If the background is not provided...

checkin(d); % Test for negative values in d.
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
    
    [w,h,peval]=nmf(d,winit,hinit,peval,verbose);
    
    peval.ddiv(restart) = ddivergence(d, w*h); % final values of the d-divergence
    %meanv=mean(mean(d-w(:,1:restart)*h(1:restart,:))); % mean value (+ background) of the data minus alrady estimate components
end

end % of main function

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:

function checkin(d) % Test for negative values in d.

if min(d(:))<0
    error('Data entries can not be negative!');
end

end

function printmsg(restart,K)
fprintf('\n===================================\n')
fprintf('\nRestart %g/%g: L2 sorted components [1:%g] reused.\n', restart,K,restart);
end
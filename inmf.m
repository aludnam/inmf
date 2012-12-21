function [w,h,peval]=inmf(d,K,peval,verbose)

if ~exist('peval','var'); peval=[];end
if ~exist('verbose','var'); verbose=1;end
peval=setDefaultValuesPeval(peval);

checkin(d); % Test for negative values in d.
[N,T]=size(d);
meanv=mean(d(:));

for restart=1:K-1
    
    % Random initialisation + last component as a flat background:
    [winit,hinit]=initwh(N,T,K,meanv,peval.bg);
    printmsg(peval.fid,restart,K)
    
    if restart>1        
        [sx, isx] = sort(sum(w.^2,1), 'descend'); % L2 norm sorting of w.
        
        winit(:,1:restart)=w(:,isx(1:restart));
        hinit(1:restart,:)=h(isx(1:restart),:);
    end
    
    [w,h,peval]=nmf(d,winit,hinit,peval,verbose);   
end

end% of main function

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:

function peval=setDefaultValuesPeval(peval)

if ~isfield(peval, 'fid'); peval.fid=1; end % Print on the screen only. Set to peval.fid=[] for no message.  
if ~isfield(peval, 'bg'); peval.bg=eps; end % Default background

end

function checkin(d) % Test for negative values in d.

if min(d(:))<0
    error('Data entries can not be negative!');
end

end


function printmsg(fid,restart,K)
mfprintf(fid,'\n===================================\n')
mfprintf(fid,'\nRestart %g/%g: [1:%g] L2 sorted components reused. The rest initialised at random.\n', restart,K-1,restart);
end
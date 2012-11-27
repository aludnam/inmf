function [w,h,peval]=inmf(v,K,verbose)

if ~exist('peval','var'); peval=[];end
if ~exist('verbose','var'); verbose=1;end
peval=setDefaultValuesPeval(peval)

checkin(v);
[N,T]=size(v);

for restart=1:K
    
    hinit = rand(K,T);
    winit = rand(N,K);
    
    if restart>1
        printmsg(peval.fid,restart)
        [sx, isx] = sort(sum(w.^2,1), 'descend'); % L2 norm sorting of w.
        
        winit(:,1:restart)=w(:,isx(1:indexrestart));
        hinit(1:restart,:)=h(isx(1:indexrestart),:);
    end
    
    [w,h,peval]=nmf(v,winit,hinit,peval,verbose);
    
end
end% of main function

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:

function peval=setDefaultValuesPeval(peval)

if ~isfield(peval, 'fid'); peval.fid=[]; end %

end

function checkin(v) % Test for negative values in v, w and h.

if min(v(:))<0
    error('Data entries can not be negative!');
end
end


function printmsg(fid,restart)
mfprintf(fid,'\n===================================\n')
mfprintf(fid,'\nRestart %g: [1:%g] L2 sorted components reused. The rest initialised at random.\n', restart,restart);
end
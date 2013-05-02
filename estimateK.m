function K=estimateK(v,threshold_pca)
% Estimates number of compontents from the magnitude of the principal components. 
%
% K=estimateK(v, threshold_pca)

pc=princCoef(v'); % sorted principal components     
pcn=pc/max(pc);
f=find(pcn>threshold_pca);            
K = f(end)+1;
end

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:
function pc=princCoef(v)
% Computes (sorted) principal coeeficients for data matrix v from eigenvalues of the
% covariance matrix cov(v); 
%
% pc=princCoef(v); 

covmat=cov(v); 
[eVec,eVal]=eig(covmat); 
pc=(sort(diag(eVal),'descend'));
end
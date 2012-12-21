function pc=princCoef(v); 
% pc=princCoef(v);
% 
% Computes (sorted) principal coeeficients for data matrix v from eigenvalues of the
% covariance matrix cov(v); 

covmat=cov(v); 
[eVec,eVal]=eig(covmat); 
pc=(sort(diag(eVal),'descend'));
    
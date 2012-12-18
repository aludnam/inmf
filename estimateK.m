function K=estimateK(v, threshold_pca)
% K=estimateK(v, threshold_pca)
% Estimates number of compontents from the magnitude of the principal
% components. 

pc=pca(v'); % sorted principal components     
pcn=pcacoef/max(pc);
f=find(pcn>threshold_pca);            
K = f(end);
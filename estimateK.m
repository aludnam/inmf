function K=estimateK(v,threshold_pca)
% K=estimateK(v, threshold_pca)
% Estimates number of compontents from the magnitude of the principal
% components. 

pc=princCoef(v'); % sorted principal components     
pcn=pc/max(pc);
f=find(pcn>threshold_pca);            
K = f(end)+1;
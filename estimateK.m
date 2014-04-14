function [K,pcn]=estimateK(v,threshold_pca,show_plot)
% Estimates number of compontents from the magnitude of the principal components. 
%
% K=estimateK(v, threshold_pca)
if ~exist('show_plot','var')
    show_plot = 0; 
end
pc=princCoef(v'); % sorted principal components     
pcn=pc/max(pc);
f=find(pcn>threshold_pca);            
K = f(end)+1;
if show_plot
    plot_pcn(pcn, threshold_pca,K, show_plot)
    
end
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

function plot_pcn(pcn, threshold_pca,K, show_plot)
    figure;
    rng = 2:100; 
    plot(rng,pcn(rng))
    hold on
    plot(rng,repmat(threshold_pca,length(rng)),'--r')
    line([K,K],[0,pcn(rng(1))])
    xlabel('number of components K')
    ylabel('pc (normalised)')
    grid on
    title(['[',num2str(show_plot),'], ', 'K = ', num2str(K)])
end
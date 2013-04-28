function [winit,hinit]=initwh(N,T,K,meanv,bg)
% [winit,hinit]=initwh(N,T,K,meanv,bg)
% meanv - mean of the data -> meanv=mean(v(:))
% bg - background value per pixel

winit = normL(max(rand(N,K),eps),1); % sum(winit,1) is 1
hinit=max((meanv-bg)*rand(K,T),eps); % The multiplication by (meanv-bg) is there for getting it into reasonable range.
winit(:,K)=1/N*ones(N,1); % flat background component
hinit(K,:)=bg*N*ones(1,T); % intensity of the background
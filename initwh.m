function [winit,hinit]=initwh(N,T,K,meanv,bg)
% [winit,hinit]=initwh(N,T,K,meanv,bg)
% meanv - mean of the data -> meanv=mean(v(:))
% bg - background value per pixel
% random intitialisation but keeping the mean(mean(winit*hinit)) equal to meanv

winit = 2/N*max(rand(N,K),eps); % sum(winit,1) is approximately 1
hinit = N*T*abs(meanv-bg)*(2/T)/(K-1)*max(rand(K,T),eps); % mean(mean(winit*hinit))=meanv; abs() is a cheap fix for case wehre meanv<bg

winit(:,K)=1/N*ones(N,1); % flat background component
hinit(K,:)=bg*N*ones(1,T); % intensity of the background
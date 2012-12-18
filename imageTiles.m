function imageTiles(im,h)
% imageTiles(im,h)

if ~exist('h','var'); h=0; end

cmap = 'gray';
s=size(im,3);
a=round(sqrt(s));
b=ceil(s/a);

if h 
    figure(h);
else
    figure;
end

for ii=1:s
    subplot(a,b,ii)
    imagesc(im(:,:,ii));
    colormap(cmap);
    set (gca, 'DataAspectRatio',[1 1 1],'xtick',[],'ytick',[]);        
end
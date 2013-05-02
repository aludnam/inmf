function imageTiles(im,h,a,b)
% Tiles the frames of the 3D image.
%
% imageTiles(im,h,a,b)
% 
% im - input image (3D) 
% h - (optional) handle of a new figure 
% a - (optional) number of frames along vertical direction
% b - (optional) number of frames along horizontal direction

if exist('h','var')
    figure(h); 
else 
    figure; 
end

cmap = 'gray';
s=size(im,3);
if ~exist('a','var')
    a=round(sqrt(s));
end
if ~exist('b','var')
    b=ceil(s/a);
end

for ii=1:s
    subplot(a,b,ii)
    imagesc(im(:,:,ii));
    colormap(cmap);
    set (gca, 'DataAspectRatio',[1 1 1],'xtick',[],'ytick',[]);        
end
function showPatches(im,patchSizeX,patchSizeY,patchOverlap,threshold_pca,threshold_patchBrightness,patch_offset)
% Shows division of the data into smaller patches. 
%
% showPatches(im,patchSizeX,patchSizeY,patchOverlap,threshold_pca,threshold_patchBrightness)
% 
% im: input data
% patchSizeX: size of the patch
% patchSizeX: size of the patch
% patchOverlap: overlap of the patches
% threshold_pca: (optional) if specified, estiamtes the number of components 
% in each patch (K) and displays it in the patch
% threshold_patchBrightness: (optional) if specified checks the brightness
% of each patch and compares it to the mean brightness of the data. If
% below the threshold the patch is ignored. 

if ~exist('threshold_patchBrightness','var')
    threshold_patchBrightness=0;
end
if ~exist('patch_offset','var')
    patch_offset = [0,0];
end
[sx,sy,sz]=size(im);
cmap='gray';

[nPatchX,nPatchY]=npatch(sx,sy,patchSizeX,patchSizeY,patchOverlap);
fignum = 1000;
figure(fignum)
imagesc(mean(im,3)),
set (gca, 'DataAspectRatio',[1 1 1],'xtick',[],'ytick',[]);
colormap(cmap);
maxMeanDataIn=max(max(mean(im,3)));
nPatch = 0; 
for patchX=1:nPatchX
    for patchY=1:nPatchY
        [cornerTL, cornerBR]=patchCorner(patchX,patchY,patchSizeX,patchSizeY,patchOverlap,sx,sy,patch_offset);
        col = rand(1,3);
        
        textToShow=['P-' num2str(patchX) '-' num2str(patchY)];
        text (0.5*(cornerBR(2)+cornerTL(2))-3, cornerTL(1)+0.5*(cornerBR(1)-cornerTL(1))-2,textToShow,'color',1-[eps eps eps])
        lineW=3;
        if exist('threshold_pca','var')
            dpix=im(cornerTL(1):cornerBR(1),cornerTL(2):cornerBR(2),:);
            mmd=max(max(mean(dpix,3)));
            if (mmd/maxMeanDataIn)<threshold_patchBrightness;
                lineW=1;                
            else
                nPatch = nPatch + 1;
                patchX
                patchY
                if ~isempty(threshold_pca)
                    [nx,ny,nt]=size(dpix);
                    d=reshape(dpix,nx*ny,nt);
                    K=estimateK(d,threshold_pca,[patchX,patchY]);
                    figure(fignum)
                    textToShow=['K=' num2str(K)];
                    text (0.5*(cornerBR(2)+cornerTL(2))-3, cornerTL(1)+0.5*(cornerBR(1)-cornerTL(1))+2,textToShow,'color',1-[eps eps eps])
                end
            end
        end
        addColorBox(cornerTL,cornerBR, col,lineW,1);
    end    
end
sprintf('Number of patches considered for evaluation: %g',nPatch)
end

%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

% Nested functions:
function addColorBox(topLeft,bottomRight,color,linewidth,flipCoord,linestyle)
% Adds color box to an image. 
%
% addColorBox(topLeft,bottomRight,color,linewidth,flipCoord,linestyle)
%
% topLeft, bottomRight are the coorinated of the box corners. 
% color: color of hte box. default: color = 'red'
% linewidth: width of the line. default: linewidth=1
% flipCoord: if st to 1 then coordinates are fliped (this is for marix in double)
% linestyle: style of the line. default: linestyle='-'

if ~exist('color','var'); color = 'red'; end
if ~exist('linewidth','var'); linewidth= 1; end
if ~exist('flipCoord','var');flipCoord=0; end
if ~exist('linestyle','var');linestyle='-'; end


c1=topLeft;
c2=bottomRight;
if flipCoord % this is because of hte dip_image mismatch of coordiantes system
    c1=fliplr(c1);
    c2=fliplr(c2); 
end

line([c1(1) c1(1)], [c1(2) c2(2)],'color',color,'linewidth',linewidth,'linestyle',linestyle)
line([c2(1) c2(1)], [c1(2) c2(2)],'color',color,'linewidth',linewidth,'linestyle',linestyle)
line([c1(1), c2(1)], [c1(2) c1(2)],'color',color,'linewidth',linewidth,'linestyle',linestyle)
line([c1(1), c2(1)], [c2(2) c2(2)],'color',color,'linewidth',linewidth,'linestyle',linestyle)
end
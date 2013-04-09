function showPatches(im,patchSizeX,patchSizeY,patchOverlap,threshold_pca,threshold_patchBrightness)
% showPatches(im,patchSizeX,patchSizeY,patchOverlap,threshold_pca)

[sx,sy,sz]=size(im); 
cmap='gray';

[nPatchX,nPatchY]=npatch(sx,sy,patchSizeX,patchSizeY,patchOverlap);

imagesc(mean(im,3)),
set (gca, 'DataAspectRatio',[1 1 1],'xtick',[],'ytick',[]);
colormap(cmap);
maxMeanDataIn=max(max(mean(im,3)));

for patchX=1:nPatchX
    for patchY=1:nPatchY
        [cornerTL, cornerBR]=patchCorner(patchX,patchY,patchSizeX,patchSizeY,patchOverlap,sx,sy);
        col = rand(1,3);

        textToShow=['P' num2str(patchX) num2str(patchY)];
        text (0.5*(cornerBR(2)+cornerTL(2))-3, cornerTL(1)+0.5*(cornerBR(1)-cornerTL(1))-2,textToShow,'color',1-[eps eps eps])
        lineW=3;
        if exist('threshold_pca','var')       
            dpix=im(cornerTL(1):cornerBR(1),cornerTL(2):cornerBR(2),:);                                    
            [nx,ny,nt]=size(dpix);                        
            d=reshape(dpix,nx*ny,nt);
            K=estimateK(d,threshold_pca);           
            textToShow=['K=' num2str(K)];
            text (0.5*(cornerBR(2)+cornerTL(2))-3, cornerTL(1)+0.5*(cornerBR(1)-cornerTL(1))+2,textToShow,'color',1-[eps eps eps])
        end
        if exist('threshold_patchBrightness','var')
            mmd=max(max(mean(dpix,3))); 
            if mmd/maxMeanDataIn<threshold_patchBrightness;
                lineW=1;                
            end
        end
        addColorBox(cornerTL,cornerBR, col,lineW,1);
    end
end
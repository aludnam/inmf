clear peval
peval.bg = 100;
peval.maxiter=51;
peval.nRuns=2; 
peval.patchSizeX=30; 
peval.patchSizeY=30; 
savethis =1; 
verbose =2; 
load dpixc

tic
inmf_main(dpixc,peval,savethis,verbose);
toc

%%
for n=1:2
    dirname=['P11/results_run' num2str(n) '/'];
    load([dirname,'w.mat']);
    load([dirname,'h.mat']);
    load([dirname,'peval.mat']);    
    res(:,:,n)=makeHiRes(w,h,peval.nx,peval.ny,4,10);
end
wf=sum(dpixc,3);
wfi=makeHiRes(wf(:),1,peval.nx,peval.ny,4,1);
dipshow(res)
dipshow(wf)
dipshow(cat(3,wfi,sum(res,3)))

clear peval
peval.bg = 100;
peval.maxiter=10;
peval.nRuns=2; 
savethis =1;
verbose =2; 
load dpixc

tic
inmf_main(dpixc,peval,savethis,verbose);
toc

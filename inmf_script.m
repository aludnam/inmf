peval.bg = 100;
peval.Kinput = 3;
peval.maxiter=100;
savethis =0;
verbose =2; 
load dpixc

tic
inmf_main(dpixc,peval,savethis,2);
toc

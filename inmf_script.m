clear peval
peval.bg = 100;
peval.maxiter=100;
savethis =1;
verbose =2; 
% load dpixc

tic
inmf_main(dpixc,peval,savethis,verbose);
toc

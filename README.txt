Non-negative matrix factorisation algorithm with iterative restarts (iNMF). 
Tested in MATLAB2008b. 

CONTENT:

ddivergence.m
estimateK.m
imageTiles.m
inmf.m
inmf_main.m
makeHiRes.m
nmf.m
normL.m
npatch.m
patchCorner.m
setDefaultValuesPeval.m
showPatches.m
stitch.m

Type 'help inmf" for more information. 

USAGE:

To run inmf with default settings (saved in setDefaultValuesPeval.m): 

inmf_main(<input data>,<output directory>)

<input data> is a 3D matrix (nx X ny X T, nx,ny - number of pixels in x,y direction, T - number of time frames).

Output will be saved in <output direcotry> directory. 

Type "help inmf_main" for more information. 

EXAMPLES:

General example of the iNMF evaluation. 
Examples/example.m 

To reproduce the figures in the paper:

Fig.4 - simulated data:
Examples/example_fig4_sim.m

Fig.4 - experimental data:
Examples/example_fig4_exp.m

Fig.7 - experimental data:
Examples/example_fig7.m


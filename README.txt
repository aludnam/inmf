Non-negative matrix factorisation algorithm with iterative restarts (iNMF). 
Code by Ondrej Mandula, June 2014 .  Tested in MATLAB2008b. 

To accompany the paper

"Localisation microscopy with quantum dots using non-negative matrix
factorisation" by Ondrej Mandula, Ivana Sumanovac, Rainer Heintzmann,
Christopher K. I. Williams (2014).


USAGE:

To run inmf with default settings (saved in setDefaultValuesPeval.m) do: 

inmf_main(<input data>,<output directory>)

<input data> is a 3D matrix (nx X ny X T, nx,ny - number of pixels in x,y 
direction, T - number of time frames).

Output will be saved in <output directory> directory. 

Type "help inmf_main" for more information. See also Contents.m file.

EXAMPLES:

These are found in the Examples directory.

Example 1)

Run the code example_sim.m. The data is simulated from 8 sources. peval.Kinput=15 sources are specified in the code.

Observe the estimated sources updating over time. Note that after 
iteration j, sources (j+1) to K are re-initialized to noise.

Example 2) 

Run example_fig4_sim.m. This is simulated data in a # shape, as shown in 
Fig. 4a in the manuscript.  
The number of sources is estimated to be 30, based on PCA. 10 runs are 
carried out, and the results across runs are combined.

Example 3) 

Run example_fig4_exp.m. This is real data of a 18 X 18 pixel region of 
QD-labelled tubulin, as shown in Fig. 4b in the manuscript.  
The number of sources is estimated to be 34, based on PCA. 10 runs are 
carried out, and the results across runs are combined.

Example 4) 

Run example_fig6_exp.m. This is real data of out-of-focus QDs as shown in 
Fig. 6b of the manuscript.
The number of sources is estimated to be 22, based on PCA.

LICENCE:

Permission is granted for anyone to copy, use, or modify these
programs for purposes of research or education, provided this
copyright notice is retained, and note is made of any changes that
have been made.

These programs are distributed without any warranty, express or
implied. As these programs were written for research purposes only,
they have not been tested to the degree that would be advisable in any
important application.  All use of these programs is entirely at the
user's own risk.

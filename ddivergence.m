function d = ddivergence(A,B)
% Computes generalised Kullback-Leibler divergence KL(A|B) between matrices A and B.
%
% d = ddivergence(A,B);

dm = A.*log (A./B) - A + B;
d = sum(dm(:));
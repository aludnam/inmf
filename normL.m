function N=normL(M,dim,Lnorm)
% Normalizes marix M along dimension dim according to the L-norm norm such that sum(M.^Lnorm,dim)=1. 
%
% N=normL(M,dim,Lnorm)
%
% M -       input matrix.
% dim -     dimension along which the matrix should be normalized.
%           Default value: dim=1.
% Lnorm -   L norm according to which the matrix should be normalised.
%           Default value: Lnorm=1. 
%
% For example to get matrix with rows summing to one:
% M=rand(6,3); 
% N=normL(M,2,1); 
% sum(N,2)

if nargin<2
    dim=1;
end

if nargin<3
    Lnorm=1; 
end

if dim>ndims(M)
    error('Wrong dimension.')
end

sM=sum(M.^Lnorm,dim);
rv=ones(1,ndims(M));
rv(dim)=size(M,dim); 
N=M./repmat(sM.^(1/Lnorm),rv);
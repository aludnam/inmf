
A=rand(25^2,50);
B=rand(25^2,50);
tic
for ii=1:1
    [w,h,peval]=nmf(v,wi,hi,[]);
end
toc
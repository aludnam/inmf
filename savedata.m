function savedata(path,w,h,peval)
% savedata(path,w,h,peval)
% Saves iNMF results into a direcotry defined by 'path'.

if ~exist('path','var'); path=cd; end % Default direcotry.

mkdir(path)
peval.path_results = path;

save([peval.path_results '/w'],w);
save([peval.path_results '/h'],h);
save([peval.path_results '/peval'],peval);

% Save peval as a peval.txt file. 
fid = fopen([peval.path_results 'peval.txt'],'wt');
fn =fieldnames(peval);
for ii = 1: length(fn)
    name = fn{ii};
    value = getfield(peval,fn{ii});
    if ischar (value)
        fprintf (fid, [name ' = ''' value '''\n']);
    else
        if length(value)==1
            fprintf (fid, [name ' = %g \n'], value);
        else
            fprintf (fid, [name ' = [']);
            fprintf (fid, '%g ', value);
            fprintf (fid, ']\n');            
        end
    end
end    
function fid = initlog(path,filename)
% fid = initlog(path,filename)
% Initializes log-file in the current directory specified with "path" and
% "filename" and gives identifier fid. Default is current direcotry and
% evaluation.log file name. 

if ~exist('path','var'); path = cd; end % Default directory. 
if ~exist('filename','var'); filename = 'evaluation.log'; end % Default name.  

fidf = fopen([path '/' filename],'wt');
fprintf(fidf,'Computation: %s\n\n', datestr(now));

fid=[fidf,1]; % Identifier for "mfprintf.m" function. 

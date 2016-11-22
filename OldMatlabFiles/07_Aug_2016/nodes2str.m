function [ Nodes ] = nodes2str( fn )

fid = fopen(fn);  % open file
% read all contents into data as a char array
% (DO NOT forget the `'` to make it a row rather than a column).
Nodes = fread(fid, '*char')';
fclose(fid);

end


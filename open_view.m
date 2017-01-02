function stat = open_view(file)

% Open abaqus viewer session(optional - eliminates the running Matlab session) - under construction

cfview = strcat('database=', file);
opv = 'abaqus viewer j';
cmdview = strrep(opv, 'j', cfview);
[stat_vi, cmdvi] = system(cmdview, '-echo');

end


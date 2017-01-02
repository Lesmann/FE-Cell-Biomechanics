function [] = init_path( paths )

% This function initializes Matlab's source directory before executing a
% job in Abaqus.

% set source-directory to base
ch = return2base(paths.base);

% initiate Matlab's path to full path
cd(paths.dest.run_time);
[stat, CO] = system('cd', '-echo'); % verify path

end


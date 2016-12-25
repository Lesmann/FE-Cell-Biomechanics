function init_model(paths, frame)

% This function createe a new model and stores in the appropriate paths in
% 'paths'.

% Create initial model (first frame)
run modelcreation_mainscript.m

% Copy configuration structure to appropriate dynamic model path and update its file
% name by frame number (currently all similar - done for further possible use).

config = load(paths.src.config);
curr_config_file = ['config#', frame, '.mat'];
DCR_config_dest = [paths.dest.config, curr_config_file];
copyfile(paths.src.config, DCR_config_dest);

% Copy model inp file to appropriate dynamic model path and update its file
% name by frame number.

fn = strrep(config.fn, '.inp', '');
inp_dest = [paths.dest.inp, fn, '#', frame, '.inp'];
inp_src = paths.src.inp;

copyfile(inp_src, inp_dest);
copyfile(paths.src.inp, paths.dest.run_time);

% Copy nodes and elements to appropriate dynamic model path and update its file
% name by frame number.
nodes_dest = [paths.dest.nodes, 'nodes#', frame, '.csv'];
copyfile(paths.src.nodes, nodes_dest);

elements_dest = [paths.dest.elements, 'elements#', frame, '.csv'];
copyfile(paths.src.elements, elements_dest);

end


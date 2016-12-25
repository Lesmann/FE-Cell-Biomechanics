function paths = DCR_set_paths()

% This function sets the appropriate source and destination paths for DCR

paths.base = 'E:\ '; % base path for primary initialization
path.src.db = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\DCR\'; % DCR source directory

paths.src.config = 'E:\Ran\Cell-ECM_model_2D_1_cell\LastConfig\config.mat';
paths.src.inp = 'E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\';
paths.src.nodes = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\nodes.csv';
paths.src.elements = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\elements.csv';

paths.dest.run_time = [path.src.db, 'DCR_Runtime\']; % runtime destination directory
paths.dest.config = [path.src.db, 'DCR_Config\'];
paths.dest.inp = [path.src.db, 'DCR_inp\'];
paths.dest.nodes = [path.src.db, 'DCR_nodes\'];
paths.dest.elements = [path.src.db, 'DCR_elements\'];
paths.dest.FO = [path.src.db, 'DCR_Field_Outputs\'];

end


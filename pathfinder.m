function [ GDP ] = pathfinder( path, geo_range, val_range )

% This function finds all paths of the nodes in 'ic' with gradient descent path (GDP) of range specified by 'range'

% 'path' = path to rpt directory
% 'geo_range' = geometrical distance of GDP (should be half of the distance
% between the cells).
% 'val_range' = minimal range of normalized value.
% 'val_range' is a number between 0 and 1 which states what is the lowest.
% part of the maximal parameter value to which the GDP will descend.

% This function returns:
% 1. list of node numbers in each path.
% 2. each path's absolute length.
% 3. each path's average angle.
% 4. matix of node coordinates of all paths (for 'scatter' plot).

nodes_path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\nodes.csv';
nodes = csvread(nodes_path);

path2config = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Config.mat';
config = load(path2config);
Res.Config = config.config;

[ fnames, rawdata ] = rd( path ); % load data from all files in path
Res.FileName = fnames;

cells = Res.Config.Cells_Information.cell_nodes;

for i = 1 : length(cells)
    for j = 1 : length(nodes)
        Rel_nodes = Node_Scan(nodes, geo_range, cells(i, :));
    end
end

for i = 1 : length(fnames)
    
    curr_file = fnames{i};
    Data(i) = dd( rawdata(i, :) ); % extract and divide data
    
    fields = fieldnames(Data(i));
    
    
    for c = fd : length(fields)
        % Normalized data of all fields
        Norm_data(i).(fields(fd)) = Data(i).(fields(fd))\max(Data(i).(fields(fd))); 
        
        % Filtered data of all fields (filtration by specified value range)
        Filt_data(i).(fields(fd)) = Data(i).(fields(fd))(:, N_data(i).(fields(fd) >= val_range));
        
    end
    
    
    
    
    

    ic = config.Cells_Information.cell_nodes;
    ic_data = data(ic);
    
    [lic, wic] = size(ic);
    
    if wic > 1
        num_of_cells = unique(ic(:, 1));
        
        for j = 1 : num_of_cells
            for k = 1 : lic
                
                
                
            end
        end
        
    end
end

end


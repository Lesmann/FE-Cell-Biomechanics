function regions = get_cell_region(nodes, cells, config)

% This function returns a nodes-strip containing all cells in the model.

% Get the upper and lower cells in the model (for nodal restriction)
extreme_cells = get_extreme_cells(cells);

%% THE PROBLEM IS HERE... need to somehow get the node closest to cells

% Compute distance from origin of upper and lower extreme cells
DFO_extreme.upper = sqrt(extreme_cells.upper(1)^2 + extreme_cells.upper(2)^2);
DFO_extreme.lower = sqrt(extreme_cells.lower(1)^2 + extreme_cells.lower(2)^2);

% Calculate distance from origin of all nodes
DFO_nodes = sqrt(nodes(:, 1).^2 + nodes(:, 2).^2);

% find indexes of nodes closest to upper and lower extreme cells
idx_node2upper_cell = knnsearch(DFO_nodes, DFO_extreme.upper);
idx_node2lower_cell = knnsearch(DFO_nodes, DFO_extreme.lower);

% Get coordinates of nodes closest to extreme cells
upper_cell_node = nodes(idx_node2upper_cell, :);
lower_cell_node = nodes(idx_node2lower_cell, :);

% Get y coordinate of nodes closest to extreme cells
y_upper = upper_cell_node(2);
y_lower = lower_cell_node(2);

%%

% Extend strip to ensure cells are within strip
y_plus_upper = y_upper + 10*config.regParams.iSeed;
y_minus_lower = y_lower - 10*config.regParams.iSeed;

% get all nodes that are lower/equal to upper y limit and higher/equal to
% lower y limit
cell_region_idx = nodes(:, 2) < y_plus_upper & nodes(:, 2) > y_minus_lower;
regions.cell_region = nodes(cell_region_idx, :);

% get cell region dimensions
regions.dimensions.cells_region = get_region_dims(regions.cell_region, config);

upper_region_idx = nodes(:, 2) >= y_plus_upper;
lower_region_idx = nodes(:, 2) <= y_minus_lower;

regions.upper_region = nodes(upper_region_idx, :);

% get upper region dimensions
regions.dimensions.upper = get_region_dims(regions.upper_region, config);

regions.lower_region = nodes(lower_region_idx, :);

% get lower region dimensions
regions.dimensions.lower = get_region_dims(regions.lower_region, config);

end


function [ el ] = GenEl2d_v4( nodes, config )

% Under Construction!!

% This function is an integrated version of GenEl2d_v2.m and GenEl2d_v3.m
% in order to properly generate th elements vector while substancially
% reducing run-time, The function operates as follows:

% 1. finds the all nodes in the region around each cell.
% 2. Sections the remaining nodes into square\rectangular regions.
% 3. For each section-output obtained in 1, the algorithm implements
%    GenEl2d_v2.m
% 4. For each section-output obtained in 3, the algorithm implements
%    GenEl2d_v3.m

% Get rectangular region surrounding the cells
cells = config.cells;

regions = get_cell_region(nodes, cells, config);

% Implement GenEl2d_v2 on cell_region (element generation by nodal distance)

cell_basic_elements = GenEl2d_v2 ( regions.cell_region, config, 1 );
cell_oblique_elements = GenEl2d_v2 ( regions.cell_region, config, sqrt(2) );
cell_elements = vertcat(cell_basic_elements, cell_oblique_elements);

upper_elements = GenEl2d_v3( regions.upper_region,...
    config, regions.dimensions.upper );
lower_elements = GenEl2d_v3( regions.lower_region,...
    config, regions.dimensions.lower );

none_cell_elements = vertcat(upper_elements, lower_elements);

el = vertcat(none_cell_elements, cell_elements);

%% Under Construction
% Section cell region to sub-sections

% rect_sections = section_network(cell_region, nodes);
%%

% Implement GenEl2d_v3 on rect_sections (matrix-based element generation)

% for i = 1 : length(rect_sections)
%     curr_section = rect_sections{i};
%     if i == 1
%         section_elements = GenEl2d_v3( curr_section, config );
%     else
%         next_section_elements = GenEl2d_v3( curr_section, config );
%         section_elements = horzcat(section_elements, next_section_elements);
%     end
% end
% 
% el = vertcat(cell_elements, section_elements);


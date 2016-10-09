function [ Res ] = Analyse_v2( path )

% This function generates plots for 2d multi-cellular models.

% 1. Read and extract data from 'path'.
% 2. Read configuration file (all models should be of the same cell formation).
% 3. Let the user define cut-angle 'cut_angle'

% 3. For each cell:

% a. Determine neighboring cells (distance (dist2cell) and angle (ang2cell)).
% b. get all nodes within the cut:
% - center-line defined as direct line to neighbore cell.
% - cut is define as 'cut_angle'/2 from both sides of the center-line.

%  Read nodes.csv

n = 35; % Number of sampling points

% This is the aperture angle from the straight line 
% towards a neighboring cell .
Aperture = 15*(pi/180); 
path2nodes = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\nodes.csv';
path2config = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Config.mat';
config = load(path2config);
nodes = fileread(path2nodes);

% 1. Read and extract data from 'path'

[fnames, rawdata] = rd(path);

[ Ur, ~, ~ ] = extract_data( rawdata );

lfn = length(fnames);
cells = config.cells;
lcells = length(cells);
Res = struct;

% 3. Determine neighboring cells
for i = 1 : lfn
    currfn = fnames(i);
for j = 1 : lcells
    currCell = cells(:, j);
    [dist2cell, ang2cell] = findneighbors(currCell);
    for k = 1 : length(dist2cell)
        % 4. Average node-data within the cut
        ang = [ang2cell(k)-Aperture, ang2cell(k)+Aperture];
        [ Res.(currfn).mUr(k) ] = avgUr( nodes, Ur, currCell, r,...
            r+dist2cell{k}, ang, n );
    end
end

end


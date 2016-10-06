function [ Res ] = Analyse_v2( path )

% This function generates plots for 2d multi-cellular models.

% 1. Read and extract data from 'path'.
% 2. Read configuration.
% 3. Let the user define cut-angle 'cut_angle'

% 3. For each cell:

    % a. Determine neighbore-cells (distance (dist2cell) and angle(ang2cell)).
    % b. get all nodes within the cut:
     % - center-line defined as direct line to neighbore cell.
     % - cut is define as 'cut_angle'/2 from both sides of the center-line.


end


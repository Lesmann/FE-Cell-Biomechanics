function [dist2cell, ang2cell] = findneighbors(Cell, Cells, config)

% This function determines which coordinates from the coordinates list 'Cells'
% is within the neighborhood of the coordinate 'Cell'.

% r = config.Cells_Information.Distance_between_Cells;

% find all 'Cells' closest to 'Cell' and their distance from 'Cell'
[idx, dist2cell] = dsearchn(Cells, Cell);

% find all angles from 'Cell' to the closest 'Cells'
for i = 1 : length(idx)
    
    x = abs(Cell(1)-Cells(idx(i), 1));
    y = abs(Cell(2)-Cells(idx(i), 2));
    ang2cell(i) = atan(y/x)*180/pi;

end


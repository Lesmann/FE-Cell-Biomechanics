function extreme_cells = get_extreme_cells(cells)

% This function returns the upper and lower extreme cells ('extreme_cells') in the list of
% cells 'cells'. i.e. cells with the highest and lowest y coordinates.

y_cells = cells(:, 2);

[~, min_idx] = min(y_cells);
[~, max_idx] = max(y_cells);

extreme_cells.lower = cells(min_idx, :);
extreme_cells.upper = cells(max_idx, :);

end


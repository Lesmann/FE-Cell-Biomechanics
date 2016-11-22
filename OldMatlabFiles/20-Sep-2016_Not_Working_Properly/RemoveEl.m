function [nodes2remove, El] = RemoveEl(El, rNodes)

% This function removes the corresponding elements to the nodes removed
% from cell center points (without leaving 'loose elements ends').

% 1. Get all element columns that have 'rNodes' indexes.

col1 = El(:, 1);
col2 = El(:, 2);

% 2. Search rows that includes 2 indexes that appear in 'rNodes'.
ix1 = find(ismember(col1, rNodes));
ix2 = find(ismember(col2, rNodes));

% 3. Remove these rows from the elements vector
remove = intersect(ix1, ix2);
nodes2remove1 = El(remove, 1);
nodes2remove2 = El(remove, 2);
nodes2remove = vertcat(nodes2remove1, nodes2remove2);
El(remove, :) = [];


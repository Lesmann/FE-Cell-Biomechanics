function Nodes = apply_circ_cells(ic, circNodes, Nodes)

% This function sets the inner nodes (i.e. cell conotur nodes) to new
% coordinates of a circle of radius 'r' (generated in the modelcreation_mainscript.m)
% to apply circular 2d cell shape. The function sets each corresponding
% node to its closest point on the circle.

% This function also rewrites the new node vector into a csv file.

Nodes = Nodes(:, 2:3);

% re-organize ic
[~, lic] = size(ic);
for i = 1 : length(unique(ic(:, 1)))
    oic(:, i) = ic(ic(:, 1)==i, end);
end

for i = 1 : length(circNodes)
    
    cic = oic(:, i);
    
    cN = circNodes{i};
    [IDX, ~] = knnsearch(cN, Nodes);
    
    cindx = IDX(cic);
    Nodes(cic, :) = cN(cindx, :);
    
end

serial = 1 : length(Nodes);
Nodes = horzcat(serial', Nodes);




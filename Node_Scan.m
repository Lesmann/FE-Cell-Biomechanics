function [ spec_nodes ] = Node_Scan( nodes, r, o )

% This function gets a list of nodes 'nodes' and a specified range 'r'
% and returns a structure 'spec_nodes' with the coordinates and info 
% of the nodes found within the range specified.

%------------------------------------------------------------------------------
% Algorithm used for this function is a straight forward loop-based one.
% optimization (par-for and\or matrix approach) is required for over 1000000 nodes for improved speed and
% resource management.
%------------------------------------------------------------------------------

% Information for each node:
% 1. Its radial angle in radians (with respect to the point 'o').
% 2. Its radial distance.

c=1;
xo = o(1); yo = o(2);

for i = 1 : length(nodes)
    curr_node = nodes(i, :);
    xn = curr_node(1); yn = curr_node(2);
    dx = xn-xo; dy = yn-yo;
    
    d = sqrt(dx^2+dy^2);
    
    if d <= r
        spec_nodes.coor(c, :) = curr_node;
        spec_nodes.nidx(c) = i;
        spec_nodes.ang(c) = atan(dy/dx);
        spec_nodes.ndx(c) = dx;
        c=c+1;
    end    
end

end


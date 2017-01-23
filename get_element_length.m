function [ element_length ] = get_element_length( nodes, elements)

% This function computes the length of elements according to nodes
% coordinates.

el1 = elements(:, 1); % nodes 1 serial in node-pairs (e.g. elements)
el2 = elements(:, 2); % nodes 2 serial in node-pairs (e.g. elements)

nodes1x = nodes(el1, 1); % nodes 1 x-coordinates
nodes2x = nodes(el2, 1); % nodes 2 x-coordinates

nodes1y = nodes(el1, 2); % nodes 1 y-coordinates
nodes2y = nodes(el2, 2); % nodes 2 y-coordinates

distx = nodes2x-nodes1x; % x component of distance between node-pairs
element_length.cartese_x = abs(distx);

disty = nodes2y-nodes1y; % y component of distance between node-pairs
element_length.cartese_y = abs(disty);

tetha = atan(disty./distx);

% distance between node-pairs (e.g. element length)
element_length.mag = sqrt(distx.^2 + disty.^2);
mag = element_length.mag;
element_length.polar_x = mag.*cos(tetha);
element_length.polar_y = mag.*sin(tetha);


end
function [ r_nodes ] = rotate_model( nodes, alpha )

% This function rotates a set of node according to the required angle 'alpha'

R = [cos(alpha) -sin(alpha); sin(alpha) cos(alpha)];

x = R(1, 1)*nodes(:, 1) + R(1, 2)*nodes(:, 2);
y = R(2, 1)*nodes(:, 1) + R(2, 2)*nodes(:, 2);

r_nodes = horzcat(x, y);

serial = 1:length(nodes);
r_nodes = horzcat(serial', r_nodes);

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'nodes.csv';
fn = strcat(path, fileName);
csvwrite(fn, r_nodes);

end


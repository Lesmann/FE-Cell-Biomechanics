function [ m_nodes ] = multiply_nodes_by( times )

% This function reads the nodes csv file currently exist in the csv file
% library and multiplies all coordinates by the input argument 'times'

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\nodes.csv';
nodes = csvread(path);

m_nodes = nodes(:, 2:3)*times;
serial = 1 : length(m_nodes);
m_nodes = horzcat(serial', m_nodes);

end


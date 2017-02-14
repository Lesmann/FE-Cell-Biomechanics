function [ m_nodes ] = multiply_nodes_by( times, file )

% This function reads the nodes csv file currently exist in the csv file
% library and multiplies all coordinates by the input argument 'times'

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\nodes.csv';
nodes = csvread(path);

m_nodes = nodes(:, 2:3)*times;
serial = 1 : length(m_nodes);
m_nodes = horzcat(serial', m_nodes);

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'm_nodes.csv';
fn = strcat(path, fileName);
csvwrite(fn, m_nodes);

fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\';
fn = strcat(fn, file);
inp = fileread(fn);
csvfile = 'm_nodes.csv';
csvfn = strcat(path, csvfile);
m_nodes = nodes2str(csvfn);
Splt_n_Push(fn, inp, m_nodes, '*Node', '*Element');
RemBlnkLines(fn);

end


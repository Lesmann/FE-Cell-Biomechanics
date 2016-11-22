function [] = Write2csv( nodes, elements )

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'elements.csv';
fn = strcat(path, fileName);
dlmwrite(fn, elements, 'precision', '%1.0f');
fileName = 'nodes.csv';
fn = strcat(path, fileName);
dlmwrite(fn, nodes, 'precision', '%i');

end


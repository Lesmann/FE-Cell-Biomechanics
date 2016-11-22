function [] = Write2csv( nodes, elements )

path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
fileName = 'elements.csv';
fn = strcat(path, fileName);
csvwrite(fn, elements);
fileName = 'nodes.csv';
fn = strcat(path, fileName);
csvwrite(fn, nodes);

end


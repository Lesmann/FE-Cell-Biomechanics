function [] = Write2csv( nodes, elements )

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'elements.csv';
fn = strcat(path, fileName);
dlmwrite(fn, elements, 'precision', '%1.0f');
fileName = 'nodes.csv';
fn = strcat(path, fileName);
fid = fopen(fn, 'wt');
for i = 1 : length(nodes)
    fprintf(fid, '%1.0f, %1.5f, %1.5f\n', nodes(i, :));
end
% csvwrite(fn, nodes);

end


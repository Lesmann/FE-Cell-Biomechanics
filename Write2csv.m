function [] = Write2csv( nodes, elements )

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
backup_path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Backup\';
fileName = 'elements.csv';
bu_fileName = strcat(fileName, '_',num2str(length(elements)), '_elements');
fn = strcat(path, fileName);
bufn = strcat(backup_path, bu_fileName);
dlmwrite(fn, elements, 'precision', '%1.0f');
dlmwrite(bufn, elements, 'precision', '%1.0f');
fileName = 'nodes.csv';
bu_fileName = strcat(fileName, '_',num2str(length(nodes)), '_nodes');
fn = strcat(path, fileName);
bufn = strcat(backup_path, bu_fileName);
fid = fopen(fn, 'wt');
bufid = fopen(bufn, 'wt');
for i = 1 : length(nodes)
    fprintf(fid, '%1.0f, %1.8f, %1.8f\n', nodes(i, :));
    fprintf(bufid, '%1.0f, %1.8f, %1.8f\n', nodes(i, :));
end
% csvwrite(fn, nodes);

end


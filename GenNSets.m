function Nsets = GenNSets ( nodes, fn )

% This function uses 'ic' (the nodes on the cell's edge) to generate 
% the inner-circle's node-sets string and writes it to separate text file.
l = length(nodes);
for i = 1 : l % going through all nodes on the cell's edge
    if i == 1;
        Nsets = strcat('*Nset, nset=ns', num2str(nodes(i)));
        Nsets = strcat(Nsets, ', instance=PART-1-1\n');
        Nsets = strcat(Nsets, num2str(nodes(i)));
        Nsets = strcat(Nsets, ',\n');
    else
        temp = strcat('*Nset, nset=ns', num2str(nodes(i)));
        temp = strcat(temp, ', instance=PART-1-1\n');
        temp = strcat(temp, num2str(nodes(i)));
        temp = strcat(temp, ',\n');
        Nsets = strcat(Nsets, temp);
    end    
end

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fn = strcat(path, fn);
fid = fopen(fn, 'wt');
fprintf(fid, Nsets);

end
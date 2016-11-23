function [ newNodes ] = GenNodes2d ( config )

% This function gets square dimensions 'sq' and meshing distance 'iSeed' to
% generate a node vector of a 2D square
% The list titled 'newNodes' contains two colums representing the (x,y) coordinates

k = 1;
for i = config.regParams.rect.length/2 : -config.regParams.iSeed : -config.regParams.rect.length/2 % Generate 1st dimension nodes
    for j = -config.regParams.rect.width/2 : config.regParams.iSeed : config.regParams.rect.width/2 % Generate 2nd dimension nodes
        
        newNodes(k, :) = [j, i];
        k = k + 1;
    
    end
end

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'symNodes.csv';
fn = strcat(path, fileName);
csvwrite(fn, newNodes);


end


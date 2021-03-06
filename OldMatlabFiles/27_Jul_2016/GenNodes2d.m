function [ newNodes ] = GenNodes2d ( config )

% This function gets square dimensions 'sq' and meshing distance 'iSeed' to
% generate a node vector of a 2D square
% The list titled 'newNodes' contains two colums representing the (x,y) coordinates

k = 1;
for i = config.regParams.sq/2 : -config.params.iSeed : -config.regParams.sq/2 % Generate 1st dimension nodes
    for j = -config.regParams.sq/2 : config.params.iSeed : config.regParams.sq/2 % Generate 2nd dimension nodes
        
        newNodes(k, :) = [j, i];
        k = k + 1;
    
    end
end
newNodes
path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
fileName = 'symNodes.csv';
fn = strcat(path, fileName);
csvwrite(fn, newNodes);


end


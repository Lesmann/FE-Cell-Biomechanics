function [ newNodes ] = GenNodes2d ( config )

% This function gets square dimensions 'sq' and meshing distance 'iSeed' to
% generate a node vector of a 2D square
% The list titled 'newNodes' contains two colums representing the (x,y) coordinates

[x, y] = meshgrid(config.regParams.sq/2 : -config.params.iSeed : -config.regParams.sq/2);
rex = reshape(x, [], 1);
rey = reshape(y, [], 1);

newNodes = horzcat(rex, rey);
scatter(newNodes(:, 1), newNodes(:, 2), '.');

% k = 1;
% for i = config.regParams.sq/2 : -config.params.iSeed : -config.regParams.sq/2 % Generate 1st dimension nodes
%     for j = -config.regParams.sq/2 : config.params.iSeed : config.regParams.sq/2 % Generate 2nd dimension nodes
%         
%         newNodes(k, :) = [j, i];
%         k = k + 1;
%     
%     end
% end

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'symNodes.csv';
fn = strcat(path, fileName);
A = AddIndx(newNodes);
% i_newNodes = sprintf('%1.0d, %1.4f, %1.4f\n', A(:, 1), A(:, 2), A(:, 3));
dlmwrite(fn, A, 'precision', '%i');
% dlmwrite(fn, i_newNodes, '');


end


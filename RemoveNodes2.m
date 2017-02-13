function [ newNodes, rNodes, RNodes ] = RemoveNodes2 ( N, config, idfo )

% This function removes nodes from vector 'nodes'
% that their distance is smaller than the inner radius 'r'
% from the coordinates of the points specified in 'pts'

k = 1;
c = 1;
l = length(N);
if isempty(config.cells{idfo})
   config.cells{idfo} = min(abs(N));
end
[ lpts, ~ ] = size(config.cells{idfo}); % practically the number of cells contained in the model
rNodes = 0;
for i = 1 : lpts % for each cell
    pt = config.cells{idfo}(i, :); % extracting the coordinates of the center of the current cell
    for j = 1 : l % for each cell, we go through all nodes we have in space 
        x = N(j, 1); % extract coordinates of the current node
        y = N(j, 2);
        d = sqrt((x-pt(1))^2+(y-pt(2))^2); % calculate the distance between the current node and the centre of the current cell
        if d < 1*config.params.r % if the node is contained withing the inner circle
            rNodes(k) = j; % save serial number of that node
            k = k + 1;
        else if (config.params.R - d) <= config.regParams.iSeed % if the node is outside the bigger circle
                RNodes(c) = j; % save serial number of that node
                c = c + 1;
            end
        end
    end
end

if strcmp(config.terms.Cells, 'yes') % applied only to model with cells (i.e. not bulk control experiment)
    N(rNodes, :) = [];
end

newNodes = N;

end


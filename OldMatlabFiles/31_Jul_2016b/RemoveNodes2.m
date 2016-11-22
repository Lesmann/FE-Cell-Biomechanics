function [ newNodes, rNodes, RNodes ] = RemoveNodes2( N, config )

% This function removes nodes from vector 'nodes'
% that their distance is smaller than the inner radius 'r'
% from the coordinates of the points specified in 'pts'

k = 1;
c = 1;
l = length(N);
[ lpts, wpts ] = size(config.cells); % 
rNodes = 0;
for i = 1 : lpts % for each cell
    pt = config.cells(i, :); % extracting the coordinates of the centre of the current cell
    for j = 1 : l % for each cell, we go through all nodes we have in space 
        x = N(j, 1); % exctracting the coordinates of the current node
        y = N(j, 2);
        d = sqrt((x-pt(1))^2+(y-pt(2))^2); % calculating the distance between the current node and the centre of the current cell
        if d < 1.3*config.params.r % if the node is contained withing the inner circle
            rNodes(k) = j; % saving the serial number of the node
            k = k + 1;
            
            %%% Until HERE
        else if (config.params.R - d) <= config.params.iSeed % if the node is outside the bigger circle
                RNodes(c) = j; % saving the serial number of the node
                c = c + 1;
            end
        end
    end
end

if ~config.terms.Cells
    nodes(rNodes, :) = [];
end

newNodes = nodes;


end


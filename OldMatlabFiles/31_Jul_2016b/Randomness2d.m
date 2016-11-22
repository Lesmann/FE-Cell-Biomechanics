function [ newNodes ] = Randomness2d ( nodes, config, ROR )

% This function gets a vector of coordinates 'Nodes' and Radius Of Randomness ('ROR')
% and returns a new vector 'newNodes' in which the coordinates are
% displaced within a circle of radius 'ROR'

nTotal = length(nodes); % total number of nodes
for i = 1 : nTotal % Go over all nodes
    x = nodes(i, 1); % Get current node coordinates
    y = nodes(i, 2);
    D = sqrt(x^2 + y^2); % Calculate the distance from origin   
    if D < config.params.R-config.params.iSeed && D > 2*config.params.r % Ignore nodes that exceed outer circle's range
        [ newx, newy ] = cirrdn(x, y, ROR); % Generate coordinates of new node inside the circle
        nodes(i, 1) = newx; % Initiate coordinates to nodes vector
        nodes(i, 2) = newy;
    end
end

newNodes = nodes;
% newNodes = AddIndx(newNodes);

end


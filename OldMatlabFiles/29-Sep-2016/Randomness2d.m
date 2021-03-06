function [ newNodes ] = Randomness2d ( nodes, config, ROR )

% This function gets a vector of coordinates 'Nodes' and Radius Of Randomness ('ROR')
% and returns a new vector 'newNodes' in which the coordinates are
% displaced within a circle of radius 'ROR'

nTotal = length(nodes); % total number of nodes
for i = 1 : nTotal % Go over all nodes
    x = nodes(i, 1); % Get current node coordinates
    y = nodes(i, 2);
    D = sqrt(x^2 + y^2); % Calculate the distance from origin (for a single cell case)
    % if not a single-cell-model, consider distance from current cell's center
    if ~isempty(config.cells)
        lcells = length(config.cells);
        for j = 1 : lcells
            xcell = config.cells(j, 1);
            ycell = config.cells(j, 2);
            currx = x - xcell;
            curry = y - ycell;
            d(j) = sqrt(currx^2+curry^2); % distances of the current node from all cell centres
        end
        if min(d) > config.params.r+2*config.params.iSeed && D < config.params.R-config.params.iSeed
            [ newx, newy ] = cirrdn(x, y, ROR); % Generate coordinates of new node inside the circle
            nodes(i, 1) = newx; % Initiate coordinates to nodes vector
            nodes(i, 2) = newy;
        end
    else
        if isempty(strfind(config.modelType, 'BCE'))
            % The following statements do not apply to nodes adjacent to the edges of the ECM and cell
            if D < config.params.R-config.params.iSeed && D > config.params.r+2*config.params.iSeed 
                [ newx, newy ] = cirrdn(x, y, ROR); % Generate coordinates of new node inside the circle
                nodes(i, 1) = newx; % Initiate coordinates to nodes vector
                nodes(i, 2) = newy;
            end
        else
            [ newx, newy ] = cirrdn(x, y, ROR); % Generate coordinates of new node inside the circle
            nodes(i, 1) = newx; % Initiate coordinates to nodes vector
            nodes(i, 2) = newy;
        end
    end
end

newNodes = nodes;
% newNodes = AddIndx(newNodes);

end


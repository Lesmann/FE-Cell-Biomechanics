function [circNodes, pts] = AdjustMCC(config, nodes, idfo)

% This function adjusts cell coordinates to ensure cell symmetry
% by finding the 2 adjacent nodes to each cell and
% re-locating the current cell to the center between these nodes.

if isempty(config.cells{idfo})
    pts = zeros(1, 2);
else
    lcells = length(config.cells{idfo});
    pts = zeros(lcells, 2);
    for i = 1 : lcells
        
        if ~isempty(config.cells{idfo})
            x = config.cells{idfo}(i, 1); y = config.cells{idfo}(i, 2);
        else
            x = 0; y = 0;
        end
        
        for j = 1 : length(nodes)
            
            cnode = nodes(j, :);
            xn(j) = cnode(1); yn(j) = cnode(2);
            dx(j) = abs(x-xn(j)); dy(j) = abs(y-yn(j));
            
        end
        
        [~, x_idx] = min(dx); [~, y_idx] = min(dy);
        pts(i, 1) = xn(x_idx) + 0.5*config.regParams.iSeed;
        pts(i, 2) = yn(y_idx) + 0.5*config.regParams.iSeed;
        
    end
end

circNodes = const2circular(pts, config);

end


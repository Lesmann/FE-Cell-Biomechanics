function pts = AdjustMCC(config, nodes)

% This function adjusts cell coordinates to ensure cell symmetry
% by finding the 4 adjuscet nodes to the current cell (in x and y) and
% re-locates the current cell to the center of these nodes.
lcells = length(config.cells);
pts = zeros(lcells, 2);

for i = 1 : lcells
    
    x = config.cells(i, 1); y = config.cells(i, 2);
    
    for j = 1 : length(nodes)
        
        cnode = nodes(j, :);
        xn(j) = cnode(1); yn(j) = cnode(2);
        dx(j) = abs(x-xn(j)); dy(j) = abs(y-yn(j));
        
    end
    
    [~, x_idx] = min(dx); [~, y_idx] = min(dy);
    pts(i, 1) = xn(x_idx) + 0.5*config.params.iSeed;
    pts(i, 2) = yn(y_idx) + 0.5*config.params.iSeed;
    
end

end


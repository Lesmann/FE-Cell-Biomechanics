function El = GenEl2d_v2 ( Nodes, config, d )

% This function generates an element vector 'El'
% according to desired distance 'd' between nodes in vector 'Nodes' (which is 1 or sqrt(2)).

d = config.params.iSeed*d;
k = 1;
% N = Nodes(:, 2:3);
l = length(Nodes);
for i = 1 : l
    N1 = Nodes(i, :); % Define 1st node bordering the element
    for j = i+1 : l % Go over all other nodes
        N2 = Nodes(j, :); % Define 2nd node bordering the element
        x1 = N1(1); y1 = N1(2); % Get coordinates of 1st node
        x2 = N2(1); y2 = N2(2); % Get coordinates of 2nd node
        D = sqrt((x2-x1)^2+(y2-y1)^2); % Calculate the distance between nodes
        inc = abs(D-d);
        if inc < 1e-7 % If distance equals to the meshing interval
            El(k, :) = [j, i]; % Generate element by specifying the serial numbers of the two nodes
            k = k + 1;
        end
    end 
end

end
function El = GenEl2d_v2 ( nodes, config, matrix, d )

% This function generates an element vector 'El'
% according to desired distance 'd' between nodes in vector 'Nodes' (which is 1 or sqrt(2)).

d = config.params.iSeed*d;
k = 1;
l = length(nodes);

for i = 1 : l
    N1 = nodes(i, :); % Define 1st node bordering the element
    tic
    for j = i+1 : l % Go over all other nodes
        N2 = nodes(j, :); % Define 2nd node bordering the element
        if abs(pdist2(N1, N2, 'euclidean')-d)<1e-7 % If distance equals to 'd'
            El(k, :) = [j, i]; % Generate element by specifying the serial numbers of the two nodes
            k = k + 1;
        end
    end
    t = toc;
end
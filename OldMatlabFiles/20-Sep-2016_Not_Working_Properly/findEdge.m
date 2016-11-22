function edges = findEdge(Elements, Nodes, config)

% this function is a BCE model-type dedicated function.
% this function find all nodes found on the edge of the BCE model.
% the function does this by counting the number of elements connected to
% each node. node with less than 8 connected elements are edge-nodes.

% next, this function distinguishes between upper, lower, right and left
% edge nodes. this is done by identifying each node coordinates sign.

% this function returns a struct 'edges' with 4 fields: upper, lower, right
% and left.

% This function finds and returns a vector containing the serial numbers of the nodes forming the cell boundaries

k = 1;
El = Elements(:, 2:3); % a list of all elements as defined by their nodes
N = Nodes(:, 2:3); % a list of node coordinates
inCirc = 0;
iSeed = config.params.iSeed;

for i = 1 : length(N) % going through all nodes
    
    e = El==i; % creating a matrix in which i is 1 and the rest is all 0-s
    n = sum(sum(e)); % counting how many times a certain node appears in the elements list, i.e. to how many elements it is connected
    currN = N(i, :); % extracting the coordinates of the current node
    x = currN(1); y = currN(2);
    d = sqrt(x^2 + y^2); % distance of the current node from the origin
    
    if (n < 8) 
        edge_nodes(k) = i; % this node is on the matrix's edge, and its serial number is noted
        k = k + 1;
    end
    
end

for i = 1 : length(edge_nodes)

currNode = N(edge_nodes(i), :);
x = currNode(1); y = currNode(2);

    if y > 0 && x < config.R && x > -config.R
        top(i) = edge_nodes(i);
    end
    
    if y < 0 && x < config.R && x > -config.R
       buttom(i) = edge_nodes(i);
    end
    
    if x == config.R
        right(i) = edge_nodes(i);
    end
    
    if x == -config.R
        left(i) = edge_nodes(i);
    end
    
end

edges = struct('top', top, 'buttom', buttom,...
    'right', right, 'left', left);



function [ newNodes ] = remSqReg ( Nodes, config )

% This function removes the square region elements surrounding the large circle and also
% removes side-effect elements  with connectivity values lower than or equal to 1.

k=1;

for i = 1 : length(Nodes)
    currNode = Nodes(i, :);
    x = currNode(1);
    y = currNode(2);
    d = sqrt(x^2+y^2);
    inc = config.params.R-d; % if the node is outside the bigger circle
    if inc <= 1e-7
        indx(k) = i; % save serial number of the node
        k=k+1;
    end   
end

Nodes(indx, :) = [];
newNodes = Nodes;

end


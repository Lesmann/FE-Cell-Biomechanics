function [ newNodes ] = remSqReg ( Nodes, config )

% this function removes the square region elements surrounding the large circle and also
% removes side-effect elements  with connectivity values lower than or equal to 1.

k=1;

for i = 1 : length(Nodes)
    currNode = Nodes(i, :);
    x = currNode(1);
    y = currNode(2);
    d = sqrt(x^2+y^2);
    inc1 = config.params.R-d; % if the node is outsife the bigger circle
    if inc1 <= 1e-4
        indx(k) = i; % saving the serial number of the node
        k=k+1;
    end   
end

Nodes(indx, :) = [];
newNodes = Nodes;

end


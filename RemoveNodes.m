function [ newNodes, rNodes, RNodes ] = RemoveNodes ( N, config )

% This function removes the nodes from vector 'nodes'
% that are in smaller than the inner radius 'r'
k = 1;
c = 1;
l = length(N);
rNodes = 0;
for i = 1 : l
    
    x = N(i, 1);
    y = N(i, 2);
    d = sqrt(x^2+y^2);
    if d < 1.3*config.params.r % if the node is contained withing the inner circle
        rNodes(k) = i; % saving the serial number of the node
        k = k + 1;
        else if (config.params.R - d) <= config.params.iSeed % if the node is outside the bigger circle
                RNodes(c) = i; % saving the serial number of the node
                c = c + 1;
            end
    end

end

if strcmp(config.terms.Cells, 'yes') % applied only to model with cells (i.e. not bulk control experiment)
    N(rNodes, :) = [];
end

newNodes = N;

end


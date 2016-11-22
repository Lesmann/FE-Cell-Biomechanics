function [ Urad ] = rad_proj( nodes, U )

% this function calculates and returns
% the radial tranformation of the displacements vector 'U'
% with respect to the original node loactions found 'nodes'

% the operation is as follows:
% 1. get the original current node location.
% 2. calculate the unit-radial-vector (URV) of this node:
% r_unit = (-x, -y)/sqrt(x^2+y^2)
% 3. dot-product URV with U of the current node:
% Urad = U*r_unit

for i = 1 : length(U)
    
    currNode = nodes(i, :);
    nx = currNode(1); ny = currNode(2);
    r = [-nx, -ny];
    mag_r = sqrt(nx^2+ny^2);
    r_unit = r./mag_r;
    Urad(i) = dot(U(:, i)', r_unit);
    
end

end


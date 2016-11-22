function [ RadUr ] = GetRadUr( Ur, Ux, Uy, Nodes )

% this function gets:
% a list of nodes and displacement field data (Ur, Ur1, Ur2):
% Nodes = list of nodes from the model inp file.
% Ur = displacement magnitude
% Ux = displacement in x direction
% Uy = displacement in y direction

% and returns:
% RadUr = the radial projection of the displacement magnitude (Ur)

l = length(Ur);

for i = 1 : l
    
    currn = Nodes(i, :); % get current node
    x = currn(1); y = currn(2); % original node location
    radd = sqrt(x^2+y^2); % calc radial distance
    xu = x+Ux(i); yu = y+Uy(i); % post-sim node location
    
    orAng = atan(y/x); % original radial node direction (with respect to vertical)
    psAng = atan(yu/xu); % post-sim radial node direction (with respect to vertical)
    projAng = orAng-psAng; % calc projection angle
    
    RadUr(i) = Ur(i)*cos(projAng); % calc radial projection

end


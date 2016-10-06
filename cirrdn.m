function [x, y] = cirrdn(x1,y1,rc)

% This function generates a random vector of coordinates within a circle
% given the center (rc) and the radius of that circle (x1,y1)

diameter=2*pi*rand;
r=sqrt(rand);
x=(rc*r)*cos(diameter)+x1;
y=(rc*r)*sin(diameter)+y1;

end


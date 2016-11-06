function [x, y] = cirrdn(x1,y1,rc)

% This function generates a random vector of coordinates within a circle
% given the center (rc) and the radius of that circle (x1,y1)

circ=2*pi*rand; % circumference of randomness circle
r=sqrt(rand); % radius of randomness circle 
x=(rc*r)*cos(circ)+x1; % x component of randomness circle
y=(rc*r)*sin(circ)+y1; % y component of randomness circle

end


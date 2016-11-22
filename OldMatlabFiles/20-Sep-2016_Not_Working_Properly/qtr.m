function cqtr = qtr(ang1, ang2)

% This function determines the location (quarters) of the 
% required cut

qtr0 = [0, 0];
qtr1 = [1, 1];
qtr2 = [-1, 1];
qtr3 = [-1, -1];
qtr4 = [1, -1];

if ang1 >= 0 && ang1 <= pi/2 && ang2 >= 0 && ang2 <= pi/2
    cqtr = [qtr1; qtr0; qtr0; qtr0];
end

if ang1 >= 0 && ang1 <= pi/2 && ang2 >= pi/2 && ang2 <= pi
    cqtr = [qtr1; qtr2; qtr0; qtr0];
end

if ang1 >= 0 && ang1 <= pi/2 && ang2 >= pi && ang2 <= 3*pi/2
    cqtr = [qtr1; qtr2; qtr3; qtr0];
end

if ang1 >= 0 && ang1 <= pi/2 && ang2 >= 3*pi/2 && ang2 <= 2*pi
    cqtr = [qtr1; qtr2; qtr3; qtr4];
end

if ang1 >= pi/2 && ang1 <= pi && ang2 >= pi/2 && ang2 <= pi
    cqtr = [qtr0; qtr2; qtr0; qtr0];
end

if ang1 >= pi/2 && ang1 <= pi && ang2 >= pi && ang2 <= 3*pi/2
    cqtr = [qtr0; qtr2; qtr3; qtr0];
end

if ang1 >= pi/2 && ang1 <= pi && ang2 >= 3*pi/2 && ang2 <= 2*pi
    cqtr = [qtr0; qtr2; qtr3; qtr4];
end

if ang1 >= pi && ang1 <= 3*pi/2 && ang2 >= pi && ang2 <= 3*pi/2
    cqtr = [qtr0; qtr0; qtr3; qtr0];
end

if ang1 >= pi && ang1 <= 3*pi/2 && ang2 >= 3*pi/2 && ang2 <= 2*pi
    cqtr = [qtr0; qtr0; qtr3; qtr4];
end

if ang1 >= 3*pi/2 && ang1 <= 2*pi && ang2 >= 3*pi/2 && ang2 <= 2*pi
    cqtr = [qtr0; qtr0; qtr0; qtr4];
end

if ang1 >= 3*pi/2 && ang1 <= 2*pi && ang2 >= 0 && ang2 <= pi/2
    cqtr = [qtr1; qtr0; qtr0; qtr4];
end

end


function el = GenEl2d_v3( nodes )

% this function is dedicated to Yossi Tokash, the greatest brother at all
% times... (see dedicated comments)

% this function is an optimized (time and memory consumption) version of 'GenEl2d_v2' function
% this function generates elements for box-x configuration models.
% this function operates by cunstructing numerical sub-arrays of the node array
% and pairing them with respect to their position within the matrix.

numat = 1 : length(nodes);
n = sqrt(length(nodes));
numat = reshape(numat, n, n);
numat = numat';

% Constructing siege equipment
top = numat(1:end-1, :);
buttom = numat(2:end, :);
right = numat(:, 2:end);
left = numat(:, 1:end-1);
top_left = numat(1:end-1, 1:end-1);
top_right = numat(1:end-1, 2:end);
buttom_right = numat(2:end, 2:end);
buttom_left = numat(2:end, 1:end-1);

row_top = reshape(top, [], 1);
row_buttom = reshape(buttom, [], 1);
row_right =  reshape(right, [], 1);
row_left =  reshape(left, [], 1);
row_top_right = reshape(top_right, [], 1);
row_top_left = reshape(top_left, [], 1);
row_buttom_right = reshape(buttom_right, [], 1);
row_buttom_left = reshape(buttom_left, [], 1);

vel = horzcat(row_top, row_buttom);
hel = horzcat(row_right, row_left);

oel_rl = horzcat(row_top_right, row_buttom_left);
oel_lr = horzcat(row_top_left, row_buttom_right);

el = vel;
el = vertcat(el, hel);
el = vertcat(el, oel_rl);
el = vertcat(el, oel_lr);

end


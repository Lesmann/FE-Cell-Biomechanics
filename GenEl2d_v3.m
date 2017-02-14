function el = GenEl2d_v3( nodes, config )

% this function is dedicated to Yossi Tokash, the greatest brother at all
% times... (see dedicated comments)

% this function is an optimized (time and memory consumption) version of the 'GenEl2d_v2' function
% this function generates elements for box-x configuration models.
% this function operates by constructing numerical sub-arrays of the node array
% and pairing them with respect to their position within the matrix.

%% create numerical (serial) matrix
numat = 1 : length(nodes); % create serial vector
l = config.regParams.rect.length; % get length
w = config.regParams.rect.width; % get width
seed = config.regParams.iSeed; % get element length
nl = round(l/seed+1); % calculate number of node in length
nw = round(w/seed+1); % calculate number of node in width 
numat = reshape(numat, nw, nl); % reshape serial vector into numerical matrix
numat = numat'; % rotate matrix

%% disassemble matrix into sub-marices 

top = numat(1:end-1, :); % get top sub-matrix
bottom = numat(2:end, :); % get bottom sub-matrix
right = numat(:, 2:end); % get right sub-matrix
left = numat(:, 1:end-1); % get left sub-matrix
top_left = numat(1:end-1, 1:end-1); % get top-left sub-matrix
top_right = numat(1:end-1, 2:end); % get top-right sub-matrix
bottom_left = numat(2:end, 1:end-1); % get bottom-left sub-matrix
bottom_right = numat(2:end, 2:end); % get bottom-right sub-matrix

% reshape matrices into vectors
row_top = reshape(top, [], 1);  
row_bottom = reshape(bottom, [], 1);
row_right =  reshape(right, [], 1);
row_left =  reshape(left, [], 1);
row_top_right = reshape(top_right, [], 1);
row_top_left = reshape(top_left, [], 1);
row_bottom_right = reshape(bottom_right, [], 1);
row_bottom_left = reshape(bottom_left, [], 1);

% create vertical and horizontal elements by assigning node numbers
vel = horzcat(row_top, row_bottom);
hel = horzcat(row_right, row_left);

oel_rl = horzcat(row_top_right, row_bottom_left);
oel_lr = horzcat(row_top_left, row_bottom_right);

el = vel;
el = vertcat(el, hel);
el = vertcat(el, oel_rl);
el = vertcat(el, oel_lr);

end


function [El, osqEl] = getosq ( Nodes, El, config )

% Get outside-square-region elements
% This function gets the elements located outside of the circle region and
% inside the square region

k=1;
El.Norm = reshape(El.Norm' ,1,numel(El.Norm)); % convert normal-elements matrix into vector

for i = 1 : length(El.Norm)
    
    indEl = El.Norm(i);
    
    % apply try&catch to detect&ignore the last zero-padded values
    try
        currEl = El.new(indEl, :);
    catch ME
        errind = i;
    end
        
    nn1 = currEl(2); nn2 = currEl(3); % extracting the serial numbers of nodes defining the element
    node1 = Nodes(nn1, :); node2 = Nodes(nn2, :); % extracting the coordinates of these nodes
    x1 = node1(2); y1 = node1(3);
    x2 = node2(2); y2 = node2(3);
    d1 = sqrt(x1^2+y1^2); % distances of both nodes from the origin
    d2 = sqrt(x2^2+y2^2);
    
    if d1 > config.params.R && d2 > config.params.R % if both nodes are outside the circle
        osqEl(k) = indEl; % this element will be noted
        k=k+1;
    end
    
end

% Write into .csv file
l = length(osqEl);
lf = l/16; % only 16 elements can be listed in each line in the inp file
xtra = (lf-floor(lf))*16;
lastRow = zeros(1, 16);
lf = floor(lf);
lastRow(1 : xtra) = osqEl(l - xtra + 1 : l)';
osqEl = osqEl((1 : 16*lf));
osqEl = reshape(osqEl, [], 16);
osqEl = vertcat(osqEl, lastRow);
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'OuterSqElements.csv';
fn = strcat(path, fileName);
csvwrite(fn, osqEl);

% Re-define weak and normal element vectors
El.Weak = vertcat(El.Weak, osqEl); % All elements contained outside the circle are listed together with the weak elements
El.Weak(El.Weak==0) = []; % The values created during zero-padding are being removed
Elind = El.new(:, 1); % reloading all elements as defined by their serial numbers
Elind(El.Weak) = []; % removing the weak elements from the list of all elements
El.Norm = Elind; % the elements remain after removing the weak ones are the "normal" or "strong" ones

% Rewriting weak and normal element vectors into .csv files

l = length(El.Weak);
lf = l/16;
xtra = (lf-floor(lf))*16;
lastRow = zeros(1, 16);
lf = floor(lf);
lastRow(1 : xtra) = El.Weak(l - xtra + 1 : l)';
El.Weak = El.Weak((1 : 16*lf));
El.Weak = reshape(El.Weak, [], 16);
El.Weak = vertcat(El.Weak, lastRow);
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'WeakElements.csv';
fn = strcat(path, fileName);
dlmwrite(fn, El.Weak, 'precision', '%1.0f');

l = length(El.Norm);
lf = l/16;
xtra = (lf-floor(lf))*16;
lastRow = zeros(1, 16);
lf = floor(lf);
lastRow(1 : xtra) = El.Norm(l - xtra + 1 : l)';
El.Norm = El.Norm((1 : 16*lf));
El.Norm = reshape(El.Norm, [], 16);
El.Norm = vertcat(El.Norm, lastRow);
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'NormalElements.csv';
fn = strcat(path, fileName);
dlmwrite(fn, El.Norm, 'precision', '%1.0f');

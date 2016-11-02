function [ inCirc ] = Nicirc2 ( Elements, Nodes, config )

% This function finds and returns a vector containing the serial numbers of
% the nodes forming the cell boundaries (column 2) and the cell they are
% bordering (column 1)

k = 1;
El = Elements(:, 2:3); % a list of all elements as defined by their nodes
N = Nodes(:, 2:3); % a list of node coordinates
inCirc = [];
r = config.params.r;
cellCoordinates = config.cells;
iSeed = config.regParams.iSeed;

for j = 1 : length(cellCoordinates) % going through all cells
    for i = 1 : length(N) % going through all nodes
        
        e = El==i; % creating a matrix in which i is 1 and the rest is all 0-s
        n = sum(sum(e)); % counting how many times a certain node appears in the elements list, i.e. to how many elements it is connected
        currN = N(i, :); % extracting the coordinates of the current node
        x = currN(1); y = currN(2);
        currC = cellCoordinates(j, :); % extracting the coordinates of the centre of the current cell
        xC = currC(1); yC = currC(2);
        d = sqrt((x-xC)^2 + (y-yC)^2); % distance between the current node and the centre of the current cell
        if (n >= 5 && n < 7) && d < r+3*iSeed % if the current node is connected to 5 or 6 elements, and it is quite near the cell centre
            inCirc(k, :) = [j, i]; % this node is on the cell's edge (column 2), and its serial number is noted together with the cell's serial number (column 2)
            k = k + 1;
        end
        
    end
end

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'InnerNodes.csv';
fn = strcat(path, fileName);
dlmwrite(fn, inCirc, 'precision', '%1.0f');
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'OneSidedElements.csv';
fn = strcat(path, fileName);
dlmwrite(fn, inCirc, 'precision', '%1.0f');

end


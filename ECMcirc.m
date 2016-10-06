function [ ECMCirc ] = ECMcirc ( Elements, Nodes, R )

% This function finds and returns a vector containing the serial numbers of the nodes forming the cell boundaries

k = 1;
El = Elements(:, 2:3); % a list of all elements as defined by their nodes
N = Nodes(:, 2:3); % a list of node coordinates
ECMCirc = 0;
iSeed = 0.005;

for i = 1 : length(N) % going through all nodes
    
    e = El==i; % creating a matrix in which i is 1 and the rest is all 0-s
    n = sum(sum(e)); % counting how many times a certain node appears in the elements list, i.e. to how many elements it is connected
    currN = N(i, :); % extracting the coordinates of the current node
    x = currN(1); y = currN(2);
    d = sqrt(x^2 + y^2); % distance of the current node from the origin
    
    if (n>3 && n<7) && d > R-3*iSeed % if the current node is connected to 5 or 6 elements, and it is quite near the origin  
        ECMCirc(k) = i; % this node is on the cell's edge, and its serial number is noted
        k = k + 1;
    end
    
end

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'OuterNodes.csv';
fn = strcat(path, fileName);
csvwrite(fn, ECMCirc);
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
fileName = 'OuterOneSidedElements.csv';
fn = strcat(path, fileName);
csvwrite(fn, ECMCirc);

end


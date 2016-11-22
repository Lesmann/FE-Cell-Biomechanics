function [ inCirc ] = Nicirc ( Elements, Nodes, r )

% This function finds and returns the inner circle's nodes vector 'inCirc'.

k = 1;
El = Elements(:, 2:3); % a list of all elements as defined by their nodes
N = Nodes(:, 2:3); % a list of node coordinates
inCirc = 0;
iSeed = 0.006;

for i = 1 : length(N)
    
    e = El==i; % creating a matrix in which i is 1 and the rest is all 0-s
    n = sum(sum(e)); % counting how many times a certain node appears in the elements list, i.e. to how many elements it is connected
    currN = N(i, :); % extracting the coordinates of the current node
    x = currN(1); y = currN(2);
    d = sqrt(x^2 + y^2); % distance of the current node from the origin
    
    if (n >= 5 && n < 7) && d < r+3*iSeed % if the current node is connected to 5 or 6 elements, and it is quite near the origin  
        inCirc(k) = i; % this node is on the cell's edge, and its serial number is noted
        k = k + 1;
    end
    
end

path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
fileName = 'InnerNodes.csv';
fn = strcat(path, fileName);
csvwrite(fn, inCirc);
path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
fileName = 'OneSidedElements.csv';
fn = strcat(path, fileName);
csvwrite(fn, inCirc);

end


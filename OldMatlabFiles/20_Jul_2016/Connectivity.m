function [ El ] = Connectivity ( El, Nodes, ConnRange, loc, config )

% Reduce connectivity by eliminating elements by random
% Number of eliminated elements is defined by the level of connectivity (LOC)
% LOC is a chosen percentage of elements

R = ConnRange(1);
r = ConnRange(2);
cEl = [];
l = length(El);
serial = 1 : l;
El = El(:, 2:3); % Get elements according to the nodes defining them
El = horzcat(serial', El);
% Range = Range - 2*iSeed;
k = 1;
c = 1;

for i = 1 : l % Going through all elements
    currEl = El(i, 2:3); % Get current elements
    nnode1 = currEl(1); nnode2 = currEl(2); % extracting the element nodes
    node1 = Nodes(nnode1, 2:3); % Get current element's 1st node's coordinates
    x1 = node1(1); y1 = node1(2); r1 = sqrt(x1^2 + y1^2); % Calculate distance of 1st node from origin
    node2 = Nodes(nnode2, 2:3); % Get current element's 2nd node's coordinates
    x2 = node2(1); y2 = node2(2); r2 = sqrt(x2^2 + y2^2); % Calculate distance of 2nd node from origin
    % Apply connectiveness only on elements within the range of the outer circle
    % (Otherwise the square will become amorphous)
    if (r1 < config.params.R-2*config.params.iSeed || r2 < config.params.R-2*config.params.iSeed) % practically all elements excluding those within the outmost iSeed-thick ring
       cEl(k, :) = El(i, 1); % Noting the serial number of element for which the above condition applies
       k = k + 1;
    end
    % get extra weak elements (near the cell)
    % if (r1 > r && r2 > r)
    % exwEl(c, :) = El(i, 1);
    % c=c+1;
    % end
end

if isempty(cEl)
    cEl = El;
    lc = length(El);
else
    lc = length(cEl); % counting the elements for which we would like to apply the connectivity algorithm
end

% Level of connectivity - define how many elements will be "eliminated"
% (defined as weak = Young's modulus is smaller by 6 orders of magnitude)

% For Example: LOC is defined as 0.625 - meaning that 62.5% of the elements
% within the circled region will be "weak elements"
% Full Connectivity is obtained when LOC=1 -> fullconnectivity=8
% According to Notbohm et al -> Connectivity = 3 ->
% -> connectivity = 8*(1-0.625) = 3

LOC = round(lc*loc); % The product of the number of elements and desired level of connectivity (percentage from 8) - which would give the new total number of weak/strong(???) elements

conEl = randperm(lc, LOC); % Generating a random vector of elements to eliminate

WeakEl = cEl(conEl, :); % Save elements to give them a weak definition
RedCon = cEl(conEl); % Vector of elements to Eliminate (Reduced Connectivity)
l = length(WeakEl);
lf = l/16;
xtra = (lf-floor(lf))*16;
lastRow = zeros(1, 16);
lf = floor(lf);
lastRow(1 : xtra) = WeakEl(l - xtra + 1 : l)';
WeakEl = WeakEl((1 : 16*lf));
WeakEl = reshape(WeakEl, [], 16);
WeakEl = vertcat(WeakEl, lastRow);
path = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\';
fileName = 'WeakElements.csv';
fn = strcat(path, fileName);
csvwrite(fn, WeakEl);

NormEl = El;
RedCon = sort(RedCon);
NormEl(RedCon, :) = []; % Eliminate Elements from vector
l = length(NormEl);
lf = l/16;
xtra = (lf-floor(lf))*16;
lastRow = zeros(1, 16);
lf = floor(lf);
lastRow(1 : xtra) = NormEl(l - xtra + 1 : l)';
NormEl = NormEl((1 : 16*lf));
NormEl = reshape(NormEl, [], 16);
NormEl = vertcat(NormEl, lastRow);
path = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\';
fileName = 'NormalElements.csv';
fn = strcat(path, fileName);
csvwrite(fn, NormEl);
newEl = El;

El = struct('Weak', WeakEl, 'Norm', NormEl, 'new', newEl);

end


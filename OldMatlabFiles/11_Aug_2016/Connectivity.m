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
end
lc = length(cEl); % counting the elements to which we would like to apply the connectivity algorithm


% Level of connectivity - define how many elements will remain and how many
% will be "eliminated", i.e. defined as weak (Young's modulus is smaller by 6 orders of magnitude)

% For Example: LOC is defined as 0.625 - meaning that 62.5% of the elements
% within the circled region will remain as "strong elements"
% Full Connectivity is obtained when LOC=1 -> fullconnectivity=8

NumOfWeakEl=round(lc*(1-loc)); % The product of the number of elements and the complement-to-1 of the desired level of connectivity (percentage from 8) - which would give the number of "weak" elements

conEl = randperm(lc, NumOfWeakEl); % Generating a random vector of elements to leave as strong elements

WeakEl = cEl(conEl, :); % Noting serial numbers of elements to assign them with a weak definition
l = length(WeakEl);
lf = l/16; % In the inp file, 16 elements are listed in each line, excluding the last one
xtra = (lf-floor(lf))*16; % the number of elements listed in the last line
lastRow = zeros(1, 16); % zero padding
lf = floor(lf);
lastRow(1 : xtra) = WeakEl(l - xtra + 1 : l)';
WeakEl = WeakEl((1 : 16*lf));
WeakEl = reshape(WeakEl, [], 16);
WeakEl = vertcat(WeakEl, lastRow);
path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
fileName = 'WeakElements.csv';
fn = strcat(path, fileName);
csvwrite(fn, WeakEl);

NormEl = El; % Loading all elements again
RedCon = cEl(conEl); % Vector of elements to eliminate later
RedCon = sort(RedCon);
NormEl(RedCon, :) = []; % Eliminating elements from the vector listing the strong elements
l = length(NormEl);
lf = l/16; % see above
xtra = (lf-floor(lf))*16;
lastRow = zeros(1, 16); % zero padding
lf = floor(lf);
lastRow(1 : xtra) = NormEl(l - xtra + 1 : l)';
NormEl = NormEl((1 : 16*lf));
NormEl = reshape(NormEl, [], 16);
NormEl = vertcat(NormEl, lastRow);
path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
fileName = 'NormalElements.csv';
fn = strcat(path, fileName);
csvwrite(fn, NormEl);
newEl = El; % all elements

El = struct('Weak', WeakEl, 'Norm', NormEl, 'new', newEl);

end


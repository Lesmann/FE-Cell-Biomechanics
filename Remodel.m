function [ newNodes ] = Remodel( field, frame )

% This function gets the previous model and its results and remodels
% it according to a chosen field-output (FO) (e.g. displacement, stress, reaction force or strain fields).

% A. Read Fields from last frame.
    
% 1. Assemble path according to frame number
frame_str = double2str(frame);

gpath = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\DCR\';
file = strcat('data', frame_str);
fpath = strcat(gpath, file);

[~, Fields] = rd(fpath);
FV = Fields.(field);

% A. Read last configuration.
config = load(cpath);
iSeed = config.regparams.iSeed;

% B. Read last nodes and elements.
nodes = csvread(npath);
elements = csvread(epath);
lnodes = length(nodes);


% D. For each node:

for i = 1 : lnodes
    
    nparent = nodes(i);
    
    % 1. Find children
    nchildren = findChildren(nparent, elements);
    
    % 2. Draw field-value (FV) in x and y for node.
    vparent = FV(i);
    
    % 3. Draw field-value (FV) in x and y for neighbores.
    vchildren = FV(nchildren);
    
    % 4. Calculate gradient slope in x and y (Sx and Sy) for parent-value (parent) and
    %    children-values (children).
    [Sx, Sy] = findSlopes(vparent, vchildren);
    
    % 5. Calculate mean-field-slope in x and y (MFSx and MFSy).
    MFSx = mean(Sx);
    MFSy = mean(Sy);
    
    % 6. Calculate Movement in x and y according to:
    Movex = MFSx*iSeed/10;
    Movey = MFSy*iSeed/10;
    
    % 7. Move node in x and y
    newNodesx(i) = iNodex+Movex;
    newNodesy(i) = iNodey+Movey;

end

newNodes = vertcat(newNodesx, newNodesy);

% E. Write nodes#.csv specifying frame number.
csvPath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\DCR\';
csvfile = strcat('nodes', frame_str);
csvPath = strcat(csvPath, csvfile);
csvwrite(csvPath, newNodes);

end


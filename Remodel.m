function [ frame newNodes ] = Remodel( field, frame, config )

% This function gets the previous model and its results and remodels
% it according to a chosen field-output (FO) (e.g. displacement, stress, reaction force or strain fields).
% This function creates a new inp file along with all relevant data and
% configuration information.

% 1. Assemble path according to frame number

%% A. Read data from last frame

frame = frame + 1; % promote frame
iSeed = config.regParams.iSeed;
frame_str = num2str(frame);

gpath = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\DCR\DCR_Field_Outputs\';
currfile = strrep(config.fn, '.inp', '.csv');
fpath = strcat(gpath, currfile);

% read fields from Abaqus csv file
Fields = read_fields(fpath); 
FV = Fields.(field);

% Read last nodes and elements.
last_nodes_file = ['nodes#', curr_file, '.csv'];
last_elements_file = ['elements#', curr_file, '.csv'];

npath = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\DCR\DCR_nodes\';
epath = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\DCR\DCR_elements\';

npath = [npath, last_nodes_file];
epath = [epath, last_elements_file];

nodes = csvread(npath);
elements = csvread(epath);

lnodes = length(nodes);

%% C. Compute remodel coordinates

% For each node:

for i = 1 : lnodes
    
    nparent = nodes(i);
    
    % 1. Find children
    nchildren = findChildren(nparent, elements);
    
    % 2. Draw field-value (FV) in x and y for node.
    vparent = FV(i);
    
    % 3. Draw field-value (FV) in x and y for children.
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

%% D. Store new data in DCR data-base

% Write nodes#.csv specifying frame number.
csvfile = ['nodes#', frame_str, '.csv'];
csvPath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\DCR\DCR_nodes\';
csvPath = [csvPath, csvfile];

fid = fopen(csvPath, 'wt');
for i = 1 : length(nodes)
    fprintf(fid, '%1.0f, %1.8f, %1.8f\n', nodes(i, :));
end

% Write elements#.csv specifying frame number (currently all similar - done for further possible use).
csvfile = ['elements#', frame_str, '.csv'];
csvPath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\DCR\DCR_elements\';
csvPath = [csvPath, csvfile];
dlmwrite(csvPath, elements, 'precision', '%1.0f');

%% E. Re-model and Redefine

% Write remodeled nodes into inp file

inpPath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\DCR\DCR_inp\';
fn = strcat(inpPath, lastfile); % set path to read last frame's inp file
inp = fileread(fn); % read last frame's inp file
fn = [inpPath, currfile]; % set path to write to current inp file
Splt_n_Push(fn, inp, newNodes, '*Node', '*Element'); % write to current inp file
RemBlnkLines(fn); % remove blank rows from current inp file and close the file

% Re-define BCs (under construction)
% re-calculate the new cell's center of mass (COM) coordinates.
% define cell constriction COM
% store COMs (in DCR config path)

end


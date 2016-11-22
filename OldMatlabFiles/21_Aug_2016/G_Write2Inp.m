function [] = G_Write2Inp ( input, config )

format long g
i_nset = 1;
%% Generalized Write to inp file
% Writes to a name specified inp file 'fn'

% Write nodes and elements to .csv files
% nodesStr = num2str(nodes);
% ElStr = num2str(elements);

% path = 'C:\Users\Naama\Desktop\Research-TAU\MatlabFiles\';

%% Write nodes and elements into .csv files

Write2csv( input.nodes, input.elements )

%% push data into abaqus input script file (.inp)

% Define 'name.inp' as the written file
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\2cells4poster_20-09\';
fn = strcat(path, input.FN);
inp = fileread(fn);

%% insert nodes and elements into inp file

% insert nodes into inp file

% Prepare Nodes vector for insertion
csvPath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
csvfile = 'nodes.csv';
csvfn = strcat(csvPath, csvfile);
fNodes = nodes2str(csvfn);
Splt_n_Push(fn, inp, fNodes, '*Node', '*Element');
RemBlnkLines(fn);

% Insert elements into inp file

% Prepare Elements vector for insertion
% fEl = el2str(elements);
csvPath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
csvfile = 'elements.csv';
csvfn = strcat(csvPath, csvfile);
fEl = nodes2str(csvfn);
% Read the .inp again after each insertion - Important!!
inp = fileread(fn);
Splt_n_Push(fn, inp, fEl, '*Element , type=T2D2', '*Elset, elset=Normal Elements');
RemBlnkLines(fn);

%% Insert material properties into inp file

inp = fileread(fn);
Splt_n_Push(fn, inp, input.mat, '** MATERIALS',...
    '** ----------------------------------------------------------------');
if ~strcmp(input.matype, 'e')
    strrep(inp, 'nlgeom=NO', 'nlgeom=YES')
end
RemBlnkLines(fn);

%% Insert sets & boundary conditions into inp file

% Insert element sets

str1 = '*Elset, elset=Normal Elements';
str2 = '*Elset, elset=Weak Elements';
csvPath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
csvfile = 'NormalElements.csv';
csvfn = strcat(csvPath, csvfile);
NormElset = nodes2str(csvfn);
inp = fileread(fn);
Splt_n_Push(fn, inp, NormElset, str1, str2);
RemBlnkLines(fn);

str1 = '*Elset, elset=Weak Elements';
str2 = '** Section: Normal';
csvPath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
csvfile = 'WeakElements.csv';
csvfn = strcat(csvPath, csvfile);
WeakElset = nodes2str(csvfn);
inp = fileread(fn);
Splt_n_Push(fn, inp, WeakElset, str1, str2);
RemBlnkLines(fn);

% Insert Boundary Conditions into inp file - Under Construction

if strcmp(input.withCells, 'yes')
    if input.contraction == 'U'
        path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
        ibc = strcat(path, 'BCs.txt');
        innerBCs = fileread(ibc);
        if strcmp(config.modelType,'FBC')
            obc = strcat(path, 'fixationBCs.txt');
            outerBCs = fileread(obc);
        end
        if strcmp(config.modelType,'FBC')
            innerBCs = strcat(innerBCs, '\n');
            BCs = strcat(innerBCs, outerBCs);
        elseif strcmp(config.modelType,'TFBC')
            BCs = strcat(innerBCs);
        end
        str1 = '** BOUNDARY CONDITIONS';
        str2 = '** LOADS';
        inp = fileread(fn);
        Splt_n_Push(fn, inp, BCs, str1, str2);
        RemBlnkLines(fn);
    else
        str1 = '** LOADS';
        str2 = '** OUTPUT REQUESTS';
        inp = fileread(fn);
        Splt_n_Push(fn, inp, input.Loads, str1, str2);
        RemBlnkLines(fn);
    end
end

% Insert Node sets into inp file
ins = strcat(path, 'icNsets.txt');
innerSet = fileread(ins);
innerSet = strcat(innerSet, '\n');
if strcmp(config.modelType,'FBC')
    ons = strcat(path, 'ECMNsets.txt');
    outerSet = fileread(ons);
end
if strcmp(config.modelType,'FBC')
    Nsets = strcat(innerSet, outerSet);
elseif strcmp(config.modelType,'TFBC')
    Nsets = strcat(innerSet);
end
str1 = '*End Instance';
str2 = '*End Assembly';
inp = fileread(fn);
Splt_n_Push(fn, inp, Nsets, str1, str2);
RemBlnkLines(fn);


%% Finalize Editing by Removing Blank Lines From inp File - ABAQUS will NOT Compile

% RemBlnkLines(fn);


end


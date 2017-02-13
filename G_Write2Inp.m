function [] = G_Write2Inp ( input, config )

format long g
%% Generalized Write to inp file
% Writes to a name specified inp file 'fn'

% path = 'C:\Users\Naama\Desktop\Research-TAU\MatlabFiles\';

%% Write nodes and elements into .csv files

Write2csv( input.nodes, input.elements )

%% push data into abaqus input script file (.inp)

% Define 'name.inp' as the written file
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\';
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

%% Insert step properties into inp file

inp = fileread(fn);
if ~strcmp(input.damping, 'n/a')
    str_damping = ['*Static, stabilize, factor=',...
        num2str(input.damping), ', allsdtol=0, continue=NO'];
    Splt_n_Push(fn, inp, str_damping,...
        '*Step, name=Step-1, nlgeom=YES', '0.01, 1., 1e-08, 1.');
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

% Insert Boundary Conditions into inp file

if strcmp(input.withCells, 'yes')
    if input.contraction == 'U'
        path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
        ibc = strcat(path, 'BCs.txt');
        innerBCs = fileread(ibc);
        if strcmp(config.modelType,'FBC')
            obc = strcat(path, 'fixationBCs.txt');
            outerBCs = fileread(obc);
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
else
    if ~isempty(strfind(config.modelType, 'BCE'))
        bce = strcat(csvPath, 'BCE_BCs.txt');
        BCs = fileread(bce);
        str1 = '** BOUNDARY CONDITIONS';
        str2 = '** LOADS';
        inp = fileread(fn);
        Splt_n_Push(fn, inp, BCs, str1, str2);
        RemBlnkLines(fn);
    end
end

% Re-define model type (none-liner) and number of increments
inp = fileread(fn);
if ~strcmp(input.matype, 'LE')
    if ~isempty(strfind(inp, 'nlgeom=NO'))
        inp = strrep(inp, 'nlgeom=NO', 'nlgeom=YES, inc=1000');
    else
        inp = strrep(inp, 'nlgeom=YES', 'nlgeom=YES, inc=1000');
    end
else
    inp = strrep(inp, 'nlgeom=YES', 'nlgeom=NO');
end

fid = fopen(fn, 'wt');
fprintf(fid, inp); % write nodes into file
fclose(fid);
RemBlnkLines(fn);

% Re-define element's cross-sectional area
if config.blMatProp.cs_area ~= 1
   csa = [num2str(config.blMatProp.cs_area), ','];
   str1 = '*Solid Section, elset=NORMALELEMENTS, material="Normal Elastic"';
   str2 = '** Section: Weak';
   Splt_n_Push(fn, inp, csa, str1, str2);
   inp = fileread(fn);
   str1 = '*Solid Section, elset=WEAKELEMENTS, material="Weak Elastic"';
   str2 = '*End Part';
   Splt_n_Push(fn, inp, csa, str1, str2);
   RemBlnkLines(fn);
end

% Insert Node sets into inp file

if strcmp(input.withCells, 'yes')
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
end

if ~isempty(strfind(config.modelType, 'BCE'))
    rns = strcat(csvPath, 'rBCENsets.txt');
    lns = strcat(csvPath, 'lBCENsets.txt');
    tns = strcat(csvPath, 'tBCENsets.txt');
    bns = strcat(csvPath, 'bBCENsets.txt');
    
    rNSet = fileread(rns);
    lNSet = fileread(lns);
    tNSet = fileread(tns);
    bNSet = fileread(bns);
    
    Nsets = strcat(rNSet, '\n');
    Nsets = strcat(Nsets, lNSet);
    Nsets = strcat(Nsets, '\n');
    Nsets = strcat(Nsets, tNSet);
    Nsets = strcat(Nsets, '\n');
    Nsets = strcat(Nsets, bNSet);
    Nsets = strcat(Nsets, '\n');
    
    str1 = '*End Instance';
    str2 = '*End Assembly';
    inp = fileread(fn);
    Splt_n_Push(fn, inp, Nsets, str1, str2);
    RemBlnkLines(fn);
end

RemBlnkLines(fn);

%% Finalize Editing by Removing Blank Lines From inp File - ABAQUS will NOT Compile

% RemBlnkLines(fn);


end


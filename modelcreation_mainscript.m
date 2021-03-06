% created by Hanan Tokash; adapted by Ran Sopher

tic
close all
clc

f = 1; % figure #

% This script generates a set of 2D models in a 'Square-Circle' configuration
% 'Square-Circle' Configuration: a square of dimension 'sq' with a full inner
% circle of radius 'R' pierced with circle of radius 'r'.

% To accomplish that, you should:
% 1. build a model in abaqus and submit it to generate a general inp file.
% 2. copy the inp file into the destination folder defined by 'fn'.

% ** Note that definitions like element and material types should match the definitions of your model **
% ** T2D2 elements and linear or hyperelastic material **

%% Get Parameters

disp('Defining required paramters...')

[ config ] = GetParams(); %% HERE

ll = length(config.LOC);
lr = length(config.ROR);
ld = length(config.cells);
if ld == 0
    ld = 1;
    config.cells = {};
end

tic
for i = 1 : ll
    for j = 1 : lr
        for k = 1 : ld
        %% Generate Nodes
        
        display(['generating model ', num2str(i), '-', num2str(j), '-', num2str(k)]);
        disp(['out of ', num2str(lr), '-', num2str(ll), '-', num2str(ld), '...'])
        
        disp('Generating nodes...');
        
        tic
        
        Nodes = GenNodes2d(config);
        
        t_generate_nodes = toc/60;
        
        %% Handle Nodes
        % Eliminating nodes that exceed the limit of radius
        disp('Handling nodes');
        disp('Generating cells');
        tic;
        
        % Adjusting cell coordinates (to apply cell symmetry)
        if strcmp(config.terms.Cells, 'yes') % a single cell
            [circNodes, config.cells{k}] = AdjustMCC(config, Nodes, k);
            [ Nodes, ~, oc ] = RemoveNodes2(Nodes, config, k);
        end
        
        if strcmp(config.terms.sqReg, 'no')
            Nodes = remSqReg(Nodes, config);
        end
        
        t_handle_nodes = toc/60;
        
        %% Generate Elements
        disp('Generating elements');
        tic;
        
        %% Generate elements according to specified distance (between nodes)
       
        if isempty(strfind(config.modelType, 'BCE'))
            % Generate basic elements
            bEl = GenEl2d_v2_HT(Nodes, config, 1);
            
            % Generate oblique elements
            oEl = GenEl2d_v2_HT(Nodes, config, sqrt(2));
            
            % Add index to element vector
            El = vertcat(bEl, oEl);
        else
            El = GenEl2d_v3(Nodes, config);
        end
        
        El = AddIndx(El); % the result is a vector containing three columns: element serial number and the two nodes defining it (as defined by their serial numbers)
        t_generate_elements = toc/60;
        
        % Generate BCE node-sets
        if ~isempty(strfind(config.modelType, 'BCE'))
            nBCE = Edges(Nodes, config);
            rBCENsets = GenNSets(nBCE.Right, 'rBCENsets.txt');
            lBCENsets = GenNSets(nBCE.Left, 'lBCENsets.txt');bBCENsets
            tBCENsets = GenNSets(nBCE.Top, 'tBCENsets.txt');
            bBCENsets = GenNSets(nBCE.Buttom, 'bBCENsets.txt');
        end
        
        if strcmp(config.regParams.rotate, 'y')
            Nodes = rotate_model(Nodes, config.regParams.rotation_angle);
        end
        
        %% Randomize Nodes Locations - Add Randomness
        tic
        disp('Applying Randomness');
        Nodes = Randomness2d( Nodes, config, config.ROR(j), k ); % Adds randomness to element length
        
        % Add index to node vector (if needed)
        [l, w] = size(Nodes);
        if w == 2
            Nodes = AddIndx(Nodes); % the result is a vector containing three columns: node serial number and its (x,y) coordinates
        end
        t_randomness = toc/60;
        
        %% Handle Elements
        disp('Handling elements');
        tic;
        
        % Remove over-defined elements if there are any
        El = ROD(El, Nodes); % ROD = Remove over-defined
                
        %% Delete elements in random - reduce connectivity
        disp('Applying Connectivity');
        ConnRange = [config.params.R, config.params.r+2*config.regParams.iSeed];
        El = Connectivity(El, Nodes, ConnRange, config.LOC(i), config);
        
        if strcmp(config.terms.sqReg, 'yes') && isempty(strfind(config.modelType, 'BCE'))
            El = getosq(Nodes, El, config); % Turn square elements into weak (if they have not been deleted already)
        end
        
        %% Define material properties and take care of non-linear geometry flag - under construction
        
        disp('Generating Material Properties')
        
        if ~isempty(config.cells)
            num_of_cells = config.cells{k};
            distance_between_cells = config.Cells_Information.Distance_between_Cells(k);
        else
            num_of_cells = 0;
            distance_between_cells = 0;
        end
        
        FN = GenFileName(config.ROR(j)/config.regParams.iSeed, config.LOC(i),...
            config.terms.Cells, num_of_cells, distance_between_cells,...
            config.modelType, config.blMatProp.type, config.terms.BCE_Mag);
        config.fn = FN;
        save('E:\Ran\Cell-ECM_model_2D_1_cell\LastConfig\Config.mat', 'config');
        
        [ mat ] = defmat(config, FN);
        
        %% Generate node-sets from inner nodes
        
        % Get inner-circle's nodes for Set and BC generation
        % Get one-sided elements (if there are any)
        if isempty(config.cells) && strcmp(config.terms.Cells, 'yes')% i.e., a model of a single cell
            ic = Nicirc(El.new, Nodes, config);  % 'ic' just gives node numbers
        else
            if strcmp(config.terms.Cells, 'yes')
                ic = Nicirc2(El.new, Nodes, config, k); % ic just gives both node numbers (column 2) and cell numbers (column 1)
                config.Cells_Information.cell_nodes = ic;
            end
        end
        
        if strcmp(config.terms.Cells, 'yes')
            Nodes = apply_circ_cells(ic, circNodes, Nodes); % Make cell symmetric-circular
        end
        t_handle_elements = toc/60;
        
        tic;
        
        if strcmp(config.terms.Cells, 'yes')
            if isempty(config.cells) % a single cell
                icNsets = GenNSets(ic, 'icNsets.txt'); % putting the nodes above into a file
            else
                icNsets = GenNSets(ic(:, 2), 'icNsets.txt'); % putting the nodes above into a file
            end
        else
            icNsets = 'Not Required';
        end
        t_generate_nodesSets = toc/60;
        
        %% Generate node-sets from outer nodes
        
        if strcmp(config.modelType,'FBC')
            % Get outer-circle's nodes for Set and BC generation
            % Get one-sided elements (if there are any)
            ECMc = ECMcirc(El.new, Nodes, config);
            t_handle_elements = toc/60;
            
            tic;
            ECMNsets = GenNSets(ECMc, 'ECMNsets.txt'); % writing the nodes above into a file
            t_generate_nodesSets = toc/60;
        end
        
        %% Generate boundary conditions on inner nodes
        
        if ~isempty(strfind(config.modelType, 'BCE'))
            BCE_BCs = GenBCE_BCs(nBCE, config, Nodes);
            fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\BCE_Nsets.txt';
            fid = fopen(fn, 'wt');
            fprintf(fid, BCE_BCs);
            fclose('all');
        end
        
        if strcmp(config.terms.Cells, 'yes')
            if strcmp(config.terms.Contraction,'U') % if the UBCs/LBCs of the model are BCs
                disp('Generating Boundary Conditions');
                tic;
                if isempty(config.cells) % a single cell
                    [ BCs, bcNames ] = GenBCs(ic, Nodes, config);
                else % multiple cells
                    [ BCs, bcNames ] = GenBCs2(ic, Nodes, config, k);
                end
                fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\BCs.txt';
                fid = fopen(fn, 'wt');
                fprintf(fid, BCs);
                fclose('all');
                t_generate_BCs = toc/60;
                t_generate_loads = 0;
                Loads = 'Not required for this type of model';
                fclose('all');
            else % if the BCs/LCs of the model are LCs
                disp('Generating Loads');
                tic;
                [ Loads ] = GenLoads2(ic, config.cells{k});
                [ TFLoads ] = GenLoads2(oc, config.cells{k});
                fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Loads.txt';
                fid = fopen(fn, 'wt');
                fprintf(fid, Loads);
                fclose('all');
                t_generate_loads = toc/60;
                t_generate_BCs = 0;
                BCs = 'Not required for this type of model';
            end
        else % no BCs and no LCs
            t_generate_loads = 0;
            t_generate_BCs = 0;
            BCs = 'Not required for this type of model';
            Loads = 'Not required for this type of model';
        end
        
        %% Generate boundary conditions on outer nodes
        
        disp('Generating Fixation Boundary Conditions');
        if strcmp(config.modelType,'FBC')
            [ fixationBCs, bcNames ] = GenfixationBCs(ECMc, Nodes);
        end
        
        %% Push nodes and elements into abaqus input script file (.inp)
        % (Also writes data(nodes, elements and weak and normal elements)
        % to .csv files)
        
        disp('Writing into .inp file');
        tic;
        
        if isempty(config.cells)
            celloc = 0;
        else
            celloc = config.cells{k};
        end
        
        input = struct('nodes', Nodes, 'elements', El.new, 'Nsets', icNsets, ...
            'BCs', BCs, 'Loads', Loads, 'FN', FN, 'Celloc', celloc,...
            'withCells', config.terms.Cells, 'contraction', config.terms.Contraction,...
            'mat', mat.mats, 'matype', config.params.matype, 'damping', config.params.damping);
        
        G_Write2Inp(input,config);
        t_Write2file = toc/60;
        
        t = [t_generate_BCs, t_generate_loads, t_generate_elements, t_generate_nodes,...
            t_generate_nodesSets, t_handle_elements, t_handle_nodes,...
            t_randomness, t_Write2file];
        ti = sum(t);
        T(j) = ti;
        tti = num2str(ti);
        disp(['model file: ', FN, ' was generated successfully']);
        disp(['Elasped time: ', tti, ' minutes']);
        
        end
    end
end
tt = num2str(sum(T));
disp('Process is completed successfully');
disp(['Total Time is: ', tt, ' minutes']);

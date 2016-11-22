% created by Hanan Tokash; adapted by Ran Sopher, 18-Jul-2016

tic
close all
clear all
clc

f = 1; % figure #

% This script generates a set of 2D models in a 'Square-Circle' configuration
% 'Square-Circle' Configuration: a square of dimension 'sq' with a full inner
% circle of radius 'R' pierced with circle of radius 'r'.

% ** model file name should be present in the destination folder 'fn' **

% To accomplish that, you should:
% 1. build a model in abaqus and submit it to generate a general inp file.
% 2. copy the inp file into the destination folder defined by 'fn'.
% 
% ** Note that definitions like element and material types should match the definitions of your model **
% ** T2D2 elements and linear or hyperelastic material **

%% Get Parameters

display('Defining required paramters...')

[ config ] = GetParams();

ll = length(config.LOC);
lr = length(config.ROR);

tic
for i = 1 : ll
    for j = 1 : lr
        %% Generate Nodes
        
        display(['generating model ', num2str(i), '-', num2str(j)]);
        display(['out of ', num2str(lr), '-', num2str(ll), '...'])
        display('Generating nodes...');
        tic
        Nodes = GenNodes2d(config);
        
        % function [ pts ] = MCC( nodes, n, d, form, ordform, r )
        % pts = MCC(newNodes, 0, 12*iSeed, 'ordered', 'sq', sq/3);
        t_generate_nodes = toc/60;
        
        t_genNodes = toc;
        %% Handle Nodes        
        % Eliminating nodes that exceed the limit of radius
        display('Handling nodes');
        display('Generating cells');
        tic;
        
        if isempty(config.cells) % i.e., a model of a single cell
            [ Nodes, ~, oc ] = RemoveNodes(Nodes, config);
%         else
%             [ Nodes, ~, oc ] = RemoveNodes2(Nodes, config);
        end
        
        if strcmp(config.terms.sqReg, 'no')
            Nodes = remSqReg(Nodes, config);
        end        
        
        t_handle_nodes = toc/60;
        
        %% Generate Elements
        display('Generating elements');
        tic;
        
        %% Generate elements according to specified distance (between nodes)
        
        % % Generate basic elements
        bEl = GenEl2d_v2(Nodes, config, 1);
        
        % Generate oblique elements
        oEl = GenEl2d_v2(Nodes, config, sqrt(2));
        
        % Add index to element vector
        El = vertcat(bEl, oEl);
        El = AddIndx(El); % the result is a vector containing three columns: element serial number and the two nodes defining it (as defined by their serial numbers)
        t_generate_elements = toc/60;
               
        %% Randomize Nodes Locations - Add Randomness
        tic
        display('Applying Randomness');
        Nodes = Randomness2d( Nodes, config, config.ROR(j) ); % Adds randomness to element length
        
        % Add index to node vector (if needed)
        [l, w] = size(Nodes);
        if w == 2
            Nodes = AddIndx(Nodes); % the result is a vector containing three columns: node serial number and its (x,y) coordinates
        end
        t_randomness = toc/60;
        
        %% Handle Elements
        display('Handling elements');
        tic;
        
        % Remove over-defined elements if there are any
        El = ROD(El, Nodes); % ROD = Remove over-defined
        
        % Eliminate elements that exceed the limit of radius
        % newEl = Pierce( newNodes, newEl, r ); % Pierce a hole in the network
        
        %% Delete elements in random - reduce connectivity
        display('Applying Connectivity');
        ConnRange = [config.params.R, config.params.r+2*config.params.iSeed];
        El = Connectivity(El, Nodes, ConnRange, config.LOC(i), config);
        
        if strcmp(config.terms.sqReg, 'yes')
            El = getosq(Nodes, El, config); % turn square elements into weak (if they have not been deleted already)
        end
               
        %% Define material properties and take care of non-linear geometry flag - under construction
        
        display('Generating Material Properties')
        FN = GenFileName(config.ROR(j)/config.params.iSeed, config.LOC(i), config.terms.Cells);
        [ mat ] = defmat(config, FN);
        
        %%% until here
        
        %% Generate node-sets from inner nodes
        
        % Get inner-circle's nodes for Set and BC generation
        % Get one-sided elements (if there are any)
        [ ic, ons ] = Nicirc(El.new, Nodes, config.params.r); 
        t_handle_elements = toc/60;
        
        tic;
        icNsets = GenNSets(ic);
        t_generate_nodesSets = toc/60;
        
        %% Generate boundary conditions on inner nodes
        
        if strcmp(config.terms.Cells, 'yes')
            if strcmp(config.terms.Contraction,'U')
                display('Generating Boundary Conditions');
                tic;
                if isempty(config.cells)
                    [ BCs, bcNames ] = GenBCs(ic, Nodes, config);
                else
                    [ BCs, bcNames ] = GenBCs2(ic, Nodes, config);
                end
                fn = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\BCs.txt';
                fid = fopen(fn, 'wt');
                fprintf(fid, BCs);
                fclose('all');
                t_generate_BCs = toc/60;
                t_generate_loads = 0;
                Loads = 'Not required for this type of model';
                fclose('all');
            else
                display('Generating Loads');
                tic;
                [ Loads ] = GenLoads2(ic, config.cells);
                [ TFLoads ] = GenLoads2(oc, config.cells);
                fn = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\Loads.txt';
                fid = fopen(fn, 'wt');
                fprintf(fid, Loads);
                fclose('all');
                t_generate_loads = toc/60;
                t_generate_BCs = 0;
                BCs = 'Not required for this type of model';
            end
        else
            t_generate_loads = 0;
            t_generate_BCs = 0;
            BCs = 'Not required for this type of model';
            Loads = 'Not required for this type of model';
        end
        
        %% Push nodes and elements into abaqus input script file (.inp)
        % (Also writes data(nodes, elements and weak and normal elements)
        % to .csv files)
        
        display('Writing into .inp file');
        tic;
        
        input = struct('nodes', Nodes, 'elements', El.new, 'Nsets', icNsets, ...
            'BCs', BCs, 'Loads', Loads, 'FN', FN, 'Celloc', config.cells,...
            'withCells', config.terms.Cells, 'contraction', config.terms.Contraction,...
            'mat', mat.mats, 'matype', config.params.matype);
        
        G_Write2Inp(input);
        t_Write2file = toc/60;
        
        t = [t_generate_BCs, t_generate_loads, t_generate_elements, t_generate_nodes,...
            t_generate_nodesSets, t_handle_elements, t_handle_nodes,...
            t_randomness, t_Write2file];
        ti = sum(t);
        T(j) = ti;
        tti = num2str(ti);
        display(['model file: ', FN, ' was generated successfully']);
        display(['Elasped time: ', tti, ' minutes']);
        
    end
end
tt = num2str(sum(T));
display('Process is completed successfully');
display(['Total Time is: ', tt, ' minutes']);

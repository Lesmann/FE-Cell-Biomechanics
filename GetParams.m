function [ config ] = GetParams ()

% This function generates the parameters required for the model.
% Units: length - mm, force - N, pressure - MPa

regParams.iSeed = 1; % default
regParams.rect.length = 1; % default
regParams.rect.width = 1; % default

params = struct('R', regParams.rect.length/2, 'r', 5*regParams.iSeed, 'MOD', 0.1, 'matype', 'required'); % default, MOD = magnitude of displacement (relative to the cell radius)
CellInfo.Distance_between_Cells = 'NA';

% bi-linear (linear with buckling) material properties
blmatprop = struct('ymod', 1, 'poisr', 0.45, 'type', 'bi-linear',...
    'n', 1000, 'r', 0.9999, 'rho', 0.1, 'cs_area', pi*regParams.iSeed^2/400);

disp('Model type');
model = input('BCE (bulk control experiment model) / TFBC (traction-free boundary conditions) / FBC (fixation boundary conditions) / UD (user-defined): ', 's');

if ~strcmp(model, 'BCE')
    disp('Cell arrangement')
    cellArrangement = input ('C (circular) / 4 (4 nearest neighbours) / 6 (6 nearest neighbours): ', 's');
    if cellArrangement == 'C'
        numofCells = input('How many cells? ');
        disp('Distance between cells:');
        dfo1 = input('from: ');
        dfo2 = input('to: ');
        dfoint = input('in intervals of: ');
        dfo = dfo1 : dfoint : dfo2;
        for i = 1 : length(dfo)
            CellInfo = struct('Number_of_Cells', numofCells, 'Distance_between_Cells', dfo);
            if numofCells==1
                pts = []; % default - single cell at the origin
            else
                pts{i} = MCC_circular(numofCells, params.R, dfo(i));
            end
        end
    elseif cellArrangement == '4'
        numofCells='4neighbours';
        pts = MCC_4neighbours(regParams,params);
    end
end

disp('Material linearity');
material_linearity = input ('L (linear material) / BL (bi-linear material, i.e. buckling): ', 's');
if material_linearity == 'L'
    blmatprop.type='linear';
    blmatprop.rho=1;
end

disp('Damping Factor');
withDF = input('Include damping factor? (y/n) ', 's');
if strcmp(withDF, 'y')
    params.damping = input('Damping factor value: ');
else
    params.damping = 'Not Required';
end

% 'BCE' - bulk control experiment model
    % Uniaxial Tension
    % Shear
% 'TFBC' - traction-free boundary conditions
    % No boundary conditions are imposed at the edges
% 'FBC' - fixed boundary conditions
    % Fixed boundary conditions are imposed at the edges
% 'Custom' - user defined single model
    % A customized model

switch model
    
    case 'BCE' % bulk control model
        
        terms = struct('Cells', 'no', 'sqReg', 'yes', 'Contraction', 'U', 'bceType', 'BCE only', 'BCE_Mag', 'N/A');  
        pts = [];
        disp('BCE type: ');
        terms.bceType = input('Tension (T) / Compression (C) / Shear (S): ', 's');
        if strcmp(terms.bceType, 'S')
            regParams.rect.length = 0.1*regParams.rect.width;
        end
        model = strcat(model, '_');
        model = strcat(model, terms.bceType);
        
        regParams.rotate = input('Rotated model (y/n)? ', 's');
        if strcmp(regParams.rotate, 'y')
            regParams.rotation_angle = pi/4;
        end
        
        disp('BCE displacement magnitude: ')
        terms.BCE_Mag = input('Stretch magnitude: ');
        
        disp('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = regParams.iSeed*ror;
        
        disp('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
        
        disp('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
    
    case 'TFBC' % traction free boundary conditions at the matrix edges
        
        terms = struct('Cells', 'yes', 'sqReg', 'no', 'Contraction', 'U', 'bceType', 'N/A', 'BCE_Mag', 'N/A');  
        
        disp('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = regParams.iSeed*ror;
        
        disp('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
                
        disp('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
        
    case 'FBC' % fixed boundary conditions at the matrix edges
        
        terms = struct('Cells', 'yes', 'sqReg', 'no', 'Contraction', 'U', 'bceType', 'N/A', 'BCE_Mag', 'N/A');  
        
        disp('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = regParams.iSeed*ror;
        
        disp('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
        
        disp('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
        
    case 'UD' % user defined
        
        terms = struct('Cells', 'required', 'sqReg', 'required', 'Contraction', 'required', 'bceType', 'N/A', 'BCE_Mag', 'N/A');  
        
        disp('Terms:');
        terms.Cells = input('Model with cells? (yes/no) ', 's');
        terms.sqReg = input('Square regioned? (yes/no) ', 's');
        terms.Contraction = input('Contraction by displacement(U) / Force(F)? ', 's');
        
        disp('Radius of Randomness (0 to 1)');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = regParams.iSeed*ror;
        
        disp('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
        
        disp('Type of data of material mechanical properties');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
        if strcmp(params.matype, 'TD')
            iselastic = input('Linear elastic (TDL) / bi-linear elastic (TDBL) Test Data: ', 's');
            if strcmp(iselastic, 'TDL')
                blmatprop.rho = 1;
            end
        end
        
end

config = struct('regParams', regParams, 'params', params,...
    'modelType', model, 'terms', terms, 'ROR', ROR, 'LOC', LOC,...
    'cells', {pts}, 'blMatProp', blmatprop, 'Cells_Information', CellInfo);

save('E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Config.mat', 'config')


end


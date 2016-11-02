function [ config ] = GetParams ()

% This function generates the parameters required for the model.
% Units: length - mm, force - N, pressure - MPa

regParams = struct('sq', 500, 'iSeed', 5); % default

params = struct('R', regParams.sq/2, 'r', 5*regParams.iSeed, 'MOD', 0.1, 'matype', 'required'); % default, MOD = magnitude of displacement (relative to the cell radius)
CellInfo.Distance_between_Cells = 'None';

% bi-linear (linear with buckling) material properties
blmatprop = struct('ymod', 1, 'poisr', 0.45, 'type', 'bi-linear', 'n', 100, 'r', 0.5, 'rho', 0.1);

display('Model type');
model = input('BCE (bulk control experiment model) / TFBC (traction-free boundary conditions) / FBC (fixation boundary conditions) / UD (user-defined): ', 's');

if ~strcmp(model, 'BCE')
    display('Cell arrangement')
    cellArrangement = input ('C (circular) / 4 (4 nearest neighbours) / 6 (6 nearest neighbours): ', 's');
    if cellArrangement == 'C'
        numofCells = input('How many cells? ');
        dfo = input('Distance between cells (0 < dfo < 1)? ');
        CellInfo = struct('Number_of_Cells', numofCells, 'Distance_between_Cells', dfo);
        if numofCells==1
            pts = []; % default - single cell at the origin
        else
            pts = MCC_circular(numofCells,params.R, dfo);
        end
    elseif cellArrangement == '4'
        numofCells='4neighbours';
        pts = MCC_4neighbours(regParams,params);
    end
end

display('Material linearity');
material_linearity = input ('L (linear material) / BL (bi-linear material, i.e. buckling): ', 's');
if material_linearity == 'L'
    blmatprop.type='linear';
    blmatprop.rho=1;
end

display('Damping Factor');
withDF = input('Include damping factor? (y/n) ', 's');

if strcmp(withDF, 'y')
    params.damping = input('Damping factor value: ');
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
        display('BCE type: ');
        terms.bceType = input('Tension (T) / Compression (C) / Shear (S): ', 's');
        model = strcat(model, '_');
        model = strcat(model, terms.bceType);
        
        display('BCE displacement magnitude: ')
        terms.BCE_Mag = input('Stretch magnitude: ');
        
        display('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = regParams.iSeed*ror;
        
        display('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
        
        display('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
    
    case 'TFBC' % traction free boundary conditions at the matrix edges
        
        terms = struct('Cells', 'yes', 'sqReg', 'no', 'Contraction', 'U', 'bceType', 'N/A', 'BCE_Mag', 'N/A');  
        
        display('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = regParams.iSeed*ror;
        
        display('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
                
        display('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
        
    case 'FBC' % fixed boundary conditions at the matrix edges
        
        terms = struct('Cells', 'yes', 'sqReg', 'no', 'Contraction', 'U', 'bceType', 'N/A', 'BCE_Mag', 'N/A');  
        
        display('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = regParams.iSeed*ror;
        
        display('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
        
        display('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
        
    case 'UD' % user defined
        
        terms = struct('Cells', 'required', 'sqReg', 'required', 'Contraction', 'required', 'bceType', 'N/A', 'BCE_Mag', 'N/A');  
        
        display('Terms:');
        terms.Cells = input('Model with cells? (yes/no) ', 's');
        terms.sqReg = input('Square regioned? (yes/no) ', 's');
        terms.Contraction = input('Contraction by displacement(U) / Force(F)? ', 's');
        
        display('Radius of Randomness (0 to 1)');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = regParams.iSeed*ror;
        
        display('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
        
        display('Type of data of material mechanical properties');
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
    'cells', pts, 'blMatProp', blmatprop, 'Cells_Information', CellInfo);

save('E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Config.mat', 'config')


end


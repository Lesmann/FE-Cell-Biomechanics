function [ config ] = GetParams ()

% This function generates the parameters required for the model.
% Units: length - mm, force - N, pressure - MPa

regParams = struct('sq', 0.6); % default
params = struct('iSeed', 0.006, 'R', regParams.sq/2, 'r', regParams.sq/50, 'MOD', 0.1, 'matype', 'required'); % default, MOD = magnitude of displacement

% bi-linear (linear with buckling) material properties
blmatprop = struct('ymod', 15, 'poisr', 0.45, 'type', 'bi-linear', ...
            'n', 100, 'r', 0.5, 'rho', 0.1);

% define center-coordinate of introduced cells
% you can use the 'cellar' function to automatically generate coordinates.
pts = []; % default - single cell at the origin

display('Model type');

model = input('BCE (bulk control experiment model) / TFBC (traction-free boundary conditions) / FBC (fixation boundary conditions) / UD (user-defined): ', 's');

material_type = input ('L (linear material) / BL (bi-linear, buckling)', 's');
if material_type == 'L'
    blmatprop.type='linear';
    blmatprop.rho=1;
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
    
%     case 'BCE' % bulk control model
%         
%         terms = struct('Cells', 'no', 'sqReg', 'yes', 'Contraction', 'U', 'bceType', 'BCE only');  
%         
%         display('BCE type');
%         terms.bceType = input('tension(t)/shear(s): ', 's');
%         
%         display('Radius of Randomness');
%         ror1 = input('from: ');
%         ror2 = input('to: ');
%         rorint = input('with intervals of: ');
%         
%         ror = ror1:rorint:ror2;
%         ROR = params.iSeed*ror;
%         
%         display('Level of Connectivity');
%         loc1 = input('from: ');
%         loc2 = input('to: ');
%         locint = 0.0625; % default
%         LOC = loc1:locint:loc2;
%         
%         display('Material type');
%         params.matype = input('elatic(e)/hyperelastic(h): ', 's');
        
    case 'TFBC' % traction free boundary conditions
        
        terms = struct('Cells', 'yes', 'sqReg', 'no', 'Contraction', 'U', 'bceType', 'BCE only');  
        
%         display('Cells')
%         mcc = input('Multi-cell Model (under construction)? (yes/no)');
%         display('Sorry, this option is currently under construction...')
%         display('You can change the configuration settings through this function.')
%         return;
%         
%         if strcmp(mcc, 'yes')
%             cud = input('DIY cell coordinates? (yes/no)');
%             if strcmp(cud, 'yes')
%                 noMoreCells = 'no';
%                 k=1;
%                 while strcmp(noMoreCells, 'no')
%                     cells(:, k) = input(['Entercoordinates of cell #', num2str(k), '{example: -0.3, 0.3} :']);
%                     k=k+1;
%                     noMoreCells = input('do you want more cells? (yes/no)');
%                 end
%             else
%                 mccConfig = struct('numOfcells', 'Required', 'minDist', 'Required', 'formType', 'Required'...
%                     ,'cellForm', 'Required', 'dim', 'Required');
%                 cn = input('How many cells? ');
%                 md = input('Minimum distance between cells?');
%                 ft = input('cell formation type? (random/ordered) ');
%                 cf = input('in what formation? (circ=circular, sq=square)');
%                 rd = input('radius/dimension? ');
% 
%             end
%         end
        
        display('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        
        ror = ror1:rorint:ror2;
        ROR = params.iSeed*ror;
        
        display('Level of Connectivity, ranging between 0 (0 weak and 8 strong elements surrounding each node) and 8 (8 weak and 0 strong elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = -0.0625; % default
        LOC = loc1:locint:loc2;
                
        display('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
        
    case 'FBC' % fixed boundary conditions
        
        terms = struct('Cells', 'yes', 'sqReg', 'yes', 'Contraction', 'U', 'bceType', 'BCE only');  
        
        display('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        
        ror = ror1:rorint:ror2;
        ROR = params.iSeed*ror;
        
        display('Level of Connectivity, ranging between 0 (0 weak and 8 strong elements surrounding each node) and 8 (8 weak and 0 strong elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = -0.0625; % default
        LOC = loc1:locint:loc2;
        
        display('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
        
    case 'UD' % user defined
        
        terms = struct('Cells', 'required', 'sqReg', 'required', 'Contraction', 'required', 'bceType', 'BCE only');  
        
        display('Terms:');
        terms.Cells = input('Model with cells? (yes/no) ', 's');
        terms.sqReg = input('Square regioned? (yes/no) ', 's');
        terms.Contraction = input('Contraction by displacement(U)/Force(F)? ', 's');
        
        display('Radius of Randomness (0 to 1)');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        
        ror = ror1:rorint:ror2;
        ROR = params.iSeed*ror;
        
        display('Level of Connectivity (0 to 1)');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = -0.0625; % default
        LOC = loc1:locint:loc2;
        
        display('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
        if strcmp(params.matype, 'TD')
            iselastic = input('Elastic (tdel) / bi-linear (tdbl) Test Data: ', 's');
            if strcmp(iselastic, 'tdel')
                blmatprop.rho = 1;
            end
        end
        
end

config = struct('regParams', regParams, 'params', params,...
    'modeType', model, 'terms', terms, 'ROR', ROR, 'LOC', LOC, 'cells', pts, 'blMatProp', blmatprop);

end


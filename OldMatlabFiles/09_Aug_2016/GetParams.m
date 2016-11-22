function [ config ] = GetParams ()

% This function generates the parameters required for the model.
% Units: length - mm, force - N, pressure - MPa

regParams = struct('sq', 1); % default
params = struct('iSeed', 0.006, 'R', regParams.sq/2, 'r', regParams.sq/(2*50), 'MOD', 0.1, 'matype', 'required'); % default, MOD = magnitude of displacement (relative to the cell radius)

% bi-linear (linear with buckling) material properties
blmatprop = struct('ymod', 15, 'poisr', 0.45, 'type', 'bi-linear', 'n', 100, 'r', 0.5, 'rho', 0.1);

display('Model type');
model = input('BCE (bulk control experiment model) / TFBC (traction-free boundary conditions) / FBC (fixation boundary conditions) / UD (user-defined): ', 's');

% define center-coordinate of introduced cells
% you can use the 'cellar' function to automatically generate coordinates.
numofCells = input('How many cells? ');
if numofCells==1
    pts = []; % default - single cell at the origin
else
    pts = MCC(numofCells,params.R);
end

display('Material linearity');
material_linearity = input ('L (linear material) / BL (bi-linear material, i.e. buckling) ', 's');
if material_linearity == 'L'
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
    
    %{
    
    case 'BCE' % bulk control model
        
        terms = struct('Cells', 'no', 'sqReg', 'yes', 'Contraction', 'U', 'bceType', 'BCE only');  
        
        display('BCE type: ');
        terms.bceType = input('Tension (T) / Compression (C) / Shear (S): ', 's');
        
        display('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = params.iSeed*ror;
        
        display('Level of Connectivity, ranging between 0 (0 strong and 8 weak elements surrounding each node) and 8 (8 strong and 0 weak elements surrounding each node); intervals of 0.5');
        loc1 = input('from: ');
        loc1 = loc1/8;
        loc2 = input('to: ');
        loc2 = loc2/8;
        locint = 0.0625; % default
        LOC = loc1:locint:loc2;
        
        display('Material type');
        params.matype = input('Youngs-modulus based (YM) / Test-data based (TD): ', 's');
      
  
    %}
    
    case 'TFBC' % traction free boundary conditions at the matrix edges
        
        terms = struct('Cells', 'yes', 'sqReg', 'no', 'Contraction', 'U', 'bceType', 'N/A');  
        
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
        
        terms = struct('Cells', 'yes', 'sqReg', 'yes', 'Contraction', 'U', 'bceType', 'N/A');  
        
        display('Radius of Randomness, ranging between 0 and 1');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = params.iSeed*ror;
        
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
        
        terms = struct('Cells', 'required', 'sqReg', 'required', 'Contraction', 'required', 'bceType', 'N/A');  
        
        display('Terms:');
        terms.Cells = input('Model with cells? (yes/no) ', 's');
        terms.sqReg = input('Square regioned? (yes/no) ', 's');
        terms.Contraction = input('Contraction by displacement(U) / Force(F)? ', 's');
        
        display('Radius of Randomness (0 to 1)');
        ror1 = input('from: ');
        ror2 = input('to: ');
        rorint = input('in intervals of: ');
        ror = ror1:rorint:ror2;
        ROR = params.iSeed*ror;
        
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
    'modelType', model, 'terms', terms, 'ROR', ROR, 'LOC', LOC, 'cells', pts, 'blMatProp', blmatprop);

end


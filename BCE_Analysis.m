function [ Res ] = BCE_Analysis( path )

% This function Analyse data from bulk-control experiment models (BCE) and
% generate the following graphs according to the BCE Type:
% 1. Poisson's ratio vs. axial strain for uniaxial tension/compression BCEs.
% 2. Normal vs. shear strain for shear loading BCEs.

% read and calculate reference data

% Res.Ref_Data = strain2log_stretch_ratio( path );
path2config = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Config.mat';
config = load(path2config);
Res.config = config.config;
Res.Ugrad.distance_axis = -Res.config.params.R : Res.config.regParams.iSeed : Res.config.params.R;
rl = Res.config.regParams.rect.length;
rw = Res.config.regParams.rect.width;
seed = Res.config.regParams.iSeed;

Res.Ref_Data = strain2log_stretch_ratio( path );
x = Res.Ref_Data.Nodes(:, 1);
y = Res.Ref_Data.Nodes(:, 2);
elements = Res.Ref_Data.Elements;

ux = cell2mat(Res.Ref_Data.Data(1).U_U1);
Res.Metadata(1).ux = ux;
uy = cell2mat(Res.Ref_Data.Data(1).U_U2);
Res.Metadata(1).uy = uy;

% define initial nodes as node locations after the first increment
ix = x+ux';
iy = y+uy';

for i = 2 : length(Res.Ref_Data.Data)
    
    ux = cell2mat(Res.Ref_Data.Data(i).U_U1);
    Res.Metadata(i).ux = ux;
    uy = cell2mat(Res.Ref_Data.Data(i).U_U2);
    Res.Metadata(i).uy = uy;
    
    % Compute apparent strains (Axial and Transversal) - by element length
    nodes_before = horzcat(ix, iy);
    
    x_after = ix+ux';
    y_after = iy+uy';
    nodes_after = horzcat(x_after, y_after);
    
    % compute element's length
    Res.element_length.before = get_element_length(nodes_before, elements);
    Res.element_length.after = get_element_length(nodes_after, elements);
    
    % compute axial strain by element length
    Res.Lesman.strain.Ax = ...
        Res.element_length.after.polar_y-Res.element_length.before.polar_y...
        ./Res.element_length.before.polar_y;
    Ax = Res.Lesman.strain.Ax;
    Res.Lesman.L_Ax(i) = mean(Ax(~isnan(Ax)));
    L_Ax = Res.Lesman.L_Ax(i);
    
    % compute transversal strain by element length
    Res.Lesman.strain.Trans = ...
        Res.element_length.after.polar_x-Res.element_length.before.polar_x...
        ./Res.element_length.before.polar_x;
    Trans = Res.Lesman.strain.Trans;
    Res.Lesman.L_Trans(i) = mean(Trans(~isnan(Trans)));
    L_Trans = Res.Lesman.L_Trans(i);
    
    % calculate effective Poisson's ratio by element length
    Res.Lesman.EPR(i) = -(L_Trans/L_Ax);
    
    lb = max(nodes_before(:, 1))-min(nodes_before(:, 1));
    wb = max(nodes_before(:, 2))-min(nodes_after(:, 2));
    la = max(nodes_after(:, 1))-min(nodes_after(:, 1));
    wa = max(nodes_after(:, 2))-min(nodes_after(:, 2));
    Res.Bulk.Ax(i) = (wa-wb)/wb; % calculate bulk axial strain
    Bulk_Ax = Res.Bulk.Ax(i);
    Res.Bulk.Trans(i) = (la-lb)/lb; % calculate bulk transversal strain
    Bulk_Trans = Res.Bulk.Trans(i);
    
    % calculate effective Poisson's ratio by bulk dimensions
    Res.Bulk.EPR(i) = -(Bulk_Trans/Bulk_Ax);
    
    % compute average stress
    % max_principle_stress = cell2mat(Res.Ref_Data.Data(i).S_Mises);
    % Avg_s = mean(max_principle_stress);
    % Res.Les.Avg_s(i) = mean(Avg_s);
    
    % Compute apparent strains (Axial and Transversal) - by linear fitting
    J_Ax = polyfit(y', uy, 1);
    Res.fit.Ax.A(i) = J_Ax(1);  % Apparent axial strain
    Res.fit.Ax.B(i) = J_Ax(2);
    
    J_Trans = polyfit(x', ux, 1);
    Res.fit.Trans.A(i) = J_Trans(1); % Apparent transversal strain
    Res.fit.Trans.B(i) = J_Trans(2);
    
    % Calculate the effective Poisson's ratio by linear fitting
    Res.Jacob.EPR(i) = -(J_Trans(1)/J_Ax(1));
    
end

end


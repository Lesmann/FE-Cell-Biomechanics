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
nodes_before = horzcat(ix, iy);

for i = 2 : length(Res.Ref_Data.Data)
    
    ux = cell2mat(Res.Ref_Data.Data(i).U_U1);
    Res.Metadata(i).ux = ux;
    uy = cell2mat(Res.Ref_Data.Data(i).U_U2);
    Res.Metadata(i).uy = uy;
    
    % Compute apparent strains (Axial and Transversal) - by element length
    x_after = ix+ux';
    y_after = iy+uy';
    nodes_after = horzcat(x_after, y_after);
    
    % calculate effective Poisson's ratio by bulk dimensions
    Res = EPRbyBulkDims( Res, nodes_before, nodes_after, i );
    
    % calculate effective Poisson's ratio by element length
    Res = EPRbyElementLength( Res, nodes_before, nodes_after, elements, i );
    
    % Calculate the effective Poisson's ratio by linear fitting
    Res = EPRbyLinearFit( Res, y, uy, x, ux, i );
    
end

end


function [ Res ] = BCE_Analysis( path )

% This function Analyses bulk-control experiments (BCE) models data and
% generates the following graphs according to the BCE Type:
% 1. Poisson's ratio vs. axial strain for uniaxial tension/compression BCEs.
% 2. Normal vs. shear strain for shear loading BCEs.

% read and calculate reference data

Res.Ref_Data = strain2log_stretch_ratio( path );
path2config = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Config.mat';
config = load(path2config);
Res.Config = config.config;
Res.Ugrad.distance_axis = -Res.Config.params.R : Res.Config.regParams.iSeed : Res.Config.params.R;
l = length(Res.Ugrad.distance_axis);

% Read data from path

[ fnames, rawdata ] = rd( path ); % load data from all files in path
Res.FileName = fnames;

for i = 1 : length(fnames)
    
    Res.Ref_Data(i) = strain2log_stretch_ratio( path );
    Res.Data(i) = dd( rawdata(i, :) ); % extract and divide data
    
    U_mat = reshape(Res.Data(i).U_Magnitude, [l, l]); % turn displacement vector into square-matrix
    U1_mat = reshape(Res.Data(i).U_U1, [l, l]); % turn displacement vector into square-matrix
    U2_mat = reshape(Res.Data(i).U_U2, [l, l]); % turn displacement vector into square-matrix
    x_coor = reshape(Res.Ref_Data(i).Nodes(:, 1), [l, l]);
    y_coor = reshape(Res.Ref_Data(i).Nodes(:, 2), [l, l]);
    
    Res.Mat.Data(i).U_mat = cell2mat(U_mat);
    Res.Mat.Data(i).U1_mat = cell2mat(U1_mat);
    Res.Mat.Data(i).U2_mat = cell2mat(U2_mat);
    Res.Mat.Data(i).x_coor = x_coor;
    Res.Mat.Data(i).y_coor = y_coor;
    
    % calculate average of each row and column in displacement matrix 
    Res.Ugrad(i).avg_col = mean(Res.Mat.Data(i).U_mat, 1); % gradient in x
    Res.Ugrad(i).avg_row = mean(Res.Mat.Data(i).U_mat, 2); % gradient in y
    
    % Effective Poisson's Ratio
    Res.Ugrad(i).EPR = Res.Ugrad(i).avg_row'./Res.Ugrad(i).avg_col;
      
end

end


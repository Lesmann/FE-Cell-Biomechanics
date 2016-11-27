% MCCA = Multiple Cell Configuration Analysis

close all
clear all
clc
f=1;

% This script runs the Multiple Cell Configuration analysis algorithm

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\BCE\Data\ShearLoading\';

% Res = Analyse_v2( path );

%% BCE Analysis

Res = BCE_Analysis(path);
fn = strrep(Res.FileName, '_', '-');

figure(f); f=f+1;
hold on
for i = 1 : length(Res.Ugrad)
    E_Notbohm(i) = Notbohm_AvgStrain( Res.Ref_Data(i), Res.Data(i) );
    E_TnS(i) = TnS_AvgStrain(Res.Ref_Data(i), Res.Data(i));
    plot(E_Notbohm(i).tau, E_Notbohm(i).rho);
    plot(E_TnS(i).tau, E_TnS(i).rho);
end
legend(fn)
xlabel('Shear Strain'), ylabel('Normal Strain')
% title('Effective Poisson`s Ratio vs. Axial Strain')
axis tight
hold off

%% Path Analysis

% path2config = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\Config.mat';
% config = load(path2config);
% config = config.config;
% d = config.Cells_Information.Distance_between_Cells*config.params.R;
% geo_range = d/2;
% val_range = 0.1;

% GDP = pathfinder( path, geo_range, val_range );

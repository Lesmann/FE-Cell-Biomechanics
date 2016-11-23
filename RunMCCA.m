% MCCA = Multiple Cell Configuration Analysis

close all
clear all
clc
f=1;

% This script runs the code to analyse Multiple Cell Configuration Models
% According to Jacob's instructions

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\BCE\Data\ShearLoading\';

% Res = Analyse_v2( path );

%% BCE Analysis

Res = BCE_Analysis(path);
fn = strrep(Res.FileName, '_', '-');

figure(f); f=f+1;
hold on
for i = 1 : length(Res.Ugrad)
    x = Res.Ref_Data(i).Nodes(:, 1); % node x coordinates matrix
    y = Res.Ref_Data(i).Nodes(:, 2); % node y coordinates matrix
    
    % Find indices of single center-line nodes 
    scl = y<(Res.config.regParams.iSeed) & y>(-Res.config.regParams.iSeed); 
    
    ux = Res.Data(i).U_U1; % x displacement matrix
    ux = cell2mat(ux);
    uy = Res.Data(i).U_U2; % y displacement matrix
    uy = cell2mat(uy);
    
    yy = y(scl); % y coordinates of nodes on single line at center of network
    xx = x(scl); % x coordinates of nodes on single line at center of network
    
    uxx = ux(scl)'; % x displacement values of single line at center of network
    uyy = uy(scl)'; % y displacement values of single line at center of network
    
    Pxx(i, :) = polyfit(xx, uxx, 1); % Linear-fit on displacement x vs position x
    Pyy(i, :) = polyfit(yy, uyy, 1); % Linear-fit on displacement y vs position y
    
    Prho(i) = (Pxx(i, 1)+Pyy(i, 1))/2; % Average normal strain
    
    Pxy(i, :) = polyfit(xx, uyy, 1); % Linear-fit on displacement y vs position x
    Pyx(i, :) = polyfit(yy, uxx, 1); % Linear-fit on displacement x vs position y
    
    Ptau(i) = (Pyx(i, 1) + Pxy(i, 1))/2; % Average shear strain
    
    rho(:, i) = Prho(i)*xx; % Linear-fit line of average normal strain
    tau(:, i) = Ptau(i)*xx; % Linear-fit line of average shear strain
    
    plot(tau(:, i), rho(:, i));
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

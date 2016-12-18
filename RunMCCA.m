% MCCA = Multiple Cell Configuration Analysis script

close all
clear all
clc
f=1;

% This script runs the Multiple Cell Configuration analysis algorithm

% Res = Analyse_v2( path );

%% BCE Analysis

% Analysis of Shear Loading Simulations

% path = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\BCE\Data\ShearLoading_RuntimeDir\';
% 
% Res = BCE_Analysis(path);
% fn = strrep(Res.FileName, '_', '-');
% 
% figure(f); f=f+1;
% hold on
% for i = 1 : length(Res.Ugrad)
%     E_Notbohm(i) = Notbohm_AvgStrain( Res.Ref_Data(i), Res.Data(i) );
%     plot(E_Notbohm(i).tau, E_Notbohm(i).rho);
% end
% legend(fn)
% xlabel('Shear Strain'), ylabel('Normal Strain')
% title('Normal vs. Shear Strain in Shear Loading Simulation - Notbohm')
% axis tight
% hold off
% 
% figure(f); f=f+1;
% hold on
% for i = 1 : length(Res.Ugrad)
%     E_TnS(i) = TnS_AvgStrain(Res.Ref_Data(i), Res.Data(i));
%     plot(E_TnS(i).TnS.epsilon, E_TnS(i).TnS.linear_fit);
%     % plot(E_TnS(i).Notbohm.epsilon, E_TnS(i).Notbohm.gama);
% end
% legend(fn)
% xlabel('Shear Strain'), ylabel('Normal Strain')
% title('Normal vs. Shear Strain in Shear Loading Simulation - Us')
% axis tight
% hold off

% Analysis of Uniaxial Tension Simulations

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\BCE\Data\Tension_RuntimeDir\';

Res = BCE_Analysis(path);
fn = strrep(Res.FileName, '_', '-');

% figure(f); f=f+1;
% hold on
% for i = 1 : length(Res.Ugrad)
%     E_TnS(i) = TnS_AvgStrain(Res.Ref_Data(i), Res.Data(i));
%     plot(E_TnS(i).TnS.UAT.linfitx, E_TnS(i).TnS.UAT.linfity);
%     % plot(E_TnS(i).Notbohm.epsilon, E_TnS(i).Notbohm.gama);
%     % E_Notbohm(i) = Notbohm_AvgStrain(Res.Ref_Data(i), Res.Data(i));
%     % plot(E_Notbohm(i).xx, E_Notbohm(i).Pois);
%     % plot(E_TnS(i).Notbohm.epsilon, E_TnS(i).Notbohm.gama.);
% end
% legend(fn)
% ylabel('Effective Poisson`s Ratio'), xlabel('Axial Strain')
% title('Effective Poisson`s Ratio vs. Axial Strain in Uniaxial Tension Simulation')
% axis tight
% hold off

figure(f); f=f+1;
hold on
for i = 1 : length(Res.Ugrad)
    E_TnS(i) = TnS_AvgStrain( Res.Ref_Data(i), Res.Data(i) );
    plot(E_TnS(i).axial, E_TnS(i).pois);
end
legend(fn)
ylabel('Effective Poisson`s Ratio'), xlabel('Axial Strain')
title('Effective Poisson`s Ratio vs. Axial Strain in Uniaxial Tension Simulation')
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

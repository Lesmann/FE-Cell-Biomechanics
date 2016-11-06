% MCCA = Multiple Cell Configuration Analysis


close all
clear all
clc
f=1;
% This script runs the code to analyse Multiple Cell Configuration Models

% path = 'E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\Hanan\Hanan_QA\';
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\Data\QA\';

% Res = Analyse_v2( path );

Res = BCE_Analysis(path);
fn = strrep(Res.FileName, '_', '-');

figure(f); f=f+1;
hold on
for i = 1 : length(Res.Ugrad)
    plot(Res.Ugrad(i).avg_row, Res.Ugrad(i).EPR);
end
legend(fn)
xlabel('Axial strain'), ylabel('Effective poisson`s Ratio')
title('Effective Poisson`s Ratio vs. Axial Strain')
hold off

% MCCA = Multiple Cell Configuration Analysis


close all
clear all
clc
% This script runs the code to analyse Multiple Cell Configuration Models

% path = 'E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\Hanan\Hanan_QA\';\
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\Data\QA\';

% Res = Analyse_v2( path );

% LSR = strain2log_stretch_ratio( path );

Res = BCE_Analysis(path);
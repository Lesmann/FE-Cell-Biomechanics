% Function QA Script

clc
close all
f = 1; % figure # 

% gpath = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\DCR\DCR_Field_Outputs\';
% currfile = '2cells_D025_TFBC_BL_C8_R100#1.csv';
% fpath = strcat(gpath, currfile);
% fields = read_fields(fpath);

UT_L_path = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\BCE\Data\QA\L\';
UT_BL_path = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\BCE\Data\QA\BL\';

Res_L = BCE_Analysis(UT_L_path);
Res_BL = BCE_Analysis(UT_BL_path);

figure(f); f = f + 1; 
hold on
plot(sort(Res_L.fit.Ax.A), sort(Res_L.Jacob.EPR), 'r', 'LineWidth', 1.5)
plot(sort(Res_BL.fit.Ax.A), sort(Res_BL.Jacob.EPR), 'b.-', 'LineWidth', 1.5)
xlabel('Axial Strain')
ylabel('Effective Poisson`s ratio')
title('Linear Fitting')
legend('Linear Elastic', 'Bi-linear')
% xlim([0.05 0.5])
% ylim([0 1.2])
hold off

figure(f); f = f + 1; 
hold on
plot(Res_L.Lesman.L_Ax, Res_L.Lesman.EPR, 'r', 'LineWidth', 1.5)
plot(Res_BL.Lesman.L_Ax, Res_BL.Lesman.EPR, 'b.-', 'LineWidth', 1.5)
xlabel('Axial Strain')
ylabel('Effective Poisson`s ratio')
title('Element Length')
legend('Linear Elastic', 'Bi-linear')
% xlim([0.05 0.5])
% ylim([0 1.2])
hold off

figure(f); f = f + 1; 
hold on
plot(sort(Res_L.Bulk.Ax), sort(Res_L.Bulk.EPR), 'r', 'LineWidth', 1.5)
plot(sort(Res_BL.Bulk.Ax), sort(Res_BL.Bulk.EPR), 'b.-', 'LineWidth', 1.5)
xlabel('Axial atrain')
ylabel('Effective Poisson`s ratio')
title('Bulk Dimensions')
legend('Linear Elastic', 'Bi-linear')
% xlim([0.05 0.5])
% ylim([0 1.2])
hold off

% figure(f); f = f + 1;
% hold on
% plot(sort(Res_L.fit.Ax.A), sort(Res_L.Les.Avg_s), 'r', 'LineWidth', 1.5)
% plot(sort(Res_BL.fit.Ax.A), sort(Res_BL.Les.Avg_s), 'b.-', 'LineWidth', 1.5)
% xlabel('Axial Strain')
% ylabel('Stress Mises')
% legend('Linear Elastic', 'Bi-linear')
% xlim([0 0.4])
% hold off
% axis tight

% plot(Res.Lesman.strain.Ax, Res.Lesman.EPR);
% Function QA Script

clc, clear all
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
plot(Res_L.fit.Ax.A, Res_L.Jacob.EPR, 'r', 'LineWidth', 1.5)
plot(Res_BL.fit.Ax.A, Res_BL.Jacob.EPR, 'b.-', 'LineWidth', 1.5)
xlabel('Axial Strain')
ylabel('Effective Poisson`s ratio')
legend('Linear Elastic', 'Bi-linear')
hold off
axis tight

figure(f); f = f + 1;
hold on
plot(sort(Res_L.fit.Ax.A), sort(Res_L.Les.Avg_s), 'r', 'LineWidth', 1.5)
plot(sort(Res_BL.fit.Ax.A), sort(Res_BL.Les.Avg_s), 'b.-', 'LineWidth', 1.5)
xlabel('Axial Strain')
ylabel('Stress Mises')
legend('Linear Elastic', 'Bi-linear')
xlim([0 0.4])
hold off
axis tight

% plot(Res.Lesman.strain.Ax, Res.Lesman.EPR);
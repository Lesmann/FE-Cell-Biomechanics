% Function QA Script

clc

gpath = 'E:\Ran\Cell-ECM_model_2D_1_cell\DataBase\DCR\DCR_Field_Outputs\';
currfile = '2cells_D025_TFBC_BL_C8_R100#1.csv';
fpath = strcat(gpath, currfile);

fields = read_fields(fpath);
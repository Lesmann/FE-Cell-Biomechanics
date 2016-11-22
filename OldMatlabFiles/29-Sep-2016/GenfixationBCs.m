function [ fixationBCs, fixationbcNames ] = GenfixationBCs(oc, N)

l = length(oc);
for i = 1 : l % going through all nodes on the cell's edge in order to assign them with a BC
    if i == 1
        fixationbcNames = strcat('ns', num2str(oc(i)));
        fixationBCs = strcat('** Name: BC', num2str(oc(i)));
        fixationBCs = strcat(fixationBCs, ' Type: Displacement/Rotation\n*Boundary\n');
        fixationBCs = strcat(fixationBCs, 'ns');
        fixationBCs = strcat(fixationBCs, num2str(oc(i)));
        fixationBCs = strcat(fixationBCs, ', 1, 1');
        fixationBCs = strcat(fixationBCs, ' \n');
        fixationBCs = strcat(fixationBCs, 'ns');
        fixationBCs = strcat(fixationBCs, num2str(oc(i)));
        fixationBCs = strcat(fixationBCs, ', 2, 2');
        fixationBCs = strcat(fixationBCs, ' \n');
        fixationbcNames = strcat(fixationbcNames, ', ');
    else
        fixationbcNames = strcat(fixationbcNames, 'ns');
        fixationbcNames = strcat(fixationbcNames, num2str(oc(i)));
        temp = strcat('** Name: BC', num2str(oc(i)));
        temp = strcat(temp, ' Type: Displacement/Rotation\n*Boundary\n');
        temp = strcat(temp, 'ns');
        temp = strcat(temp, num2str(oc(i)));
        temp = strcat(temp, ', 1, 1');
        temp = strcat(temp, ' \n');
        temp = strcat(temp, 'ns');
        temp = strcat(temp, num2str(oc(i)));
        temp = strcat(temp, ', 2, 2');
        temp = strcat(temp, ' \n');
        fixationbcNames = strcat(fixationbcNames, ', ');
        fixationBCs = strcat(fixationBCs, temp);
    end
end


% Write BCs to txt file
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\fixationBCs.txt';
fid = fopen(fn, 'wt');
fprintf(fid, fixationBCs);

% Write fixationbcNames to txt file
fixationbcNames = strrep(fixationbcNames, ',', '\n');
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\fixationbcNames.txt';
fid = fopen(fn, 'wt');
fprintf(fid, fixationbcNames);
fclose('all');
fixationbcNames = textread(fn, '%s');


function [ BCs, bcNames ] = GenBCs (ic, N, config)

% This function uses 'ic' to generate the boundary conditions to 
% be applied on the inner-circle's node-sets

%% Text Pattern
% ** Name: C1 Type: Displacement/Rotation
% *Boundary
% C1, 1, 1, -0.0002617
% C1, 2, 2, -0.002053
%%

l = length(ic);
for i = 1 : l % going through all nodes on the cell's edge in order to assign them with a BC
    coor = N(ic(i), :); % extracting the node (serial number and coordinates)
    % each node will be assigned a BC of displacement equivalent to MOD
    % (0.1) of the cell's radius
    if i == 1
        bcNames = strcat('ns', num2str(ic(i)));
        BCs = strcat('** Name: BC', num2str(ic(i)));
        BCs = strcat(BCs, ' Type: Displacement/Rotation\n*Boundary\n');
        BCs = strcat(BCs, 'ns');
        BCs = strcat(BCs, num2str(ic(i)));
        BCs = strcat(BCs, ', 1, 1, ');        
        BCs = strcat(BCs, num2str(-coor(2)*config.params.MOD)); % x BC
        BCs = strcat(BCs, ' \n');
        BCs = strcat(BCs, 'ns');
        BCs = strcat(BCs, num2str(ic(i)));
        BCs = strcat(BCs, ', 2, 2, ');
        BCs = strcat(BCs, num2str(-coor(3)*config.params.MOD)); % y BC
        BCs = strcat(BCs, ' \n');
        bcNames = strcat(bcNames, ', ');
    else
        bcNames = strcat(bcNames, 'ns');
        bcNames = strcat(bcNames, num2str(ic(i)));
        temp = strcat('** Name: BC', num2str(ic(i)));
        temp = strcat(temp, ' Type: Displacement/Rotation\n*Boundary\n');
        temp = strcat(temp, 'ns');
        temp = strcat(temp, num2str(ic(i)));
        temp = strcat(temp, ', 1, 1, ');
        temp = strcat(temp, num2str(-coor(2)*config.params.r*config.params.MOD)); % x BC
        temp = strcat(temp, ' \n');
        temp = strcat(temp, 'ns');
        temp = strcat(temp, num2str(ic(i)));
        temp = strcat(temp, ', 2, 2, ');
        temp = strcat(temp, num2str(-coor(3)*config.params.r*config.params.MOD)); % y BC
        temp = strcat(temp, ' \n');
        bcNames = strcat(bcNames, ', ');
        BCs = strcat(BCs, temp);
    end
end

% Write BCs to txt file
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\BCs.txt';
fid = fopen(fn, 'wt');
fprintf(fid, BCs);

% Write bcNames to txt file
bcNames = strrep(bcNames, ',', '\n');
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\bcNames.txt';
fid = fopen(fn, 'wt');
fprintf(fid, bcNames);
fclose('all');
bcNames = textread(fn, '%s');


end


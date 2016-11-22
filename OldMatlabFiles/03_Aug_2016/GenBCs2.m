function [ BCs, bcNames ] = GenBCs2 (ic, N, config)

% This function uses 'ic' to generate the boundary conditions to
% be applied on the inner-circles' node sets

% ic = nodes of inclusion (column 1: number of the cell, column 2: number
% of the node)
% N = Nodes vector
% r = inner radius
% iSeed = Meshing interval

% Add-Ons: Cases in which the inner circle
% is not at the origin are taken care of.

%% Text Pattern
% ** Name: C1 Type: Displacement/Rotation
% *Boundary
% C1, 1, 1, -0.0002617
% C1, 2, 2, -0.002053
%%

l = length(ic);
lpts = length(config.cells);

for j = 1 : lpts % going through all cells
    for i = 1: l % going through all nodes on the cells' edges in order to assign them with a BC
        coor = N(ic(i,2), :); % extracting the node (serial number and coordinates)
        p = config.cells(j, :); % extracting the coordiantes of the centre of the current cell
        d = sqrt((coor(2)-p(1))^2+(coor(3)-p(2))^2); % the distance between the current node and cell
        inc = abs(config.params.r-d);
        if i == 1 && inc < config.params.iSeed
            bcNames = strcat('ns', num2str(ic(i)));
            BCs = strcat('** Name: BC', num2str(ic(i)));
            BCs = strcat(BCs, ' Type: Displacement/Rotation\n*Boundary\n');
            BCs = strcat(BCs, 'ns');
            BCs = strcat(BCs, num2str(ic(i)));
            BCs = strcat(BCs, ', 1, 1, ');
            BCs = strcat(BCs, num2str((p(1)-coor(2))*config.params.MOD));
            BCs = strcat(BCs, ' \n');
            BCs = strcat(BCs, 'ns');
            BCs = strcat(BCs, num2str(ic(i)));
            BCs = strcat(BCs, ', 2, 2, ');
            BCs = strcat(BCs, num2str((p(2)-coor(3))*config.params.MOD));
            BCs = strcat(BCs, ' \n');
            bcNames = strcat(bcNames, ', ');
        else if inc < iSeed
                bcNames = strcat(bcNames, 'ns');
                bcNames = strcat(bcNames, num2str(ic(i)));
                temp = strcat('** Name: BC', num2str(ic(i)));
                temp = strcat(temp, ' Type: Displacement/Rotation\n*Boundary\n');
                temp = strcat(temp, 'ns');
                temp = strcat(temp, num2str(ic(i)));
                temp = strcat(temp, ', 1, 1, ');
                temp = strcat(temp, num2str((p(1)-coor(2))*config.params.MOD));
                temp = strcat(temp, ' \n');
                temp = strcat(temp, 'ns');
                temp = strcat(temp, num2str(ic(i)));
                temp = strcat(temp, ', 2, 2, ');
                temp = strcat(temp, num2str((p(2)-coor(3))*config.params.MOD));
                temp = strcat(temp, ' \n');
                bcNames = strcat(bcNames, ', ');
                BCs = strcat(BCs, temp);
            end
        end
    end
end

% Write BCs to txt file
fn = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\BCs.txt';
fid = fopen(fn, 'wt');
fprintf(fid, BCs);

% Write bcNames to txt file
bcNames = strrep(bcNames, ',', '\n');
fn = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\bcNames.txt';
fid = fopen(fn, 'wt');
fprintf(fid, bcNames);
fclose('all');
bcNames = textread(fn, '%s');

end


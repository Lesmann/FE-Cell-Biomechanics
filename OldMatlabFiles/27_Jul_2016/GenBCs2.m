function [ BCs, bcNames ] = GenBCs2(ic, N, config)

% This function uses 'ic' to generate the boundary conditions to
% be applied on the inner-circle's node-sets

% ic = nodes of inclusion
% N = Nodes vector
% D = u/r relation
% pts = vector of center points of each inclusion
% r = inner radius
% iSeed = % Meshing interval

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

for i = 1 : l
    for j = 1 : lpts
        coor = N(ic(i), :);
        p = config.cells(j, :);
        d = sqrt((coor(2)-p(1))^2+(coor(3)-p(2))^2);
        inc = abs(r-d);
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
fn = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\BCs.txt';
fid = fopen(fn, 'wt');
fprintf(fid, BCs);

% Write bcNames to txt file
bcNames = strrep(bcNames, ',', '\n');
fn = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\bcNames.txt';
fid = fopen(fn, 'wt');
fprintf(fid, bcNames);
fclose('all');
bcNames = textread(fn, '%s');

end


function [ Loads ] = GenLoads2 ( ic, pts )

% This function gets the following input:

% ic = vector of nodes of inclusion
% pts = vector of center points of each inclusion

% s = vector of stress product of a simulation in which displacement BCs
% was applied.

% {in order to get this vector, run your model and export a report of stress
% components field output file. then run the function getst to get the
% compatible vector}

% Add-Ons: Cases in which the inner circle
% is not at the origin are taken care of.

% Force-Displacement relation:
% {assuming that A=1 is the cross sectional area of the truss defined by Abaqus}
% F = E*u/(r*L)
% L = sqrt(2)*iSeed is the truss length

%% Text Pattern

% ** Name: 'name of load'   Type: Concentrated force
% *Cload
% 'name of set', 'Fx', 'Fy'
%%

l = length(ic);
lpts = length(pts);
if lpts == 0
    lpts = 1;
end
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\rftest.rpt';
rf = getst(fn);
format short

for i = 1 : l
    for j = 1 : lpts
        F = rf(ic(i), :); % extracting the force applied to the current node on the cell's edge
        Fx = F(2); Fy = F(3);
        if i == 1
            lNames = strcat('ns', num2str(ic(i)));
            Loads = strcat('** Name: Load-', num2str(ic(i)));
            Loads = strcat(Loads, ' Type: Concentrated force\n*Cload\n');
            
            Loads = strcat(Loads, 'intper');
            Loads = strcat(Loads, num2str(ic(i)));
            Loads = strcat(Loads, ', 1, ');
            % define a load (in direction x) at the relevant node proportional to the applied displacement
            Loads = strcat(Loads, num2str(Fx)*(-1)); 
            Loads = strcat(Loads, ' \n');
            
            Loads = strcat(Loads, 'ns');
            Loads = strcat(Loads, num2str(ic(i)));
            Loads = strcat(Loads, ', 2, ');
            % define a load (in direction y) at the relevant node proportional to the applied displacement
            Loads = strcat(Loads, num2str(Fy)*(-1));
            Loads = strcat(Loads, ' \n');
            
            lNames = strcat(lNames, ', ');
            
        else
            lNames = strcat(lNames, 'ns');
            lNames = strcat(lNames, num2str(ic(i)));
            temp = strcat('** Name: Load-', num2str(ic(i)));
            temp = strcat(temp, ' Type: Concentrated force\n*Cload\n');
            
            temp = strcat(temp, 'ns');
            temp = strcat(temp, num2str(ic(i)));
            temp = strcat(temp, ', 1, ');
            temp = strcat(temp, num2str(Fx)*(-1));
            temp = strcat(temp, ' \n');
            
            temp = strcat(temp, 'ns');
            temp = strcat(temp, num2str(ic(i)));
            temp = strcat(temp, ', 2, ');
            temp = strcat(temp, num2str(Fy)*(-1));
            temp = strcat(temp, ' \n');
            
            lNames = strcat(lNames, ', ');
            Loads = strcat(Loads, temp);
        end
    end
end

% Write Loads to txt file
% fn = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\Loads.txt';
% fid = fopen(fn, 'wt');
% fprintf(fid, Loads);

% Write bcNames to txt file
lNames = strrep(lNames, ',', '\n');
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\lNames.txt';
fid = fopen(fn, 'wt');
fprintf(fid, lNames);
fclose('all');
end


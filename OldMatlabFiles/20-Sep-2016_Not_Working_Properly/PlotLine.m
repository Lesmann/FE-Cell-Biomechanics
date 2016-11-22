% this script plots the magnitude of a chosen attribute (stress or displacement) on a straight line
% across 2 cells in a 2-cell model.

close all, clc, clear all
f=1;

% 1. read data
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\2cells4poster\Results4Poster\';

mat = input('Linaer Elastic (L)/ Bi-Linear (BL)/ BL vs. L (VS)? ', 's');

mat = strcat(mat, '\');
path = strcat(path, mat);

cont = dir(path);
k=1;
for i = 1 : length(cont)
    if ~cont(i).isdir == 1
        files{k} = cont(i).name;
        k=k+1;
    end
end

csv_path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
csvfile = 'nodes.csv';
csvpath = strcat(csv_path, csvfile);
nodes = fileread(csvpath);
nodes = strsplit(nodes, '\n');

nodes_sorted = struct('serial', 0);
for i = 1 : length(nodes)-1
    node = nodes{i};
    node = strsplit(node, ',');
    nodes_sorted.serial(i) = str2double(node{1});
    nodes_sorted.x(i) = str2double(node{2});
    nodes_sorted.y(i) = str2double(node{3});
end

data = struct('filename', '');
kbl=1;
kl=1;

for j = 1 : length(files)
    
    file = files{j};
    fp = strcat(path, file);
    rawdata = fileread(fp);
    
    rawdata = strsplit(rawdata, '-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------');
    rawdata = rawdata{2};
    rawdata = strsplit(rawdata, '\n');
    rawdata = rawdata(:, 2:end-19);
    
    filename = strrep(file, '.rpt', '');
    data(j).filename = filename;
    
    for i = 1 : length(rawdata)
        
        rowdata = rawdata{i};
        rowdata = strsplit(rowdata, '   ');
        data(j).node(i) = str2double(rowdata{2});
        data(j).Umag(i) = str2double(rowdata{3});
        data(j).U1(i) = str2double(rowdata{4});
        data(j).U2(i) = str2double(rowdata{5});
        data(j).LE_max_p(i) = str2double(rowdata{6});
        data(j).LE_max_p_a(i) = str2double(rowdata{7});
        data(j).LE_min_p(i) = str2double(rowdata{8});
        data(j).LE_max_prin(i) = str2double(rowdata{9});
        data(j).LE_max_Prin_a(i) = str2double(rowdata{10});
        data(j).LE_min_prin(i) = str2double(rowdata{11});
        data(j).LE_11(i) = str2double(rowdata{12});
        data(j).s_Mises(i) = str2double(rowdata{13});
        data(j).s_max_in_p(i) = str2double(rowdata{14});
        data(j).s_max_in_P_a(i) = str2double(rowdata{15});
        data(j).s_min_in_P(i) = str2double(rowdata{16});
        data(j).s_max_Prin(i) = str2double(rowdata{17});
        data(j).s_max_Prin_a(i) = str2double(rowdata{18});
        data(j).s_min_Prin_a(i) = str2double(rowdata{19});
        data(j).s_Tresca(i) = str2double(rowdata{20});
        data(j).s_pressure(i) = str2double(rowdata{21});
        data(j).s_third_inv(i) = str2double(rowdata{22});
        data(j).s_s11 = str2double(rowdata{23});
    end
    
    % 2. find nodes on line
    seed = nodes_sorted.x(2)-nodes_sorted.x(1);
    maxx = max(nodes_sorted.x);
    maxy = max(nodes_sorted.y);
    minx = min(nodes_sorted.x);
    miny = min(nodes_sorted.y);
    
    % get x index of where LOI begins
    xindx = find(ismember(nodes_sorted.x, minx));
    
    % get y index of where LOI begins and ends
    middle_y = (miny + maxy)/2;
    yindx = find(ismember(nodes_sorted.y, middle_y));
    
    begin_indx = yindx(ismember(yindx, xindx));
    x4graph = minx : seed : maxx;
    end_indx = begin_indx+length(x4graph)-1;
    
    LOI = begin_indx : end_indx;
    if strcmp(mat, 'VS\');
        if strfind(filename, 'BL')
            BL_Umag(:, kbl) = data(j).Umag(LOI);
            BL_s_Mises(:, kbl) = data(j).s_Mises(LOI);
            BL_LE_max(:, kbl) = data(j).LE_max_p(LOI);
            kbl=kbl+1;
        else
            L_Umag(:, kl) = data(j).Umag(LOI);
            L_s_Mises(:, kl) = data(j).s_Mises(LOI);
            BL_LE_max(:, kl) = data(j).LE_max_p(LOI);
            kl=kl+1;
        end
    else
        Umag(:, j) = data(j).Umag(LOI);
        s_Mises(:, j) = data(j).s_Mises(LOI);
    end
    
    % extract connectivity out of file name
    
    C = strfind(filename, '_C');
    R = strfind(filename, '_R');
    Con{j} = filename(C+2:R-1);
    
    if strfind(filename, 'TFBC')
        BC{j} = strcat(Con{j}, ', Traction Free Boundary');
    else
        BC{j} = strcat(Con{j}, ', Fixed Boundary');    
    end
    
    if strfind(filename, 'BL')
        Con{j} = strcat(Con{j}, '-Bi-Linear');
    else
        Con{j} = strcat(Con{j}, '-Linear');
    end
    
    
end

Con{j} = strcat('Connectivity=', Con{j});
Con = strcat(Con, BC);

figure(f); f=f+1;
hold on

scatter(nodes_sorted.x, nodes_sorted.y, '.');
scatter(nodes_sorted.x(:, LOI), nodes_sorted.y(:, LOI), '.');
title('Sampled Nodes')

hold off

figure(f); f=f+1;
hold on
% plot(x4graph, L_Umag, '-*', 'LineWidth', 3);
plot(x4graph, BL_Umag, '-', 'LineWidth', 3);
hold off
xlabel('Distance (mm)'), ylabel('Displacement')
legend(Con)
title('Displacement Magnitude on Line of Interest')
set(gca, 'fontsize', 15)
hold off

figure(f); f=f+1;
hold on
% plot(x4graph, L_s_Mises, '-*', 'LineWidth', 3);
plot(x4graph, BL_s_Mises, '-', 'LineWidth', 3);
hold off
xlabel('Distance (mm)'), ylabel('Stress')
legend(Con)
title('Von-Mises on Line of Interest')
hold off
set(gca, 'fontsize', 15)

figure(f); f=f+1;
hold on
% plot(x4graph, L_LE_max_p, '-*', 'LineWidth', 3);
plot(x4graph, BL_LE_max, '-', 'LineWidth', 3);
hold off
xlabel('Distance (mm)'), ylabel('Strain')
legend(Con)
title('Tensional Strain on Line of Interest')
hold off
set(gca, 'fontsize', 15)
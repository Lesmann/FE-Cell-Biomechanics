function [ Res ] = strain2log_stretch_ratio( path )

% This function returns the logaritm of the stretch ratio (LSR) where:
% LSR = log(initial length of element)/(final length of element)

% path = path to data files from which Nf will be extracted.

ArchivePath = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\';
Npath = strcat(ArchivePath, 'nodes.csv');
Epath = strcat(ArchivePath, 'elements.csv');
Ni = csvread(Npath);
E = csvread(Epath);

Ni = Ni(:, 2:3);
E = E(:, 2:3);

% calculate initial element length

for i = 1 : length(E)
    curr_el = E(i, :);
    N1 = Ni(curr_el(1), :); N2 = Ni(curr_el(2), :);
    Lix = N2(1) - N1(1); Liy = N2(2) - N1(2);
    Li(i) = sqrt(Lix^2+Liy^2);
end 

[fnames, rawdata] = rd(path); % load data from all files in path


for i = 1 : length(fnames)
    
    data(i) = dd( rawdata(i, :) ); % extract displacement data from rawdata
    
    % calculate final element length for each data-set
Nfx = Ni(:, 1)' + cell2mat(data(i).U_U1);
Nfy = Ni(:, 2)' + cell2mat(data(i).U_U2);

    
    for j = 1 : length(E)
    curr_el = E(j, :);
    Nx1 = Nfx(curr_el(1)); Ny1 = Nfy(curr_el(1));
    Nx2 = Nfx(curr_el(2)); Ny2 = Nfy(curr_el(2));
    
    Lfx = Nx2 - Nx1; Liy = Ny2 - Ny1;
    Lf(j) = sqrt(Lfx^2+Liy^2);
    end
end     

Res.LSR = log(Lf./Li);
Res.Li = Li;
Res.Lf = Lf;
Res.Elements = E;
Res.Nodes = Ni;

end


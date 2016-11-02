function [ LSR ] = strain2log_stretch_ratio( path )

% still debugging...

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
[ ~, Ux, Uy ] = dd( rawdata ); % extract displacement data from rawdata

% calculate final element length for each data-set
Nfx = Ni(:, 1)' + Ux;
Nfy = Ni(:, 2)' + Uy;

for i = 1 : length(fnames)
    
    for j = 1 : length(E)
    curr_el = E(j, :);
    Nx1 = Nfx(curr_el(1)); Ny1 = Nfy(curr_el(1));
    Nx2 = Nfx(curr_el(2)); Ny2 = Nfy(curr_el(2));
    
    Lfx = Nx2 - Nx1; Liy = Ny2 - Ny1;
    Lf(i) = sqrt(Lfx^2+Liy^2);
    end
end     

LSR = log(Lf./Li);

end

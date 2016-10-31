function [ LSR ] = strain2log_stretch_ratio( path, E, Ni )

% This function returns the logaritm of the stretch ratio (LSR) where:
% LSR = log(initial length of element)/(final length of element)

% path = the path to data files from which Nf will be extracted.
% E = list of elements
% Ni = list of nodes and their initial location.

Ni = Ni(:, 2:3);
Nix = Ni(:, 1);
Niy = Ni(:, 2);
E = E(:, 2:3);

% calculate initial element length

for i = 1 : length(E)
    curr_el = E(:, i);
    N1 = Ni(curr_el(1), :); N2 = Ni(curr_el(2), :);
    Lix = N2(1) - N1(1); Liy = N2(2) - N1(2);
    Li(i) = sqrt(Lix^2+Liy^2);
end 

[fnames, rawdata] = rd(path); % load data from all files in path
[ ~, Ux, Uy ] = dd( rawdata ); % extract displacement data from rawdata

    % calculate final element length for each data-set

for i = 1 : length(fnames)
    
    Lfx = Nix + Ux(:, i);
    Lfy = Niy + Uy(:, i);
    Lf = sqrt(Lfx.^2+Lfy.^2);    
   
end

LSR = log(Lf./Li);

end


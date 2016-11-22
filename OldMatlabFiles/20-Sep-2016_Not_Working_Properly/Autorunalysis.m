function [ mUr ] = Autorunalysis( path )

% This function analyses displacement field data to display a normalized
% U(r) plots for all csv files found in path

f=2;

% Generate U(r) plots

tic

display(['processing data stack found in path: ', path, '...'])

fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\nodes.csv';
pts = [0, 0];

config_path = 'E:\Ran\Cell-ECM_model_2D_1_cell\LastConfig\config.mat';
config = load(config_path);

sq = config.regParams.sq; % Square dimension
D = sq; % Diameter of outer circle
d = D/50; % Diameter of inner circle
R = D/2; % Radius of outer circle (change this value if you want to avg over a smaller radius)
r = d/2; % Radius of inner circle
nodes = csvread(fn); % Read nodes from path
nodes = nodes(:, 2:3); % discard node index
ang = [0, 360]*pi/180; % 0 < ang1,2 < 360
n=35;
dr = (R-r)/n; % degree-interval for averaging

% 1. get displacements and original nodes of required POC
% [ indx, Ur, U1r, U2r, pnodes ] = UrPOC(path, nodes, pts, R, r, ang);

% 2. read data (all files in directory) from 'path'

[fnames, rawdata] = rd(path);
% rawdata = fileread(fp);

% 3. divide 'rawdata' (for each file) into 3 vectors

[ Ur, ~, ~ ] = extract_data( rawdata );

% 4. calculate radial average of U in intervals of 'itvl'

[ mUr ] = avgUr( nodes, Ur, pts, r, R, ang, n );

t = toc;
display(['elasped time: ', num2str(t/60), ' minutes'])

% 5. Display U(r)

[lu, ~] = size(Ur);
if lu > 10
    
    v1 = 1 : 2 : lu;
    v2 = 2 : 2 : lu-1;
    mUr1 = mUr(v1, :);
    mUr2 = mUr(v2, :);
    f1 = fnames(v1);
    f2 = fnames(v2);
    
    C1 = 0;
    C2 = 0;
    [ f, ~, ~, ~, r, LF1 ] = DispUr( R/r, r/r, n, mUr1/r, f1, f );
    
    for j = 1 : length(f1)
        
        fnc = f1{j};
        Ri = strfind(fnc, 'R');
        Ci = strfind(fnc, 'C');
        C1(j) = str2double(fnc(Ci+1:Ri-1));
        if C1(j) > 10
            C1(j) = C1(j)/10;
        end
    end
    
    [ f, ~, ~, ~, ~, LF2 ] = DispUr( R/r, r/r, n, mUr2/r, f2, f );
    
    for j = 1 : length(f2)
        
        fnc = f2{j};
        Ri = strfind(fnc, 'R');
        Ci = strfind(fnc, 'C');
        C2(j) = str2double(fnc(Ci+1:Ri-1));
        if C1(j) > 10
            C1(j) = C1(j)/10;
        end
        
    end
    
    figure(f), f=f+1;
    hold on
    plot(C1, abs(LF1), 's', 'MarkerSize', 8, 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
    plot(C2, abs(LF2), 's', 'MarkerSize', 8, 'MarkerFaceColor', 'black', 'MarkerEdgeColor', 'black');
    xlabel('Connectivity, C', 'FontSize', 16), ylabel('Power, n', 'FontSize', 16)
    grid on
    hold off
    
    
else
    
    C = 0;
    [ f, ~, ~, ~, ~, LF ] = DispUr( R/r, r/r, n, mUr/r, fnames, f );
    for j = 1 : length(fnames)
        
        fnc = fnames{j};
        Ri = strfind(fnc, 'R');
        Ci = strfind(fnc, 'C');
        C(j) = str2double(fnc(Ci+1:Ri-1));
        if C(j) > 10
            C(j) = C(j)/10;
        end
        
    end
    
    figure(f), f=f+1;
    plot(C, abs(LF), 's', 'MarkerSize', 8, 'MarkerFaceColor', 'black');
    xlabel('Connectivity, C', 'FontSize', 16), ylabel('Power, n', 'FontSize', 16)
    grid on
    
end

end
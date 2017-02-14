function [ BCs_str, m_BCs, inp ] = multiply_BCs_by( times, file )

% This function reads the boundary condition txt file currently exist in the csv file
% library and multiplies it by the input argument 'times'

kbc=1;
kt=1;

% read old bcs from path
path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\BCs.txt';
bcs = fileread(path);

% turn bcs string into cell array
bcs = strsplit(bcs, '\n');
for i = 1 : length(bcs)
   if isempty(strfind(bcs{i}, '*'))
       isbc(kbc) = i;
       kbc=kbc+1;
   else
       istitle(kt) = i;
       kt=kt+1;
   end
end

% blank old bcs
sorted_BCs = bcs;
sorted_BCs(isbc) = {'blnk'};
bcs = bcs(isbc);

for i = 1 :length(bcs)-1
    
    % change bcs value according to 'times'
    bcs{i} = strsplit(bcs{i}, ',');
    vals(i) = str2double(bcs{i}(4));
    m_val = num2str(vals(i)*times);
    BCs{i} = bcs{i};
    BCs{i}{4} = m_val;
    
    % reconstruct bc strings
    m_BCs{i} = [BCs{i}{1}, ', ' BCs{i}{2}, ', ', BCs{i}{3}, ', ', BCs{i}{4}];
    
end

% insert reconstructed string into original bcs string
sorted_BCs(isbc(1:end-1)) = m_BCs;
for i = 1 : length(sorted_BCs)-1
    if i == 1
        BCs_str = strcat(sorted_BCs{i}, sorted_BCs{i+1});
        BCs_str = strcat(BCs_str, '\n');
    else
        BCs_str = strcat(BCs_str, sorted_BCs{i+1});
        BCs_str = strcat(BCs_str, '\n');
    end
end

% save new BCs string to txt file
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\m_BCs.txt';
fid = fopen(fn, 'wt');
fprintf(fid, BCs_str);

fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\';
fn = strcat(fn, file);
inp = fileread(fn);
str1 = '** BOUNDARY CONDITIONS';
str2 = '** LOADS';
inp = Splt_n_Push( fn, inp, BCs_str, str1, str2 );
RemBlnkLines(fn)
    
end


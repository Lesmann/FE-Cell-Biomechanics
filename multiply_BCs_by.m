function [ m_BCs ] = multiply_BCs_by( times )

% This function reads the boundary condition txt file currently exist in the csv file
% library and multiplies it by the input argument 'times'

kbc=1;
kt=1;

path = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\BCs.txt';
bcs = fileread(path);

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

bcs = bcs(isbc);

for i = 1 :length(bcs)-1
    bcs{i} = strsplit(bcs{i}, ',');
    vals(i) = str2double(bcs{i}(4));
    m_val = num2str(vals(i)*times);
    m_BCs{i} = bcs{i};
    m_BCs{i}{4} = m_val;
end

end


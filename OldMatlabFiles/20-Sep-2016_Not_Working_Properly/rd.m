function [files, data] = rd(path)

% This function reads data from all .rpt files
% found in 'path' into 'rawdata'
k=0;
list = dir(path);

for i = 1 : length(list)
    % Ignore irrelevant files
    iscsv = strfind(list(i).name, '.csv');
    isrpt = strfind(list(i).name, '.rpt');
    if list(i).isdir || isempty(iscsv) && isempty(isrpt)
        k=k+1;
        continue;
    end
    
    if ~isempty(iscsv)
        fileType = 'csv';
    else
        fileType = 'rpt';
    end
    
    % Get current file name
    filename = list(i).name;
    files{i-k} = strrep(filename, '.csv', '');
    files{i-k} = strrep(filename, '.rpt', '');
    files{i-k} = strrep(files{i-k}, '_U', '');
    fn = strcat(path, filename);
    
    % Read rawdata from currrent file
    
    rdata = fileread(fn);
    
    % 2. get data from raw-data:
    rdata = rdr(rdata, fileType);
    
    data(i-k, :) = rdata;
    
end

end


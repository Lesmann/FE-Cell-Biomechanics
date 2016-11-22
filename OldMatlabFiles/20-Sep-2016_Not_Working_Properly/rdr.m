function data = rdr(rawdata, fileType)

% This function gets the relevant 'data' from 'rawdata'

% Get relavant data
data = strsplit(rawdata, '\n');

frames = strsplit(rawdata, '-------------------------------------');
data = frames(end);
data = data{:};
data = strsplit(data, '\n');
data{1} = []; % delete empty line
data = data(~cellfun('isempty',data)); % remove empty line cells

if strcmp(fileType, 'csv')
    data = data(1 : end-4);
else
    data = data(1 : end-12);
end

end


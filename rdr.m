function data = rdr(rawdata, fileType)

% This function gets the relevant 'data' from 'rawdata'

% Get relavant data
data = strsplit(rawdata, '\n');
if strcmp(fileType, 'csv')
    data = data(44 : end-4);
else
    data = data(20 : end-12);
end

end


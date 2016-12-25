function fields = read_fields(fpath)

% This function reads the field-output csv files retrieved from Abaqus
% This function returns a structure contaning all relevant fields (in `unique-nodal` configuration).

raw = fileread(fpath);
raw = strsplit(raw, '  -------------------------------------');

last_raw = raw{end};
last_raw = strsplit(last_raw, '\n');

raw_data = last_raw(19:end);
lrd = length(raw_data);
titles = strsplit(raw_data{1}, ', ');
lt = length(titles);

for i = 2 : lrd-4
    curr_row = raw_data{i};
    curr_row = strsplit(curr_row, ', ');
    for j = 1 : lt
        field_name = strparse(titles{j}, 'f');
        field_val = strparse(curr_row{j}, 'v');
        try
            fields.(field_name){i-1} = str2double(field_val);
        catch exc
            fields.(field_name){i-1} = field_val;
        end
    end
end

fnames = fieldnames(fields);
lfn = length(fnames);
for i = 6 : lfn
    fieldname = fnames{i};
    field = fields.(fieldname);
    try
        fields.(fieldname) = cell2mat(field);
    catch exc
        continue;
    end
end

end


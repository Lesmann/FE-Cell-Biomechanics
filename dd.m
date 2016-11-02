function [ data ] = dd( rawdata )

[l, w] = size(rawdata);
raw = rawdata{1, 1};
titles = strsplit(raw, '   ');
titles(isempty(titles)) = [];
titles = strtrim(titles);

for i = 1 : l
    for j = 4 : w
        raw = rawdata{i, j};
        row = strsplit(raw, '   ');
        row = strtrim(row);
        row(isempty(row)) = [];
        for k = 2 : length(row)-2
            fieldname = titles{k};
            fieldname = strrep(fieldname, ' ', '');
            fieldname = strrep(fieldname, '.', '_');
            fieldname = strrep(fieldname, '-', '_');
            fieldname = strrep(fieldname, '(', '');
            fieldname = strrep(fieldname, ')', '');
            fieldname = strrep(fieldname, '\n', '');
            fieldname = strrep(fieldname, '\b', '');
            fieldname = strrep(fieldname, '\r', '');
            data.(fieldname){j-3} = str2double(row{k});
        end
    end
end

end


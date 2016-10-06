function [] = RemBlnkLines( fn )

fid = fopen(fn, 'r');
if fid < 0, error('Cannot open file: %s', fn); end
Data = textscan(fid, '%s', 'delimiter', '\n', 'whitespace', '');
fclose(fid);

% Remove empty lines:
% C = deblank(Data{:}); % [EDITED]: deblank added
C = Data{:};
C(cellfun(@isempty, C)) = [];

% Write the cell string:
fid = fopen(fn, 'w');
if fid < 0, error('Cannot open file: %s', fn); end
fprintf(fid, '%s\n', C{:});
fclose(fid);

end


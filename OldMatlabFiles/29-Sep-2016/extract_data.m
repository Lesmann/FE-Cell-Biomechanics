function [ U, U1, U2 ] = extract_data( rawdata )

% this function extracts relevant displacement data out of the Abaqus-generated csv
% report files
[l, w] = size(rawdata);

for i = 1 : l
    data = rawdata(i, :);
    for j = 1 : w
        crow = data{j};
        crow = strrep(crow, ' ', '');
        crow = strsplit(crow, ',');
        U1(i, j) = str2double(crow(3));
        U2(i, j) = str2double(crow(4));
        U(i, j) = sqrt(U1(i, j)^2+U2(i, j)^2);
    end
end

end


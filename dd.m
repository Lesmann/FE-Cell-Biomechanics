function [ Ur, U1r, U2r ] = dd( rawdata )

[l, w] = size(rawdata);
for i = 1 : l
    for j = 1 : w
        raw = rawdata{i, j};
        row = strsplit(raw, '   ');
        U(i, j, :) = row(:, 3:5);
    end
    Ur(i, :) = U(i, :, 1);
    U1r(i, :) = U(i, :, 2);
    U2r(i, :) = U(i, :, 3);
end

Ur = str2double(Ur);
U1r = str2double(U1r);
U2r = str2double(U2r);

end


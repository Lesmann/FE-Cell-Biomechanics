function [ newEl ] = ROD ( oldEl, oldNodes )

% This function gets nodes and elements vector and returns a filtered
% elements vector in which no over-defined exist

El = oldEl(:, 2:3); % Get elements as defined by the nodes between which they extend (as defined by their serial numbers)
nodeInd = oldNodes(:, 1); % Get nodes indices

[flg, ~] = ismember(El, nodeInd); % Find indexes of over-defined elements
if any(any(flg == 0))
    flg = flg(:,1).*flg(:, 2);
    [rows, ~] = find(flg==0);
    El(rows, :) = []; % Remove elements
    serial = 1 : length(El);
    newEl = horzcat(serial', El); % Recreate element vector
else
    serial = 1 : length(El);
    newEl = horzcat(serial', El); % Recreate element vector
end

end


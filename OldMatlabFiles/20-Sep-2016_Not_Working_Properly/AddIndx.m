function newv = AddIndx ( v )

% This function gets a vector 'v' and adds an index vector to a new vector 'newv'
format long g
serial = 1 : length(v);
newv= horzcat(serial', v); % Create nodes vector

end


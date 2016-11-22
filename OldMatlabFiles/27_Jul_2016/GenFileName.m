function FN = GenFileName(ror, LOC, withCells)

% This function gets the main model parameters (connectivity, randomness and NBN - see comments in the main script)
% to generate the characteristic file name.
% note that the files already exist in destination directory and 
% that the model generated is based on the abaqus (python input, inp) file.

strC = num2str(8*LOC); % prepare Connectivity string for inp file name
strC = strrep(strC, '.', '');
strR = strrep(num2str(ror), '.', ''); % prepare Randomness string for inp file name
if ror == 1 || ror == 0
    strR = strcat(strR, '00');
end
FN = strcat('C', strC);
FN = strcat(FN, 'R');
FN = strcat(FN, strR);
FN = strcat(FN, '.inp');
FN = strcat('1cell', FN);
% if strcmp(withCells, 'no')
%     FN = strcat('BCE_', FN);
% end

end


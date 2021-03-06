function FN = GenFileName ( ror, LOC, withCells, numofCells, modeltype, material_linearity )

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
strModeltype = num2str(modeltype);
FN = strcat('C', strC);
FN = strcat(FN, '_R');
FN = strcat(FN, strR);
FN = strcat(FN, '.inp');
if material_linearity == 'bi-linear'
    strLinearity = 'BL';
elseif material_linearity == 'linear'
    strLinearity = 'L';
end
FN = strcat(strLinearity,'_', FN);
FN = strcat(strModeltype,'_', FN);
if withCells == 'yes' & isempty(numofCells)
    strnumofCells = '1cell';
end    
FN = strcat(strnumofCells,'_', FN);
% if strcmp(withCells, 'no')
%     FN = strcat('BCE_', FN);
% end

end


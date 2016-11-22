function newfile = GenFileName ( ror, LOC, withCells, numofCells, modeltype, material_linearity )

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
newfile = strcat('C', strC);
newfile = strcat(newfile, '_R');
newfile = strcat(newfile, strR);
newfile = strcat(newfile, '.inp');
if strcmp(material_linearity, 'bi-linear')
    strLinearity = 'BL';
elseif strcmp(material_linearity, 'linear')
    strLinearity = 'L';
end
newfile = strcat(strLinearity,'_', newfile);
newfile = strcat(strModeltype,'_', newfile);
if strcmp(withCells, 'yes')
    if isempty(numofCells)
        strnumofCells = '1cell';
    else
        numofCells=length(numofCells);
        strnumofCells=strcat(num2str(numofCells),'cells');
    end
end    
newfile = strcat(strnumofCells,'_', newfile);

dummyfile = 'DoNotDelete.inp';
base = 'E:\Ran\Cell-ECM_model_2D_1_cell\';

source = strcat(base, 'dummy_model_Do_Not_Delete!!\');
source = strcat(source, dummyfile);

dest = strcat(base, '2cells4poster_20-09\');
dest = strcat(dest, newfile);

fopen(dest, 'wt');
copyfile(source, dest);
fclose('all');

end


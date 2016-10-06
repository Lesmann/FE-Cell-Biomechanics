function BCE_BCs = GenBC4Shear(nBCE, N, config)

% This function generates BCs required for a Shear-BCE

rBCE_BCs = RightStretch(nBCE.Right, N, 'S', config);
rBCE_BCs = strcat(rBCE_BCs, '\n');
lBCE_BCs = LeftStretch(nBCE.Left, N, 'S', config);
BCE_BCs = strcat(rBCE_BCs, lBCE_BCs);

% Write BCs to txt file
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\BCE_BCs.txt';
fid = fopen(fn, 'wt');
fprintf(fid, BCE_BCs);

end


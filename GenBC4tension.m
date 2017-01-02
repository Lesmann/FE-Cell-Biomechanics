function BCE_BCs = GenBC4tension(nBCE, N, config)

% This function generates BCs required for a tension-BCE

tBCE_BCs = TopStretch(nBCE.Top, N, 'T', config);
tBCE_BCs = strcat(tBCE_BCs, '\n');
bBCE_BCs = ButtomStretch(nBCE.Buttom, N, 'T', config);
BCE_BCs = strcat(tBCE_BCs, bBCE_BCs);

% Write BCs to txt file
fn = 'E:\Ran\Cell-ECM_model_2D_1_cell\csvFiles\BCE_BCs.txt';
fid = fopen(fn, 'wt');
fprintf(fid, BCE_BCs);

end


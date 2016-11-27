function strain = TnS_AvgStrain( Ref_Data, Data )

% Copmutation of average shear and normal strains by Tokash and Sopher:
% This algorithm computes the (principle and shear) strains for each element
% in the network and calculates their mean value.

% nodes
nodes = Ref_Data.Nodes;

% elements
Elements = Ref_Data.Elements;

% 1st nodes column from elements (NCE1)
NCE1 = Elements(:, 1);

% 2nd nodes column from elements (NCE2)
NCE2 = Elements(:, 2);

% x coordinates of NCE1 (NCE1x)
iNCE1x = nodes(NCE1, 1);
% y coordinates of NCE1 (NCE1y)
iNCE1y = nodes(NCE1, 2);

% x coordinates of NCE2 (NCE2x)
iNCE2x = nodes(NCE2, 1);
% y coordinates of NCE2 (NCE2y)
iNCE2y = nodes(NCE2, 2);

% initial length of elements in x direction (iLx)
iLx = abs(iNCE2x-iNCE1x);

% initial length of elements in x direction (iLy)
iLy = abs(iNCE2y-iNCE1y);

% displacements in x of NCE1
u1x = Data.U_U1(NCE1);
u1x = cell2mat(u1x);
% displacements in y of NCE1
u1y = Data.U_U2(NCE1);
u1y = cell2mat(u1y);

% displacements in x of NCE2
u2x = Data.U_U1(NCE2);
u2x = cell2mat(u2x);
% displacements in y of NCE2
u2y = Data.U_U2(NCE2);
u2y = cell2mat(u2y);

% final length of elements in x direction (fLx)
fNCE1x = iNCE1x+u1x';
fNCE2x = iNCE2x+u2x';
fLx = abs(fNCE2x-fNCE1x);

% final length of elements in y direction (fLy)
fNCE1y = iNCE1y+u1y';
fNCE2y = iNCE2y+u2y';
fLy = abs(fNCE2y-fNCE1y);

%(The problem is HERE - define strains correctly!)
% (normal) strain in xx principle direction (rho.xx)
strain.rho.xx = fLx-iLx./iLx;
% (normal) strain in yy principle direction (rho.yy)
strain.rho.yy = fLy-iLy./iLy;

% strain in yx direction (tau.yx)
strain.tau.yx = fLy-iLy./iLx;
% strain in yx direction (tau.xy)
strain.tau.xy = fLx-iLx./iLy;

strain.tau.avg = (strain.tau.xy + strain.tau.yx)/2;

end


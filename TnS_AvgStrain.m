function strain = TnS_AvgStrain( Ref_Data, Data )

% Copmutation of average shear and normal strains 
% written by Hanan Tokash and Ran Sopher:

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

% initial projection of elements in x direction (iLx)
iLx = abs(iNCE2x-iNCE1x);

% initial projection of elements in y direction (iLy)
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

% final projection of elements in x direction (fLx)
fNCE1x = iNCE1x+u1x';
fNCE2x = iNCE2x+u2x';
fLx = abs(fNCE2x-fNCE1x);

% final projection of elements in y direction (fLy)
fNCE1y = iNCE1y+u1y';
fNCE2y = iNCE2y+u2y';
fLy = abs(fNCE2y-fNCE1y);

% (normal) strain in xx principle direction (epsilon.xx)
strain.epsilon.xx = (fLx-iLx)./iLx;
% (normal) strain in yy principle direction (epsilon.yy)
strain.epsilon.yy = (fLy-iLy)./iLy;

% Conventional definition (for shear loading test):

% strain in yx direction (gama.alpha)
strain.gama.alpha = (fLy-iLy)./iLx;
% strain in yx direction (gama.beta)
strain.gama.beta = (fLx-iLx)./iLy;
% Engineering shear strain (gama.engineering)
strain.gama.eng = strain.gama.alpha + strain.gama.beta;

% Jacob's definition (for shear loading):
gama = sort(strain.gama.eng/2);
epsilon = sort(strain.epsilon.xx);

strain.Notbohm.P = polyfit(epsilon, gama, 1);

strain.Notbohm.epsilon = epsilon;
strain.Notbohm.linear_fit = strain.Notbohm.P(1)*epsilon;

% Our definition:
gama = strain.gama.eng;
epsilon = strain.epsilon.xx;
unvalid1 = epsilon == inf;
unvalid2 = epsilon == -inf;
epsilon(unvalid1) = [];
epsilon(unvalid2) = [];
gama(unvalid1) = [];
gama(unvalid2) = [];

strain.TnS.P = polyfit(epsilon, gama, 1);

strain.TnS.epsilon = epsilon;
strain.TnS.linear_fit = strain.TnS.P(1)*epsilon;

% Apparent strains in x and y as explain by Jacob (for uniaxial tension)
strain.UAT.Px = polyfit(strain.epsilon.xx, , 1);



end


function strain = Notbohm_AvgStrain( Ref_Data, Data )

% Algorithm for:
% Average shear and normal strain computation according to Jacob Notbohm's instructions

x = Ref_Data.Nodes(:, 1); % node x coordinates matrix
    y = Ref_Data.Nodes(:, 2); % node y coordinates matrix
    
    % Find indices of single center-line nodes 
    % scl = y<(Res.config.regParams.iSeed) & y>(-Res.config.regParams.iSeed);
    
    ux = Data.U_U1; % x displacement matrix
    ux = cell2mat(ux);
    uy = Data.U_U2; % y displacement matrix
    uy = cell2mat(uy);
    
    % yy = y(scl); % y coordinates of nodes on single line at center of network
    % xx = x(scl); % x coordinates of nodes on single line at center of network
    yy = y;
    xx = x;
    
    % uxx = ux(scl)'; % x displacement values of single line at center of network
    % uyy = uy(scl)'; % y displacement values of single line at center of network
    uxx = ux';
    uyy = uy';
    
    Pxx = polyfit(xx, uxx, 1); % Linear-fit of displacement x vs position x
    Pyy = polyfit(yy, uyy, 1); % Linear-fit of displacement y vs position y
    
    % Prho(i) = (Pxx(i, 1)+Pyy(i, 1))/2; % Average normal strain
    Prho = Pxx;
    strain.trans = Pyy(1)*yy;
    strain.axial = Prho(1)*xx;
    
    Pxy = polyfit(xx, uyy, 1); % Linear-fit of displacement y vs position x
    Pyx = polyfit(yy, uxx, 1); % Linear-fit of displacement x vs position y
    
    Ptau = (Pyx + Pxy)/2; % Average shear strain
    
    strain.rho = Prho(1)*xx; % Linear-fit line of average normal strain
    strain.tau = Ptau(1)*xx; % Linear-fit line of average shear strain
    
    strain.Pois = strain.axial./strain.trans;
    strain.xx = xx;
    strain.PEPR = polyfit(strain.Pois, strain.xx, 1);
    strain.EPR = strain.PEPR(1)*strain.xx;
    
end


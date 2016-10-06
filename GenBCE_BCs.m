function BCE_BCs = GenBCE_BCs(nBCE, config, N)

% This function generates bulk-control experiment (BCE) boundary conditions according to 
% the BCE type specified by the user (tension/compression/shear).

if strcmp(config.terms.bceType, 'T')
    BCE_BCs = GenBC4tension(nBCE, N, config);
end

if strcmp(config.terms.bceType, 'C')
    BCE_BCs = GenBC4compression(nBCE, N, config);
end

if strcmp(config.terms.bceType, 'S')
    BCE_BCs = GenBC4Shear(nBCE, N, config);
end

end
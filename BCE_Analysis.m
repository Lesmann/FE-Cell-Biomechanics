function [ Res ] = BCE_Analysis( path )

% This function Analyses displacement data of bulk-control experiments (BCE) models and
% generates the following graphs according to the BCE Type:
% 1. Poisson's ratio vs. axial strain for uniaxial tension/compression BCEs.
% 2. Normal vs. shear strain for shear loading BCEs.

% read and calculate reference data

[ Res.Ref_Data ] = strain2log_stretch_ratio( path ); 

% Read data from path

[fnames, rawdata] = rd(path); % load data from all files in path

for i = 1 : length(fnames)
    
    [ Res.Data ] = dd( rawdata ); % extract and divide data
    
    
    
end

end


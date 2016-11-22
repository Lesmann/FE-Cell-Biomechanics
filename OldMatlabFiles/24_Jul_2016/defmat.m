function [ mat ] = defmat( config, FN )

% This function gets the model's material type (L \ BL \ WLC (not yet available)),
% generates the required test-data (if required) according to the material
% properties specified in 'prop'. The generated string is stored in a .csv
% file for later use.
% this function returns the generated test data.
% 1. If data type is 'Youngs-modulus based (YM)', td will contain: Young's modulus, Poisson's ratio.
% 2. in case data type is 'Test-data based (TD)', td will contain the generated test data.

% 1. get properties

norm_Ymod = num2str(config.blMatProp.ymod);
weak_Ymod = num2str(config.blMatProp.ymod*1e-6);
poisr = num2str(config.blMatProp.poisr);

% 2. get type of data of material mechanical properties

if strcmp(config.params.matype, 'YM')
    
    % inp-file text pattern:
    % **
    % *Material, name="Normal Elastic"
    % *Elastic
    % 1000., 0.45
    % *Material, name="Weak Elastic"
    % *Elastic
    % 0.001, 0.45
    
    matStr =  '**\n*Material, name="Normal Elastic"\n*Elastic\n';
    matStr = strcat(matStr, [norm_Ymod, ',', poisr, '\n']);
    matStr =  strcat(matStr, '**\n*Material, name="Weak Elastic"\n*Elastic\n');
    matStr = strcat(matStr, [weak_Ymod, ',', poisr, '\n']);
    
    mat = struct('mats', matStr, 'ymod', config.blMatProp.ymod, 'poisr', config.blMatProp.poisr, 'type', config.params.matype);
    
    path = 'E:\Ran\Cell-ECM model 2D 1 cell\csvFiles\';
    fn = 'le.txt';
    fp = strcat(path, fn);
    fid = fopen( fp, 'wt' );
    fprintf(fid, matStr);
    fclose(fid);
    
else
    
    % generate test data for normal and weak elements
    
    [ ns, netd ] = TestData( config.blMatProp.type, config.blMatProp.n,...
        config.blMatProp.r, config.blMatProp.rho, norm_Ymod, 'ne');
    
    [ ws, wetd ] = TestData( config.blMatProp.type, config.blMatProp.n,...
        config.blMatProp.r, config.blMatProp.rho, weak_Ymod, 'we');
    
    % adding the nlgeom flag
    path = 'E:\Ran\Cell-ECM model 2D 1 cell\inpTestFiles\';
    fn = strcat(path, FN);
    inp = fileread(fn);
    nlgeom = '**\n*Step, name=Step-1, nlgeom=YES\n';
    Splt_n_Push(fn, inp, nlgeom, '** STEP: Step-1', '*Static');
    
    % save and return test data
    mats = strcat(ns, '\n');
    mats = strcat(mats, ws);
    mat = struct('netd', netd, 'wetd', wetd, 'mats', mats, 'type', config.params.matype);
    
end


end


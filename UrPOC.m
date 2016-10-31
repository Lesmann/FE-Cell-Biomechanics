function [ indx, ur, pnodes ] = ...
    UrPOC(Ur, nodes, pts, R, r, ang)

%%
% Average Total displacement field (U(r)) withing a
% Piece Of Cake (POC)

% This function is set to do the following:
% 1. read data from 'path'.
% 2. divide data into 3 vectors:
%  (ur (Mag(U)), u1r (U(x)), u2r (U(y))).
% 3. define a cut (POC) from a circle of the folloeing parameters:
    % a. outer-radius 'R'
    % b. inner-radius 'r'
    % c. cut angle 'ang'
% 4. get all data within the cut POC --> (dataPOC)
%%

% 3. define a cut (POC) from a circle:

POC = defPOC(R, r, ang);

% 4. get all data within POC

[indx, pnodes] = datPOC(pts, nodes, POC); % pnode = required part of nodes
ur = Ur(:, indx);

% [ mUr, mU1r, mU2r ] = calcUr( pnodes, pts, Ur, POC, r, R );
% 
% [ gof, f ] = DispUr( mUr, r, R );
%%


end


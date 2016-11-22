function [ indx, ur ] = ...
    UrPOC(Ur, nodes, pts, R, r, ang, indx)

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
% 4. get data for POC cut (ur)
%%

% 3. define a cut (POC) from a circle:

POC = defPOC(R, r, ang);

% 4. get all data for each POC rings

indx = datPOC(pts, nodes, POC, indx); % pnode = required part of nodes
ur = Ur(indx);

end


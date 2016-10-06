function [ mUr ] = avgUr( nodes, Ur, pts, r, R, ang, n )

% This function gets the following parameters:
% 1. 'Ur' = a full displacement vector (U for each node).
% 2. 'r' = cell's radius.
% 3. 'R' = outer boundary radius.
% 4. 'ang' = cut angle
% 4. 'n' = number of averaged rings.

% and do the following:
% Averages U(r) over 'dr' = small arcs\rings of a cirular cut (specified by the above parameters).
% and returns 'mUr'= the averaged vector.

dr = (R-r)/n; % degree-interval for averaging
radi = r+dr : dr : R-dr;
lr = length(radi);
[lu, ~] = size(Ur);
for i = 1 : lu
    for j = 1 : lr-1
        % get d(arcs) from POC
        POC = defPOC(radi(j), r, ang); % get main parameters of cut
        dang = [POC(3), POC(4)]; % get cut aperture range
        [ ~, ur, ~ ] = ...
            UrPOC(Ur(i, :), nodes, pts, radi(j+1), radi(j), dang);
        % average displacemnts for each arc
        mUr(i, j) = mean(ur);
    end
end


end


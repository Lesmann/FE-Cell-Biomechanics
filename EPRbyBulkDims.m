function [ Res ] = EPRbyBulkDims( Res, nodes_before, nodes_after, idx )

% Compute apparent strains (Axial and Transversal) - by bulk dimensions

% calculate lengths before

lb = sum(diff(abs(nodes_before(:, 1))));
wb = sum(diff(abs(nodes_before(:, 2))));

% in case one of the length(axial or transversal) equals zero
% define it to be very small to prevent
if lb == 0
    lb = 1e-7;
end
if wb == 0
    wb = 1e-7;
end

la = sum(diff(abs(nodes_after(:, 1))));
wa = sum(diff(abs(nodes_after(:, 2))));

% calculate bulk diagonal strain
Res.Bulk.Ax(idx) = (wa-wb)/wb*(2/sqrt(2));
Bulk_Ax = Res.Bulk.Ax(idx);

% calculate bulk diagonal strain
Res.Bulk.Trans(idx) = (la-lb)/lb*(2/sqrt(2)); 
Bulk_Trans = Res.Bulk.Trans(idx);

Res.Bulk.EPR(idx) = -(Bulk_Trans/Bulk_Ax);

end


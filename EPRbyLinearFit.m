function Res = EPRbyLinearFit( Res, y, uy, x, ux, idx )

% Compute apparent strains (Axial and Transversal) - by linear fitting
J_Ax = polyfit(y', uy, 1);
Res.fit.Ax.A(idx) = J_Ax(1);  % Apparent axial strain
Res.fit.Ax.B(idx) = J_Ax(2);

J_Trans = polyfit(x', ux, 1);
Res.fit.Trans.A(idx) = J_Trans(1); % Apparent transversal strain
Res.fit.Trans.B(idx) = J_Trans(2);

Res.Jacob.EPR(idx) = -(J_Trans(1)/J_Ax(1));

end


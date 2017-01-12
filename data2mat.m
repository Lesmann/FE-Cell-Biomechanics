function [ mat_data ] = data2mat( Res )

% This function gets data in vectoric form and returns
% an nxn data matrix

U_mat = reshape(Res.Ref_Data.Data.U_Magnitude, [l, w]); % turn displacement vector into square-matrix
U1_mat = reshape(Res.Ref_Data.Data.U_U1, [l, w]); % turn displacement vector into square-matrix
U2_mat = reshape(Res.Ref_Data.Data.U_U2, [l, w]); % turn displacement vector into square-matrix
x_pos_mat = reshape(Res.Ref_Data.Nodes(:, 1), [l, w]);
y_pos_mat = reshape(Res.Ref_Data.Nodes(:, 2), [l, w]);

Res.Data.U_mat = cell2mat(U_mat);
Res.Data.U1_mat = cell2mat(U1_mat);
Res.Data.U2_mat = cell2mat(U2_mat);
Res.Data.x_pos_mat = x_pos_mat;
Res.Data.y_pos_mat = y_pos_mat;

end


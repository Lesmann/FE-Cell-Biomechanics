function [ Res ] = EPRbyElementLength( Res, nodes_before, nodes_after, elements, idx )

% This function calculates the effective poisson's ratio by considering
% element length before and after simulation

calc_method = 'cartese';
calc_method_y = [calc_method, '_y'];
calc_method_x = [calc_method, '_x'];

% compute elements length
[el_cat, Res.element_length.before] = get_element_length(nodes_before, elements);
length_before_y = Res.element_length.before.(calc_method_y);
length_before_x = Res.element_length.before.(calc_method_x);
length_before_mag = sqrt(length_before_x.^2+length_before_y.^2);

[~, Res.element_length.after] = get_element_length(nodes_after, elements);
length_after_y = Res.element_length.after.(calc_method_y);
length_after_x = Res.element_length.after.(calc_method_x);
length_after_mag = sqrt(length_after_x.^2+length_after_y.^2);

% compute transversal strain by element length
length_before_mag_tr = mean(length_before_mag(el_cat.Ob_RL)); % length of RL diagonal before
length_after_mag_tr = mean(length_after_mag(el_cat.Ob_RL)); % length of RL diagonal after

% compute axial strain by element length
length_before_mag_ax = mean(length_before_mag(el_cat.Ob_LR)); % length of LR diagonal before
length_after_mag_ax = mean(length_after_mag(el_cat.Ob_LR)); % length of LR diagonal after

Res.Lesman.L_Ax(idx) = (length_after_mag_ax-length_before_mag_ax)/length_before_mag_ax;
L_Ax = Res.Lesman.L_Ax(idx);

Res.Lesman.L_Trans(idx) = (length_after_mag_tr-length_before_mag_tr)/length_before_mag_tr;
L_Trans = Res.Lesman.L_Trans(idx);

% Res.Lesman.strain.Ax = length_after_y-length_before_y./length_before_y;

% ignore nans and comupte mean axial strain
% Ax = Res.Lesman.strain.Ax(~isnan(Res.Lesman.strain.Ax));
% Res.Lesman.L_Ax(idx) = mean(Ax);
% L_Ax = Res.Lesman.L_Ax(idx);

% % compute transversal strain by element length
% Res.Lesman.strain.Trans = length_after_x-length_before_x./length_before_x;
% 
% % ignore nans and comupte mean transversal strain
% Trans = Res.Lesman.strain.Trans(~isnan(Res.Lesman.strain.Trans));
% Res.Lesman.L_Trans(idx) = mean(Trans);
% L_Trans = Res.Lesman.L_Trans(idx);

Res.Lesman.EPR(idx) = -(L_Trans/L_Ax);

end


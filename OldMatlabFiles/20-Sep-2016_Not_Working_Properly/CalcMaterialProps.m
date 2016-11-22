
d = 100e-9; % m
csa = pi*(d/2)^2; % m^2

max_force = 18000e-12; % N
max_stress = max_force/csa; % N/m^2=Pa

max_strain = 25e-9; % no units

% convert to MPa
E = (max_stress/max_strain)*10e6; % MPa

% considering the cross-sectional area in our model to be 1 (instead of 7.854e-15)
E_model = E*10e-15;
% and considering our model considers MPa units as 1
E_model = E_model*10e-6;
 
% reshape testing - to verify elemets numbering is OK
arr = sort(round(1000*rand(1000, 1)));
re_arr = reshape(arr, [20, 50]);




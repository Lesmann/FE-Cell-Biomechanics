function POC = defPOC(R, r, ang)

% This function defines a cut of a circle
% (piece of cake)according to:
% 1. inner and outer radiuses 'R' and 'r' respectively.
% 2. aperture angles 'ang1' and 'ang2'
% 'dang' = ang2 - ang1
ang1 = ang(1); ang2 = ang(2);
% if (ang1 > ang2) || ...
%     ang1 < 0 || ang1 > 2*pi ...
%     || ang2 < 0 || ang2 > 2*pi
% display('angles are NOT valid!');
% quit;
% end
POC = [R, r ang1, ang2];

end


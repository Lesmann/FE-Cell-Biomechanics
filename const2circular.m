function circNodes = const2circular(pts, config)

% This function gets the center points of MCC (multi-cell-configuration) 
% or SCC (single-cell-configuration) models and returns coordinates of
% circle to which the cell nodes (i.e. inner nodes) will be moved.

r = config.params.r;
th = 0:2*pi/100000:2*pi;
[l, ~] = size(pts);

for i = 1 : l
    
    x = pts(i, 1);
    y = pts(i, 2);
    xcirc = r*cos(th) + x;
    ycirc = r*sin(th) + y;
    circNodes{i} = horzcat(xcirc', ycirc');
    
end


end


function dimensions = get_region_dims(region, config)

% This function gets a region of nodes as an input and returns its
% geometrical dimensions (i.e. its spatial width and length)

x = region(:, 1);
y = region(:, 2);

left = min(x);
right = max(x);

buttom = min(y);
top = max(y);

dimensions.width = top-buttom;
dimensions.length = right-left;

% validation (all regions except for cell region)
num_of_node_width = dimensions.width/config.regParams.iSeed+1;
num_of_node_length = dimensions.length/config.regParams.iSeed+1;

end


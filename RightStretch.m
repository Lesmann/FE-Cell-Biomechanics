function BCs = RightStretch(n, N, s, config)

% Generate Right Stretch for BCE

Mag = config.terms.BCE_Mag;

if strcmp(s, 'T')
    bcx = num2str(Mag*config.regParams.rect.length/2);
    bcy = num2str(0);
elseif strcmp(s, 'C')
    bcx = num2str(-Mag*config.regParams.rect.length/2);
    bcy = num2str(0);
elseif strcmp(s, 'S')
    bcy = num2str(0);
    bcx = num2str(Mag*config.regParams.rect.length/2);
end

l = length(n);
for i = 1 : l % going through all nodes on the cell's edge in order to assign them with a BC
    coor = N(n(i), :); % extracting the node (serial number and coordinates)
    % each node will be assigned a BC of displacement equivalent to MOD
    % (0.1) of the cell's radius
    if i == 1
        bcNames = strcat('ns', num2str(n(i)));
        BCs = strcat('** Name: BC', num2str(n(i)));
        BCs = strcat(BCs, ' Type: Displacement/Rotation\n*Boundary\n');
        BCs = strcat(BCs, 'ns');
        BCs = strcat(BCs, num2str(n(i)));
        BCs = strcat(BCs, ', 1, 1, ');        
        BCs = strcat(BCs, bcx); % x BC
        BCs = strcat(BCs, ' \n');
        % BCs = strcat(BCs, 'ns');
        % BCs = strcat(BCs, num2str(n(i)));
        % BCs = strcat(BCs, ', 2, 2, ');
        % BCs = strcat(BCs, bcy); % y BC
        % BCs = strcat(BCs, ' \n');
        % bcNames = strcat(bcNames, ', ');
    else
        bcNames = strcat(bcNames, 'ns');
        bcNames = strcat(bcNames, num2str(n(i)));
        temp = strcat('** Name: BC', num2str(n(i)));
        temp = strcat(temp, ' Type: Displacement/Rotation\n*Boundary\n');
        temp = strcat(temp, 'ns');
        temp = strcat(temp, num2str(n(i)));
        temp = strcat(temp, ', 1, 1, ');
        temp = strcat(temp, bcx); % x BC
        temp = strcat(temp, ' \n');
        % temp = strcat(temp, 'ns');
        % temp = strcat(temp, num2str(n(i)));
        % temp = strcat(temp, ', 2, 2, ');
        % temp = strcat(temp, bcy); % y BC
        % temp = strcat(temp, ' \n');
        % bcNames = strcat(bcNames, ', ');
        BCs = strcat(BCs, temp);
    end
end

end


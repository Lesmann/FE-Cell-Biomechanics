function BCEsets = Edges(Nodes, config)

% This function returns the nodes required for BCE BCs definition (i.e. network's edges)
ln = length(Nodes);
k=1;

for i = 1 : ln
    Ni = Nodes(i, :);
    x = Ni(1); y = Ni(2);
    if abs(x) == config.regParams.sq/2 || abs(y) == config.regParams.sq/2
        nBCE(k) = i;
        k=k+1;
    end
end

kr=1;kl=1;kt=1;kb=1;
for i = 1 : length(nBCE)
    Ni = Nodes(nBCE(i), :);
    x = Ni(1); y = Ni(2);
    if x == -config.regParams.sq/2
        Left(kl) = i;
        kl=kl+1;
    end
    
    if x == config.regParams.sq/2
        Right(kr) = i;
        kr=kr+1;
    end
    
    if y == config.regParams.sq/2
        Top(kt) = i;
        kt=kt+1;
    end
    
    if y == -config.regParams.sq/2
        Buttom(kb) = i;
        kb=kb+1;
    end
end

BCEsets = struct('Right', nBCE(Right), 'Left', nBCE(Left),...
    'Top', nBCE(Top), 'Buttom', nBCE(Buttom));

end


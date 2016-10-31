function [indx, dataPOC] = datPOC(pts, nodes, POC)

% This function gets all nodes from 'nodes' found within the
% range of the cut of the circle defined by 'POC'

[wp, ~] = size(pts);
[wn, ~] = size(nodes);

R = POC(1);
ang1 = POC(3); ang2 = POC(4);

cqtr = qtr(ang1, ang2);

rang = 0;
comp = 0;
k=1;

for i = 1 : wp
    currp = pts(i, :);
    xp = currp(1); yp = currp(2); % get current coordinates from pts
    for j = 1 : wn
        currn = nodes(j, :);
        % get current coordinates from nodes
        xn = currn(1); yn = currn(2);
        qtrs = [sign(xn), sign(yn)];
        
        if isequal(qtrs, [-1, 1])
            comp = pi;
        end
        if isequal(qtrs, [-1, -1])
            comp = pi;
        end
        if isequal(qtrs, [1, -1])
            comp = 2*pi;
        end
        
        % ralative distances in x and y
        dx = xn-xp; dy = yn-yp;
        % distance of current node from the origin of the current point
        d = sqrt((dx)^2+(dy)^2);
        
        % angle from the origin of the current point to the current node
        nang = atan(dy/dx) + comp;
        comp = 0;
        
        if ang1 < ang2
            rang = nang >= ang1 && nang <= ang2;
        else
            if isequal(qtrs, [1, 1])
                rang = nang <= ang2;                
            end
            if isequal(qtrs, [1, -1])
                rang = nang >= ang1;
            end
        end
        
        inqtr = isequal(cqtr(1, :), qtrs) ||...
            isequal(cqtr(2, :), qtrs) ||...
            isequal(cqtr(3, :), qtrs) ||...
            isequal(cqtr(4, :), qtrs);
        inrad = (R - d) > 0;
        
        if inrad && inqtr && rang
            indx(k) = j;
            k=k+1;
        end
    end
    indx = indx';
    dataPOC = nodes(indx, :);
    
    hold on
    title('Required Cut')
    scatter(nodes(:, 1), nodes(:, 2), '.black');
    scatter(dataPOC(:, 1), dataPOC(:, 2), '.r');
    hold off
end

end


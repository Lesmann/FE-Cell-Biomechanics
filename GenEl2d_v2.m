function El = GenEl2d_v2 ( Nodes, config, d )

% This function generates an element vector 'El'
% according to desired distance 'd' between nodes in vector 'Nodes' (which is 1 or sqrt(2)).

d = config.regParams.iSeed*d;
l = length(Nodes);
El=[];
for i = 1 : l
    N1 = Nodes(i, :); % Define 1st node bordering the element
    currentNodeMatrix=repmat(N1,l,1);
    moreNodesMatrix=NaN(l,2);
    moreNodesMatrix(i+1:l,:)=Nodes(i+1:l,:);
    squaredDistanceMatrix=(currentNodeMatrix(:,1)-moreNodesMatrix(:,1)).^2+(currentNodeMatrix(:,2)-moreNodesMatrix(:,2)).^2;
    squaredDistanceMatrix=((squaredDistanceMatrix>d^2-1e-3)&(squaredDistanceMatrix<d^2+1e-3));
    El=[El; [find(squaredDistanceMatrix),i*ones(length(find(squaredDistanceMatrix)),1)]];
end

end
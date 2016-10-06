function [ cellCoordinates ] = MCC_4neighbours ( regParams, params )

[cellCoordinates_x,cellCoordinates_y] = meshgrid(-regParams.sq/2+params.R/4: params.R/4 : regParams.sq/2-params.R/4);
k=1;
for i=1:size(cellCoordinates_x,1)
    for j=1:size(cellCoordinates_y,2)
        currentCellCoordinates=[cellCoordinates_x(i,j),cellCoordinates_y(i,j)];
        distanceCurrentCellCoordinates=sqrt(currentCellCoordinates(1)^2+currentCellCoordinates(2)^2);
        if distanceCurrentCellCoordinates > params.R-2*params.r
            cellCoordinates_x(i,j)=NaN;
            cellCoordinates_y(i,j)=NaN;
        end
        cellCoordinates(k,:) = [cellCoordinates_x(i,j),cellCoordinates_y(i,j)];
        k=k+1;
    end
end
cellCoordinates(isnan(cellCoordinates(:,1)),:)=[];

end

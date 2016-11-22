function [ cellCoordinates ] = MCC_4neighbours ( config )

[cellCoordinates_x,cellCoordinates_y] = meshgrid(-regParams.sq/2+params.R/5: params.R/5 : regParams.sq/2-params.R/5);
for i=1:size(cellCoordinates_x,1)
    for j=1:size(cellCoordinates_y,2)
        currentCellCoordinates=[cellCoordinates_x(i,j),cellCoordinates_y(i,j)];
        distanceCurrentCellCoordinates=sqrt(currentCellCoordinates(1)^2+currentCellCoordinates(2)^2);
        if distanceCurrentCellCoordinates > params.R
            cellCoordinates_x(i,j)=NaN;
            cellCoordinates_y(i,j)=NaN;
        end
    end
end

end

function [ cellCoordinates ] = MCC_circular ( numofCells, R )

cellCoordinates=zeros(numofCells,2);

if numofCells==2
    cellCoordinates(1,:)=[R/2, 0];
    cellCoordinates(2,:)=[-R/2, 0];
    return
end
cellCoordinates(1,:)=[0, 0];
cellCoordinates(2,:)=[R/2, 0];
gyrationAngleInterval=360/(numofCells-1);
gyrationAngles=0;
for i=1:numofCells-2
    gyrationAngles=[gyrationAngles i*gyrationAngleInterval];
end
for i=3:numofCells
    current_gyrationAngle=gyrationAngles(i-1);
    current_cellCoordinates=R/2*[cosd(current_gyrationAngle),sind(current_gyrationAngle)];
    cellCoordinates(i,:)=current_cellCoordinates;

end
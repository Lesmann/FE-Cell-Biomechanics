function [ cellCoordinates ] = MCC_circular ( numofCells, R )

dfo = 0.1; % distance of cells from the origin

cellCoordinates=zeros(numofCells,2);

if numofCells==2
    cellCoordinates(1,:)=[dfo*R, 0];
    cellCoordinates(2,:)=[-dfo*R, 0];
    return
end

cellCoordinates(1,:)=[0, 0];
cellCoordinates(2,:)=[dfo*R, 0];
gyrationAngleInterval=360/(numofCells-1);
gyrationAngles=0;

for i=1:numofCells-2
    gyrationAngles=[gyrationAngles i*gyrationAngleInterval];
end

for i=3:numofCells
    current_gyrationAngle=gyrationAngles(i-1);
    current_cellCoordinates=dfo*R*[cosd(current_gyrationAngle),sind(current_gyrationAngle)];
    cellCoordinates(i,:)=current_cellCoordinates;
end


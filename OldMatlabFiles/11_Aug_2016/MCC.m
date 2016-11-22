function [ cellCordinates ] = MCC ( numofCells, R )

cellCordinates=zeros(numofCells,2);

if numofCells==2
    cellCordinates(1,:)=[R/2, 0];
    cellCordinates(2,:)=[-R/2, 0];
    return
end
cellCordinates(1,:)=[0, 0];
cellCordinates(2,:)=[R/2, 0];
gyrationAngleInterval=360/(numofCells-1);
gyrationAngles=0;
for i=1:numofCells-2
    gyrationAngles=[gyrationAngles i*gyrationAngleInterval];
end
for i=3:numofCells
    current_gyrationAngle=gyrationAngles(i-1);
    current_cellCordinates=R/2*[cosd(current_gyrationAngle),sind(current_gyrationAngle)];
    cellCordinates(i,:)=current_cellCordinates;
end
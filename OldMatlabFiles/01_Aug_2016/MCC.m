function [ pts ] = MCC ( numofCells, R )

cellCordinates=zeros(numofCells,2);
cellCordinates(1,:)=[R/2, 0];
gyrationAngleInterval=360/numofCells;
gyrationAngles=0;
for i=1:numofCells-1
    gyrationAngles=[gyrationAngles i*gyrationAngleInterval];
end
for i=2:numofCells
    current_gyrationAngle=gyrationAngles(i);
    current_cellCordinates=R/2*[cosd(current_gyrationAngle),sind(current_gyrationAngle)];
    cellCordinates(i,:)=current_cellCordinates;
    pts=cellCordinates;
end
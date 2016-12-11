clc
clear all
close all

cd('E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\Old geometry\trial');
filenames=dir('*.inp');
filenames={filenames.name};

for l=1:length(filenames)
    filename=filenames{l};
    filename=filename(1:end-4)
    %%% Loading data
    sourceFileName = strcat(filename,'.inp'); % inp file
    sourceFileName2 = strcat(filename,'.rpt'); % rpt file
    % Loading nodes original locations (nodes_original_locations)
    dataString = fileread(sourceFileName);
    beginIndicationString = '*Node';
    endIndicationString = '*Element';
    pBegin = strfind(dataString, beginIndicationString);
    dataString = dataString((pBegin+length(beginIndicationString):end));
    pEnd = findstr(dataString, endIndicationString);
    dataString = dataString(1:(pEnd-1));
    nodes_original_locations = str2num(dataString);
    dataString = fileread(sourceFileName);
    beginIndicationString = '*Element';
    endIndicationString = '*Elset';
    pBegin = strfind(dataString, beginIndicationString);
    dataString = dataString((pBegin+length(beginIndicationString):end));
    pEnd = findstr(dataString, endIndicationString);
    dataString = dataString(18:(pEnd-1));
    elements = str2num(dataString);
    % Calculating locations of element centroids
    for i=1:size(elements,1)
       nodeindex1=elements(i,2);
       nodeindex2=elements(i,3);
       nodelocation1=nodes_original_locations(nodeindex1,2:3);
       nodelocation2=nodes_original_locations(nodeindex2,2:3);
       elementcentroidlocation=(nodelocation1+nodelocation2)/2;
       elements(i,4:5)=elementcentroidlocation;               
    end
    % Loading outputs at centroids
    dataString = fileread(sourceFileName2);
    beginIndicationString = '@Loc 1'; % change
    pBegin = strfind(dataString, beginIndicationString);
    dataString = dataString((pBegin(2)+length(beginIndicationString)+51:end));
    if findstr(filename, 'C8')
        centroids_outputs = str2num(dataString);
    else
        endIndicationString='Field';
        pEnd = findstr(dataString, endIndicationString);
        dataString = dataString(1:(pEnd-1));
        centroids_outputs1 = str2num(dataString);
        dataString = fileread(sourceFileName2);
        beginIndicationString = '@Loc 1';
        pBegin = strfind(dataString, beginIndicationString);
        dataString = dataString((pBegin(4)+length(beginIndicationString)+51:end));
        centroids_outputs2 = str2num(dataString);
        centroids_outputs=[centroids_outputs1; centroids_outputs2];
        centroids_outputs=sortrows(centroids_outputs);
    end
    %%% Model parameters
    beginIndicationString='_D0';
    endIndicationString='_';
    pBegin=strfind(filename, beginIndicationString);
    distanceCellOrigin=filename((pBegin+length(beginIndicationString):end));
    pEnd=findstr(distanceCellOrigin, endIndicationString);
    distanceCellOrigin=distanceCellOrigin(1:(pEnd-1));
    distanceCellOrigin=str2num(distanceCellOrigin);
    distanceCellOrigin=distanceCellOrigin/100;
    if distanceCellOrigin==0.01;
        distanceCellOrigin=0.1;
    elseif distanceCellOrigin==0.02
        distanceCellOrigin=0.2;
    end
    R=0.5;
    distanceCellOrigin=distanceCellOrigin*R;
    cellRadius=0.01;
    cellDiameter=cellRadius*2;
    bandLength=(distanceCellOrigin-cellRadius)*2;
    
    %%% Identifying all element centroids falling within the band between the two cells
    j=1;
    for i=1:size(elements,1)
        centroid_original_location=elements(i,4:5);
        if (centroid_original_location(1)>(-bandLength/2))&(centroid_original_location(1)<(bandLength/2))&(centroid_original_location(2)>(-cellRadius*3))&(centroid_original_location(2)<(cellRadius*3))
            index_centroids_band(j)=elements(i,1);
            j=j+1;
        end
    end
    
    %%% Extracting data for the centroids falling within the band between the two cells
    centroids_band_original_locations=elements(index_centroids_band,[1 4:5]);
    centroids_band_outputs=centroids_outputs(index_centroids_band,:);
    
    %%%
%     SegmentLength=0.0015;
%     numberOfSegments=bandLength/SegmentLength
    numberOfSegments=20;
    SegmentLength=bandLength/numberOfSegments;
    for i=0:numberOfSegments-1 % going through all segments
        centre_x(i+1)=(-bandLength/2)+SegmentLength/2+i*SegmentLength;
        centre_y=0;
        k=1;
        for j=1:size(centroids_band_original_locations,1) % for each segment, going through all centroids in order to identify those falling within the segment
            centroid_location=centroids_band_original_locations(j,2:3);
            if (centroid_location(1)>(centre_x(i+1)-SegmentLength/2))&(centroid_location(1)<(centre_x(i+1)+SegmentLength/2))&(centroid_location(2)>(centre_y-cellRadius*3))&(centroid_location(2)<(centre_y+cellRadius*3))
                index_centroids_segment(k)=centroids_band_original_locations(j,1);
                k=k+1;
            end
        end
        centroids_segment_original_locations=elements(index_centroids_segment,4:5);
        centroids_segment_outputs=centroids_outputs(index_centroids_segment,:);
        centroids_segment_tensilestrain=centroids_segment_outputs(:,2);
        average_segment_tensilestrain(i+1)=mean(centroids_segment_tensilestrain);
    end
    
    %%% Plotting
    if findstr(filename,'_FBC_BL')
        lineStyle='--';
    elseif findstr(filename,'_FBC_L')
        lineStyle='-.';
    elseif findstr(filename,'_TFBC_BL')
        lineStyle='-*';       
    elseif findstr(filename,'_TFBC_L')
        lineStyle='-+';
    end
    if findstr(filename,'005_')
        lineColour='b';
    elseif findstr(filename,'01_')
        lineColour='k';
    elseif findstr(filename,'015_')
        lineColour='r';
    elseif findstr(filename,'02_')
        lineColour='g';
    elseif findstr(filename,'025_')
        lineColour='y';
    end
    Legend{l}=filename(8:end-8);
    Legend{l}=strcat(Legend{l}(1:2),'.',Legend{l}(3:end));
    Legend{l}=strrep(Legend{l},'_','-');
    plot(centre_x,average_segment_tensilestrain,strcat(lineStyle,lineColour),'LineWidth',2)
    hold on
end
set(gca,'fontsize',16)
legend(Legend);
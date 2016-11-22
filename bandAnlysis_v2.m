clc
clear all
close all

cd('E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\Old geometry\distanceadjustment-connectivity8');
filenames=dir('*.inp');
filenames={filenames.name};

for l=1 %:length(filenames)
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
    % Loading outputs at nodes
    dataString = fileread(sourceFileName2);
    beginIndicationString = '@Loc 1'; % change
    pBegin = strfind(dataString, beginIndicationString);
    dataString = dataString((pBegin(21)+length(beginIndicationString)+374:end));
    if findstr(filename, 'C8')
        centroids_outputs = str2num(dataString);
    else
        endIndicationString='Field';
        pEnd = findstr(dataString, endIndicationString);
        dataString = dataString(1:(pEnd-1));
        centroids_outputs1 = str2num(dataString);
        dataString = fileread(sourceFileName2);
        beginIndicationString = '@Loc 1'; % change
        pBegin = strfind(dataString, beginIndicationString);
        dataString = dataString((pBegin(42)+length(beginIndicationString)+374:end));
        centroids_outputs2 = str2num(dataString);
        for i=1:size(centroids_outputs1,1)
            for j=1:size(centroids_outputs2,1)
                if centroids_outputs1(i,1)==centroids_outputs2(j,1)
                    centroids_outputs1(i,2:end)=(centroids_outputs1(i,2:end)+centroids_outputs2(j,2:end))/2;
                    centroids_outputs2(j,:)=NaN;
                end
            end
        end
        centroids_outputs2(isnan(centroids_outputs2(:,1)),:)=[];
        centroids_outputs=[centroids_outputs1; centroids_outputs2];
    end
    %%% Model oparameters
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
    
    %%% Identifying all nodes falling within the band between the two cells
    j=1;
    for i=1:size(nodes_original_locations,1)
        node_location=nodes_original_locations(i,2:3);
        if (node_location(1)>(-bandLength/2))&(node_location(1)<(bandLength/2))&(node_location(2)>(-cellRadius*3))&(node_location(2)<(cellRadius*3))
            index_nodes_band(j)=nodes_original_locations(i,1);
            j=j+1;
        end
    end
    
    %%% Extracting data for the nodes falling within the band between the two cells
    nodes_band_original_locations=nodes_original_locations(index_nodes_band,:);
    nodes_band_outputs=nodes_outputs(index_nodes_band,:);
    
    %%%
%     SegmentLength=0.0015;
%     numberOfSegments=bandLength/SegmentLength
    numberOfSegments=20;
    SegmentLength=bandLength/numberOfSegments;
    for i=0:numberOfSegments-1 % going through all segments
        centre_x(i+1)=(-bandLength/2)+SegmentLength/2+i*SegmentLength;
        centre_y=0;
        k=1;
        for j=1:size(nodes_band_original_locations,1) % for each segment, going through all nodes in order to identify those falling within the segment
            node_location=nodes_band_original_locations(j,2:3);
            if (node_location(1)>(centre_x(i+1)-SegmentLength/2))&(node_location(1)<(centre_x(i+1)+SegmentLength/2))&(node_location(2)>(centre_y-cellRadius*3))&(node_location(2)<(centre_y+cellRadius*3))
                index_nodes_segment(k)=nodes_band_original_locations(j,1);
                k=k+1;
            end
        end
        nodes_segment_original_locations=nodes_original_locations(index_nodes_segment,:);
        nodes_segment_outputs=nodes_outputs(index_nodes_segment,:);
        nodes_segment_tensilestrain=nodes_segment_outputs(:,5);
        nodes_segment_vmstress=nodes_segment_outputs(:,12);
        average_segment_tensilestrain(i+1)=mean(nodes_segment_tensilestrain);
        average_segment_vmstress(i+1)=mean(nodes_segment_vmstress);
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
%     figure
%     plot(centre_x,average_segment_vmstress)
end
set(gca,'fontsize',16)
legend(Legend);
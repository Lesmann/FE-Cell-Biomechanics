clc
clear all
close all

config.cells=[-0.1 0; 0.1 0];

cd('E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\Old geometry\trial');
filenames=dir('*.inp');
filenames={filenames.name};
%filenames={filenames{1:4},filenames{9:12},filenames{5:8},filenames{17:20},filenames{13:16}};

for l=1:length(filenames)
    filename=filenames{l};
    filename=filename(1:end-4)
    %% Loading data
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
    centroids_data=[centroids_outputs(:,1) elements(:,4:5) centroids_outputs(:,2:3)];
    
    %% Model parameters
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
    
    %% Identifying all element centroids falling within the area of interest (the cells and their surroundings)
    k=1;
    for i=1:size(config.cells,1)
        for j=1:size(centroids_data,1)
            current_cellcentre=config.cells(i,:);
            current_centroid=centroids_data(j,2:3);
            M=[current_cellcentre; current_centroid];
            dist=pdist(M);
            if dist<distanceCellOrigin;
                offset_centroids_data(k,1:size(centroids_data,2))=centroids_data(j,:);
                offset_centroids_data(k,6)=i;
                offset_centroids_data(k,7)=dist;
                offset_centroids_data(k,8)=atan2d(current_centroid(2)-current_cellcentre(2),current_centroid(1)-current_cellcentre(1));
                k=k+1;
            end
        end
    end
    for i=1:size(config.cells,1) % Saving the surroundings of each cell into a separate matrix
        offset_centroids_data_bycell{i}=offset_centroids_data(offset_centroids_data(:,6)==i,:);
    end        
        
    %% Identifying all element centroids falling within the relevant sectors and ring sectors
    % Binning data points according to sectors
    numberofsectors=16;
    sectorangle=360/numberofsectors;
    angles=0:sectorangle:360;
    angles=angles-180;
    centroids_ROI=offset_centroids_data_bycell{1}; % taking only one cell
    for i=1:length(angles)-1
        centroids_ROI_bysector{i}=centroids_ROI(centroids_ROI(:,8)>angles(i)&centroids_ROI(:,8)<angles(i+1),:);
    end
    % Binning data points within each sector according to distance from the cell centre
    numberofrings=3;
    for i=1:numberofsectors
        current_centroids_ROI_bysector=sortrows(centroids_ROI_bysector{i},7);
        length_centroids_ROI_bysector=size(current_centroids_ROI_bysector,1);
        ringsectors_numberofdatapoints=floor(length_centroids_ROI_bysector/numberofrings);
        ringsector_datapointsindices{i,1}=1:ringsectors_numberofdatapoints;
        for j=2:numberofrings-1
            ringsector_datapointsindices{i,j}=(j-1)*ringsectors_numberofdatapoints+1:j*ringsectors_numberofdatapoints;
        end
        ringsector_datapointsindices{i,numberofrings}=(numberofrings-1)*ringsectors_numberofdatapoints+1:length_centroids_ROI_bysector;
    end
    for i=1:numberofsectors
        for j=1:numberofrings
            centroids_ROI_byringsector{i,j}=centroids_ROI_bysector{i}(ringsector_datapointsindices{i,j},:);
        end
    end
%     for i=1:numberofsectors
%         for j=1:numberofrings
%             plot(centroids_ROI_byringsector{i,j}(:,2),centroids_ROI_byringsector{i,j}(:,3),'.')
%             axis equal
%             xlim([-0.2 0])
%             ylim([-0.1 0.1])
%             pause
%         end
%     end

    
    %% Calculating mean values for each sector
    for i=1:numberofsectors
        mean_maxprincipalstrain(i)=mean(centroids_ROI_bysector{i}(:,4));
        mean_minprincipalstrain(i)=mean(centroids_ROI_bysector{i}(:,5));
    end
%     figure;
%     bar(angles(1:16)+sectorangle/2,mean_maxprincipalstrain);
%     filename=strrep(filename,'_','-');
%     title(filename);
%     xlabel('Sector angle');
%     ylabel('Mean maximal principal strain');
    figure;
    bar(angles(1:16)+sectorangle/2,mean_minprincipalstrain);
    filename=strrep(filename,'_','-');
    title(filename);
    xlabel('Sector angle');
    ylabel('Mean minimal principal strain');
    SD_sectors_maxprincipalstrain(l)=abs(std(mean_maxprincipalstrain)/mean(mean_maxprincipalstrain));
    SD_sectors_minprincipalstrain(l)=abs(std(mean_minprincipalstrain)/mean(mean_minprincipalstrain));


end

filenames=strrep(filenames,'_','-');
filenames=strrep(filenames,'-C8-R100.inp','');
filenames=strrep(filenames,'2cells-','');
figure;
bar(SD_sectors_maxprincipalstrain)
xlabels=filenames';
set(gca,'XTickLabel',xlabels,'XTick',1:numel(xlabels),'fontsize',7)
ylabel('Relative standard deviation','fontsize',12)
title('Inter-sector standard deviations of maximal principal strains for all model variants','fontsize',16);
figure;
bar(SD_sectors_minprincipalstrain)
xlabels=filenames';
set(gca,'XTickLabel',xlabels,'XTick',1:numel(xlabels),'fontsize',7)
ylabel('Relative standard deviation','fontsize',12)
title('Inter-sector standard deviations of minimal principal strains for all model variants','fontsize',16);
clc
clear all
close all

R=0.5;

cd('E:\Ran\Cell-ECM_model_2D_1_cell\QA_models\Old geometry\trial');
filenames=dir('*.inp');
filenames={filenames.name};
%filenames={filenames{1:4},filenames{9:12},filenames{5:8},filenames{17:20},filenames{13:16}};

for l=2:2 %length(filenames)
            
    filename=filenames{l};
    filename=filename(1:end-4)
    
    %% Model parameters
    beginIndicationString='_D0';
    endIndicationString='_';
    pBegin=strfind(filename, beginIndicationString);
    dfo=filename((pBegin+length(beginIndicationString):end));
    pEnd=findstr(dfo, endIndicationString);
    dfo=dfo(1:(pEnd-1));
    dfo=str2num(dfo);
    dfo=dfo/100;
    if dfo==0.01;
        dfo=0.1;
    elseif dfo==0.02
        dfo=0.2;
    end
    config.cells=[-dfo*R 0; +dfo*R 0];
    distanceCellOrigin=dfo*R;
    %distanceCellOrigin=distanceCellOrigin*50; % expressing distance between cells in terms of number of radii
    cellRadius=0.01;
    cellDiameter=cellRadius*2;
    
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
    centroids_data(:,5)=abs(centroids_data(:,5));
%     figure
%     plot(centroids_data(:,2),centroids_data(:,3),'.')
%     axis equal
    
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
%     figure
%     plot(offset_centroids_data(:,2),offset_centroids_data(:,3),'.')
%     axis equal
    for i=1:size(config.cells,1) % Saving the surroundings of each cell into a separate matrix
        offset_centroids_data_bycell{i}=offset_centroids_data(offset_centroids_data(:,6)==i,:);
    end        
%     figure
%     plot(offset_centroids_data_bycell{1}(:,2),offset_centroids_data_bycell{1}(:,3),'.')
%     axis equal
        
    %% Identifying all element centroids falling within the relevant sectors, rings and ring sectors
    % Binning data points according to sectors
    numberofsectors=16;
    sectorangle=360/numberofsectors;
    angles=0:sectorangle:360;
    angles=angles-180;
    centroids_ROI=offset_centroids_data_bycell{1}; % taking only one cell
    for i=1:length(angles)-1
        centroids_ROI_bysector{i}=centroids_ROI(centroids_ROI(:,8)>angles(i)&centroids_ROI(:,8)<angles(i+1),:);
    end
%     figure
%     for i=1:numberofsectors
%         plot(centroids_ROI_bysector{i}(:,2),centroids_ROI_bysector{i}(:,3),'.')
%         axis equal
%         xlim([-0.2 0])
%         ylim([-0.1 0.1])
%         pause
%     end
    % Binning data points within each sector according to distance from the cell centre
    numberofrings=5;
    for i=1:numberofsectors
        current_centroids_ROI_bysector=sortrows(centroids_ROI_bysector{i},7);
        centroids_ROI_bysector{i}=current_centroids_ROI_bysector;
        length_centroids_ROI_bysector=size(current_centroids_ROI_bysector,1);
        ringsector_numberofdatapoints=floor(length_centroids_ROI_bysector/numberofrings);
        ringsector_datapointsindices{i,1}=1:ringsector_numberofdatapoints;
        for j=2:numberofrings-1
            ringsector_datapointsindices{i,j}=(j-1)*ringsector_numberofdatapoints+1:j*ringsector_numberofdatapoints;
        end
        ringsector_datapointsindices{i,numberofrings}=(numberofrings-1)*ringsector_numberofdatapoints+1:length_centroids_ROI_bysector;
    end
    for i=1:numberofsectors
        for j=1:numberofrings
            centroids_ROI_byringsector{i,j}=centroids_ROI_bysector{i}(ringsector_datapointsindices{i,j},:);
        end
    end
    figure
%     for i=1:numberofsectors
%         for j=1:numberofrings
%             plot(centroids_ROI_byringsector{i,j}(:,2),centroids_ROI_byringsector{i,j}(:,3),'.')
%             axis equal
%             xlim([-0.2 0])
%             ylim([-0.1 0.1])
%             pause
%         end
%     end
    % Binning data points according to distance form the cell centre
    for i=1:numberofrings
        centroids_ROI_byring{i}=[];
        for j=1:numberofsectors
            centroids_ROI_byring{i}=[centroids_ROI_byring{i}; centroids_ROI_byringsector{j,i}];
        end
    end
    for i=1:numberofrings
        plot(centroids_ROI_byring{i}(:,2),centroids_ROI_byring{i}(:,3),'.')
        axis equal
        xlim([-0.2 0])
        ylim([-0.1 0.1])
        pause
    end
    
    %% Normalisation of outputs within ring sectors according to the mean within the ring
    for i=1:numberofrings
        mean_maxprincipalstrain_ring(i)=mean(centroids_ROI_byring{i}(:,4));
        SD_maxprincipalstrain_ring(i)=std(centroids_ROI_byring{i}(:,4));
        mean_minprincipalstrain_ring(i)=mean(centroids_ROI_byring{i}(:,5));
        SD_minprincipalstrain_ring(i)=std(centroids_ROI_byring{i}(:,5));
    end
    for i=1:numberofsectors
        for j=1:numberofrings
            standardised_maxprincipalstrain_ringsector{i,j}=(centroids_ROI_byringsector{i,j}(:,4)-mean_maxprincipalstrain_ring(j))./SD_maxprincipalstrain_ring(j);
            standardised_minprincipalstrain_ringsector{i,j}=(centroids_ROI_byringsector{i,j}(:,4)-mean_minprincipalstrain_ring(j))./SD_minprincipalstrain_ring(j);
        end
    end
    for i=1:numberofsectors
        for j=1:numberofrings
            centroids_ROI_byringsector_standardised{i,j}=centroids_ROI_byringsector{i,j};
            centroids_ROI_byringsector_standardised{i,j}(:,4)=standardised_maxprincipalstrain_ringsector{i,j};
            centroids_ROI_byringsector_standardised{i,j}(:,5)=standardised_minprincipalstrain_ringsector{i,j};
        end
    end
    figure
    hold on
%     for i=1:numberofsectors
%         for j=1:numberofrings
%             scatter(centroids_ROI_byringsector_standardised{i,j}(:,2),centroids_ROI_byringsector_standardised{i,j}(:,3),[],centroids_ROI_byringsector_standardised{i,j}(:,4),'fill');
%             axis equal
%             xlim([-0.2 0])
%             ylim([-0.1 0.1])
%             title('Standardised maximal principal strain');
%             pause
%         end
%     end
%     figure
%     hold on
%     for i=1:numberofsectors
%         for j=1:numberofrings
%             scatter(centroids_ROI_byringsector_standardised{i,j}(:,2),centroids_ROI_byringsector_standardised{i,j}(:,3),[],centroids_ROI_byringsector_standardised{i,j}(:,5),'fill');
%             axis equal
%             xlim([-0.2 0])
%             ylim([-0.1 0.1])
%             title('Standardised minimal principal strain');
%             pause
%         end
%     end
      
    %% Calculating mean values for each ring sector
    for i=1:numberofsectors
        for j=1:numberofrings
            mean_maxprincipalstrain_ringsector(i,j)=mean(centroids_ROI_byringsector{i,j}(:,4));
            mean_minprincipalstrain_ringsector(i,j)=mean(centroids_ROI_byringsector{i,j}(:,5));
        end
    end
    figure;
    h=bar3(mean_maxprincipalstrain_ringsector','detached');
    hh=get(h(3),'parent');
    set(hh,'xticklabel',angles+sectorangle/2,'yticklabel',{'nearest','','furthest'});
    for i=1:length(h)
        zdata = h(i).ZData;
        h(i).CData = zdata;
        h(i).FaceColor = 'interp';
    end
    filename=strrep(filename,'_','-');
    title(filename);
    xlabel('Sector angle')
    ylabel('Ring');
    zlabel('Mean maximal principal strain');
    figure;
    h=bar3(mean_minprincipalstrain_ringsector','detached');
    hh=get(h(3),'parent');
    set(hh,'xticklabel',angles+sectorangle/2,'yticklabel',{'nearest','','furthest'});
    for i=1:length(h)
        zdata = h(i).ZData;
        h(i).CData = zdata;
        h(i).FaceColor = 'interp';
    end
    filename=strrep(filename,'_','-');
    title(filename);
    xlabel('Sector angle')
    ylabel('Ring');
    zlabel('Mean minimal principal strain');
    
    %% Calculating mean values for each sector and inter-sector SD
    for i=1:numberofsectors
        mean_maxprincipalstrain_sector(i)=mean(centroids_ROI_bysector{i}(:,4));
        mean_minprincipalstrain_sector(i)=mean(centroids_ROI_bysector{i}(:,5));
    end
    SD_sectors_maxprincipalstrain(l)=abs(std(mean_maxprincipalstrain_sector)/mean(mean_maxprincipalstrain_sector));
    SD_sectors_minprincipalstrain(l)=abs(std(mean_minprincipalstrain_sector)/mean(mean_minprincipalstrain_sector));

end

%% Inter-sector standard deviations
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

%% Calculating the ratio between the sum of strains occurring in the integration points contained in the area between the two cells and the sum and those occurring all around the cell
j=1;
for i=1:size(centroids_ROI,1)
    if abs(centroids_ROI(i,8))<=30
        centroid_angle_index(j)=i;
        j=j+1;
    end
end
centroids_angle=centroids_ROI(centroid_angle_index,:);
% figure
% plot(centroids_angle(:,2),centroids_angle(:,3),'.');
% axis equal
sum_maxprincipalstrain_angle=sum(centroids_angle(:,4));
sum_maxprincipalstrain=sum(centroids_ROI(:,4));
anglefraction_maxprincipalstrain(l)=sum_maxprincipalstrain_angle/sum_maxprincipalstrain;
sum_minprincipalstrain_angle=sum(centroids_angle(:,5));
sum_minprincipalstrain=sum(centroids_ROI(:,5));
anglefraction_minprincipalstrain(l)=sum_minprincipalstrain_angle/sum_minprincipalstrain;

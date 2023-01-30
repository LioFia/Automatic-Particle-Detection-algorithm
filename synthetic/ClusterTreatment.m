function [bwCluster, nbCluster, numObj] = ClusterTreatment(bw, I)
	% Identigy the cluster and create another image to plot them all
    % Input : --bw the binarized image
    %         --I the image from which bw is created
    %         --plot the plot choice
    % Output: --bwCluster the binearized image containing only the
    %           clusters
    %         --nbCluster the number of particle in the clustering image
    %         --numObj the number of particle - including clusters.
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    % First criterion: particle with a large size                   
    sD = regionprops(bw,{'EquivDiameter', 'BoundingBox', 'Centroid'});
    nbPart = length(sD);
    
    D = [sD.EquivDiameter];                         % diameter vector
    thresholdD = mean(D);                           % size threshold
    PartD = find(D > thresholdD);                  	% indices of part. greater than the threshold
    labeledImageD = bwlabel(bw, 8); 
    bw_work_D = ismember(labeledImageD, PartD);  
    
    % Second criterion: eccentricity
    s = regionprops(bw_work_D, I, {'Centroid','PixelValues',...
                            'BoundingBox','Area','EquivDiameter',...
                            'WeightedCentroid','Circularity', 'Eccentricity'});
    E = [s.Eccentricity];                           % eccentricity vector
    thresholdE = mean(E);                           % eccentricity threshold
    Part = find(E > thresholdE);                    % indices of part. greater than the threshold
    labeledImage = bwlabel(bw_work_D, 8); 
    bwCluster = ismember(labeledImage, Part);  
    
    sCluster = regionprops(bwCluster, I);
    
    numObj = numel(sD);                             % number of object within the frame
    nbCluster = numel(sCluster);                    % actual cluster number
    
end
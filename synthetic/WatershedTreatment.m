function [L, num] = WatershedTreatment(bwCluster)
	% Apply the watershedding technique only to the image of the cluster to
	% reduce the time of the computations.
    % Input : --bw_cluser the binarized image of the clusters
    % Output: --L the watershedded image
    %         --num the number of particles after the watershedding
    %         technique
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    % Return if there is no cluster
    if (bwCluster == 0)
        L = 0; num = 0;
        return
    end
    
    % Calculate the distance transform of the complement of the binary image
    D = bwdist(~bwCluster,'quasi-euclidean');
    
    % Take the complement of the distance transformed image so that light
    % pixels represent high elevations and dark pixels represent low
    % elevations for the watershed transform
    D = -D;
    
    % Calculate the watershed and set the pixel outside the ROI to 0
    L = watershed(D,8);
    L(~bwCluster) = 0;
    
    % Want to get rid of the 'false' objects - objects that are not real
    % particles
    L = logical(L);
    s = regionprops(L,{'Area','Centroid','BoundingBox','SubarrayIdx','Eccentricity'});
    
    if ~isempty([s.Eccentricity])
        E = [s.Eccentricity];
        thresholdE = .9;
        Part = find((E<thresholdE) & (E~=0));                   % Indices of part. lower than the threshold
        labeledImage = bwlabel(L, 8); 
        bwAccepted = ismember(labeledImage, Part);  
    end
    
    L = bwAccepted;
    num = numel(regionprops(L));
    
end
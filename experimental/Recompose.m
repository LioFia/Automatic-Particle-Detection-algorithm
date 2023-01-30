function bwRecomp = Recompose(L, bw, bwCluster)
    % Recompose the image with the watershedded cluster image and the
    % original image. 
    % Input : --L the watershedded image
    %         --bw the binarized original image
    %         --bwCluster the binarized image of the clusters only
    % Output: --bwRecomp the binearized image with new particles
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    bwRecomp = bw - bwCluster + L;
    bwRecomp = logical(bwRecomp);
end
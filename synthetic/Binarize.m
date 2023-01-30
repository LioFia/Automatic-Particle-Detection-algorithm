function bw = Binarize(I)
    % Binarize the image and remove the noise  
    % Input : --I the original grayscale image
    % Output: --bw the binearized image
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    extraInputs = {'interpreter','latex','fontsize',18}; % name, value pairs
    thresholdValue = 90;
    
    % Apply the Otsu algorithm
    T = graythresh(I);
    bw = imbinarize(I, T);
    bw = imfill(bw, 'holes');
    bw = bwareaopen(bw,20);
    
    % Supress the particle at the edges of the image
    bw = imclearborder(bw);
    
end
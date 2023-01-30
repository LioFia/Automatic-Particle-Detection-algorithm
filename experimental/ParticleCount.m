function [t, Num, cluster, deposit] = ParticleCount(file_im, file_bg, para)
    % Count all the particles and measure deposit and cluster properties
    % for all the images with myFolder
    % Input:  --file_im the parameters of the name of the paths
    %         --file_bg the parameters of the name of the background image
    %         --para the parameters for the methods of OneImage
    %
    % Output: --t the vector of the time steps
    %         --Num the vector of the particle numbers
    %         --Cluster the structure containg the cluster number and
    %         percentage, as well as the particle number within these
    %         clusters and their percentage
    %         --deposit the structure containg the concentration, the
    %         voronoi treatment results and the granulometry results
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    % Read all the images of the folder
    fileNames = ReadAllFile(file_im.folder, file_im.name);
    
    % Initialisation
    step = para.step;
    N = numel(fileNames);                           % nb of images
    Num = zeros(ceil(N/step),1);                    % particle number
    cluster.ClusPer = zeros(ceil(N/step),1);        % cluster percentage
    cluster.Clus = zeros(ceil(N/step),1);           % cluster number
    cluster.PartClusPer = zeros(ceil(N/step),1);    % particle in cluster percentage
    cluster.PartClus = zeros(ceil(N/step),1);       % particle in cluster number
    l = 1;                                          % counting
    
    for ii = 2:step:N % for loop on the number of images
        
        baseFileName = fileNames{ii};
        fullFileName = fullfile(file_im.folder, baseFileName);
        
        [numPart, clu, res] =...
            OneImage(fullFileName, file_bg, para);
        
        cluster.ClusPer(l)      = clu.perNb;        % get the percentage of clusters in the frame
        cluster.Clus(l)         = clu.Nb;           % get the number of clusters in the frame
        cluster.PartClusPer(l)  = clu.perNb_part;	% get the percentage of particle in clusters
        cluster.PartClus(l)     = clu.Nb_part;     	% get the number of particle in clusters
        Num(l)                 = numPart;           % get the total number of particles
        deposit(l)   = res;                      	% get the deposit properties
        l = l+1;                                    % update the parameters
        
        disp(['Step :',num2str(l-1),'/',num2str(ceil(N/step))])
    end
    t = linspace(0,2560/30,numel(nonzeros(Num)));   % time vector of the acquisition
end
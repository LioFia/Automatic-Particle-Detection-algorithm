function [numPart_tot, Cluster, res] =...
          OneImage(file_im, file_bg, para)
    % Compute the number of particles in the image and their position.
    % Input : --file_im the current image
    %         --file_bg the background image
    %         --para the parameters of the algorithm
    % Output: --numPart_tot the total number of particle
    %         --Cluster a structure which contains the cluster number, the percentage of
    %         clusters, particle within the clusters and the percentage of
    %         particles within the cluster
    %         --res structure of deposit properties
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    % Read the files
    I = ReadConvert(file_im); % image
    bckg = imread(file_bg);         % background image

    % Background subtraction
    I = bckg - I; clear bckg;
    
    % Binarize the image
    bw = Binarize(I);
    
    % Identify and isolate the clusters
    [bwCluster, nbCluster, numObj] = ClusterTreatment(bw, I);
    Cluster.Nb = nbCluster; % cluster number
    
    % Apply the watershedding technique only to the clusters
    [L, numPart_wat] = WatershedTreatment(bwCluster);
    Cluster.Nb_part = numPart_wat;
    
    % Recompose the image
    bwRecomp = Recompose(L, bw, bwCluster); clear bw bwCluster L;
    
    % Separate the results regarding the size of the particles
    if para.size == 'Y' 
        s_ws = regionprops(bwRecomp,'EquivDiameter');
        
        for j = 1:length(s_ws)
            s_ws(j).New = round(s_ws(j).EquivDiameter*10)/10;   % size of the particle
        end
        D = [s_ws.New];             % particle diameter vector

        if (length(para.sz) == 1)	% for a simple value, get the particle larger than sz
            th = para.sz/.8621;
            Part = find(D>th);
            numPart_tot = length(Part);               % indices of part. greater than the threshold
            labeledImage = bwlabel(bwRecomp, 8); 
            bwRecompSize = ismember(labeledImage, Part);  
        else                        % for an interval, get the particles inside it
            th1 = para.sz(1)/.8621; th2 = para.sz(2)/.8621;
            Part = find(D > th1 & D < th2);
            numPart_tot = length(Part);
            labeledImage = bwlabel(bwRecomp, 8); 
            bwRecompSize = ismember(labeledImage, Part);  
        end
        Cluster.perNb   = nbCluster/numPart_tot*100;        % cluster percentage
        Cluster.perNb_part = numPart_wat/numPart_tot*100;   % particle within the cluster percentage
        
    else
        numPart_tot = numObj - nbCluster + numPart_wat;
        Cluster.perNb   = nbCluster/numPart_tot*100;
        Cluster.perNb_part = numPart_wat/numPart_tot*100;
    end
    
    % Update the deposit parmaters
    res.concentration = numPart_tot/2.98;   %concentration (particle number/mm2)
    
    % Voronoi treatment - computation of the homogeneity of the deposit
    voro            = VoronoiTreatment(bwRecomp);
    res.voro_x      = voro.ba;
    res.voro_pdf    = voro.voro_pdf;
    BC              = sum(sqrt((res.voro_pdf/100).*(voro.na/100)));
    res.voro_DB     = -log(BC)*100;
    res.voro_gamma = [voro.pd_g.a voro.pd_g.b];
    
    % Granulometry
    gran            = Granulometry(bwRecompSize);
    res.GranuPDF(:) = gran.pdf_g;
    res.GranuCDF(:) = gran.cdf_g;
end
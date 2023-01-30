function [res] = VoronoiTreatment(bw)
    % Compute the Voronoi diagram in order to have the cell area
    % distribution. Then, compare it with a gamma distribution to
    % quantify the homogeneity of the deposit.
    % Input : --bw the logical image on whoch the treatment is performed
    % Output: --res the structure of the homogeneity properties of the
    % deposit
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    s_v = regionprops(bw, 'Centroid');
    for ii = 1:length(s_v)
        x_v(ii) = s_v(ii).Centroid(1);
        y_v(ii) = s_v(ii).Centroid(2);
    end
    windowvoronoi   = [1; 2320; 1; 1728];	% size of the image
    tform           = affine2d(eye(3));     % define a unity matrix (for pixel value)
    part            = [x_v', y_v'];         % centroid of the particles
    if length(part)>10
        [v,c]           = voronoin(part);	% compute the edges and the seeds
        voro.Tess       = v; voro.TessKey = c; voro.test = false;
        if isinf(v(1,1))
            v(1,1) = 1e300; v(1,2) = 1e300; voro.test = true; 
        end
        
        [t_x,t_y] = transformPointsInverse(tform, v(:,1), v(:,2));% inverse transformation
        if voro.test, t_x(1) = Inf; t_y(1) = Inf; end
        
        voro.TessPx = [t_x t_y]; clear voro.test t_x t_y;            
    else
        voro.Tess       = [];
        voro.TessKey	= [];
        voro.TessPx     = [];
    end
    
    [~,areatot]     = Voronoi_EdgeTreatment(voro, windowvoronoi);
    areatot_adim    = areatot(:,1)/mean(areatot(:,1)); % adimensionalised
    C = 343/15*sqrt(7/2/pi);
    seed = max(areatot_adim).*rand(100000,1); 
    seed(find(seed<min(areatot_adim))) = [];    
    [~, res.ba] = hist(seed,ceil(sqrt(length(seed))));
    res.na = C*res.ba.^(5/2).*exp(-7*res.ba/2);
    
    y = areatot_adim(:,1);
    res.pd_g = fitdist(y, 'Gamma');
    pd = fitdist(y, 'Kernel', 'Kernel', 'normal');
    res.voro_pdf = pdf(pd, res.ba);
    
end
    
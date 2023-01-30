function [yp_true, yp_algo, yc_true, yc_algo, nb, conv, conv_std] = synth_comp(M, N, mu, sigma, step, bckg)
    
    
    imageSizeX = 1728;
    imageSizeY = 2320;
    
    x_val = 0:50;
    
    yp_true = zeros(length(x_val), M/step); yp_algo = yp_true;
    yc_true = zeros(length(x_val), M/step); yc_algo = yc_true;
    nb = zeros(M/step,1); conv = zeros(M/step,1); eps = conv; conv_std = conv;
    jj = 1;
    for ll = 1:step:M
        % Size distribution and pick N particles
        d = ceil(normrnd(mu, randi(sigma,[1 1]), [N 1]));
        
        % Pick N position on the grid
        x = randi(2320, [N 1]);
        y = randi(1728, [N 1]);
        
        % Shade 
        mask = randi([125 225], [1728 2320]);
%         mask = randi([0 50], [1728 2320]);
        % Place the particle on the background
        [columnsInImage, rowsInImage] = meshgrid(1:imageSizeY, 1:imageSizeX);
        I = bckg; 
        for ii = 1:N
            test = (rowsInImage - y(ii)).^2 + (columnsInImage - x(ii)).^2 <=(d(ii)/2).^2;
            test = uint8(test.*mask);
            I = I + test;
        end
        I = imnoise(I, 'salt & pepper', .01);
        I = imnoise(I, 'gaussian', .006);
        
        % Apply the algorithm                    
        para.method = 'otsumeth';	% 'bckgNoise' or 'tophat' or 'Otsu' or 'HP' or 'no'
        para.plt = 'N';             % plot each step
        para.granu = 'N';           % compute the granulometry
        para.record = 'N';          % film of the clusters
        para.size = 'N';            % consider only some particles regarding their size
        para.sz = 10/.8621;         % size of particle to consider

        % Binarize the image
        bw = Binarize(I);

        % Identify and isolate the clusters
        [bwCluster, nbCluster, numObj] = ClusterTreatment(bw, I);

        % Apply the watershedding technique only to the clusters
        [L, numPart_wat] = WatershedTreatment(bwCluster);

        % Recompose the image
        bwRecomp = Recompose(L, bw, bwCluster);

        % Separate the results regarding the size of the particles
        if para.size == 'Y' 
            s_ws = regionprops(bwRecomp,'EquivDiameter');
            for j = 1:length(s_ws)
                s_ws(j).New = round(s_ws(j).EquivDiameter*10)/10;   % size of the particle
            end
            D = [s_ws.New];             % particle diameter vector

            if (length(para.sz) == 1)	% for a simple value
                th = para.sz;
                Part = find(D>th);
                numPart_tot = length(Part);
            else                        % for an interval
                th1 = para.sz(1); th2 = para.sz(2);
                Part = find(D > th1 & D < th2);
                numPart_tot = length(Part);
            end
        else
            numPart_tot = numObj - nbCluster + numPart_wat;
        end

        % Concentration
        s_ws = regionprops(bwRecomp,{'Area', 'EquivDiameter'});

        clear L bw bwCluster 

        % PDF
        y_val = [s_ws.EquivDiameter];
        x_val = 0:50;
        pdf_algo = fitdist(y_val', 'Kernel', 'Kernel', 'normal');
        yp_algo(:,ll) = pdf(pdf_algo, x_val);
        yc_algo(:,ll) = cdf(pdf_algo, x_val);

        pdf_true = fitdist(d, 'Normal');
        yp_true(:,ll) = pdf(pdf_true, x_val);
        yc_true(:,ll) = cdf(pdf_true, x_val);
        
        nb(jj) = numPart_tot;
        eps(jj) = abs(N-nb(jj))/nb(jj);

        disp([num2str(jj),'/',num2str(M/step)])
        jj = jj + 1;
    end
end
function [res] = Granulometry(bwRecomp)
    % Calculate the size distribution of the particles in the first image of an
    % experiment. 
    % Input : --bwRecomp the binarized image after all the calculations
    %         --nbFrame the current frame
    %         --para the parameters for the methods
    % Output: --res the structure containing the particle size pdf and cdf 
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    s = regionprops(bwRecomp, 'EquivDiameter');
    y_val = [s.EquivDiameter]'*.8621;
    
    x_val = 10:60;
    pd_f = fitdist(y_val, 'Kernel', 'Kernel', 'normal');
    y_pdf= pdf(pd_f, x_val);
    y_cdf = cdf(pd_f, x_val);
    
    res.pdf_g = y_pdf*100;
    res.cdf_g = y_cdf*100;
    
end
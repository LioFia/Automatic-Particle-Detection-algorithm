function I = ReadConvert(file)
    % Read and convert the image into a matrix. 
    % Input : --file the name of the file that we want to open and read
    % Output: --I the converted image
    %
    % Author: corentincazes
    %
    % Date: 10/10/2020
    %
    
    % Read the image and 'convert' it into a matrix
    I = imread(file);
    convert = size(I);                                      
    
    if (numel(convert) == 3)
        I = rgb2gray(I);	% Convert into a grayscale image
    end
end
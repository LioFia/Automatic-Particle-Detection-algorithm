function fileNames = ReadAllFile(myFolder, name)
    % Read and convert all the image of a folder into matrices 
    % Input : --myFolder folder where the images are contained
    %
    % Output: --fileNames contains all the name of the files
    
    dirOutput = dir(fullfile(myFolder,name));
    fileNames = {dirOutput.name}';
    
end
%Author: Jacob Gildenblat, 2014
%Compares the learned Visual Vocabulary and the image training\cross
%validation set, and computes histogram vectors.

function [D labels] = CalcHistograms(codebook, blockSize, patchSize, directories)
    
    %Count the number of total .png images that will be used.
    %We need this to pre-allocate the histograms for speed.
    num = 0;
%     for i = 1 : length(directories)
%         directory = char(directories(i));
%         num = num + length(dir([directory, '/', '*.png']));      
%     end
%     
%     if TrainSet == 1
%         num = round(num * trainSetPercentage);
%     else
%         num = round(num * (1-trainSetPercentage));
%     end
    
    D = zeros(num, size(codebook, 1));
    labels = zeros(num, 1);
    
    index = 1;
    for i = 1 : length(directories)
        directory = char(directories(i));
        imagefiles = dir([directory, '/', '*.png']);      
        nfiles = 30;    % Number of files found
%         label = (i == 1) * -2 + 1;
        label = i;
        
%         if (TrainSet == 1)
%             files = 1 : round(nfiles*trainSetPercentage);
%         else
%             files = (round(nfiles*trainSetPercentage) + 1) : nfiles;
%         end
        files = 1 : nfiles;
        
        for ii = files
           img = imread([directory ,'/', imagefiles(ii).name]);
%            if size(img , 1) < patchSize(1) || size(img, 2) < patchSize(2)
%                 continue;
%            end           
           imgr = imresize(img, [80 88]); %resize for mathworks lib
           if (size(imgr , 1) < patchSize(1) * 2 || size(imgr, 2) < patchSize(2) * 2)
               continue;
           end
           patches = ExtractHogPatches(imgr, patchSize, blockSize);
           
           D(index, : ) =  feature_histogram(codebook, patches);
           labels(index) = label;
           index = index + 1;
        end
    end
    D = D;
    labels = labels';
end

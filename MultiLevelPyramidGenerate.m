function [ pyramid ] = MultiLevelPyramidGenerate( inputImage ,gussianKernelCentreWeight , level )

    pyramid = cell(1,level);
    multiScaleImages = cell(1,level + 1);
    multiScaleImages{1} = im2double(inputImage);
    
    for i = 2:level + 1
        multiScaleImages{i} = GussianPyramid( multiScaleImages{i-1} ,gussianKernelCentreWeight, 'reduce');
    end
    
    for i = 2:level + 1
        expandedImages = GussianPyramid( multiScaleImages{i} ,gussianKernelCentreWeight, 'expand');
        expandedImages = imresize(expandedImages,[size(multiScaleImages{i-1},1) size(multiScaleImages{i-1},2)]);
        pyramid{i - 1} = multiScaleImages{i - 1} - expandedImages;
    end

end
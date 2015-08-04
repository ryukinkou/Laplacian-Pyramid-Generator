function [ ] = Generate( directory ,imageSuffix ,gussianKernelCentreWeight ,pyramidLevel  )

images = dir(fullfile(directory,strcat('*.',imageSuffix)));

for i = 1:length(images)
    
    image = imread(strcat(directory,images(i).name));
    pyramid = MultiLevelPyramidGenerate(image,gussianKernelCentreWeight,pyramidLevel);
    
    for j = 1:length(pyramid)
    
        pyramidImageName = strcat(directory,strrep(images(i).name,strcat('.',imageSuffix),''),'_level_',num2str(j),strcat('.',imageSuffix));
        imwrite(pyramid{j},pyramidImageName,imageSuffix);
    
    end
    
end

end


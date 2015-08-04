function [ outputImage ] = GussianPyramid( inputImage ,gussianKernelCentreWeight , reduceOrExpand )

if strcmp(reduceOrExpand,'reduce')
    outputImage = PyramidReduce (inputImage , gussianKernelCentreWeight);
elseif strcmp(reduceOrExpand,'expand')
    outputImage = PyramidExpand (inputImage , gussianKernelCentreWeight);
end
end

function [ outputImage ] = PyramidReduce( inputImage , gussianKernelCentreWeight )
%	PyramidReduce Image pyramid reduction
%   B = PyramidReduce( A )  If A is M-by-N, then the size of B
%	is ceil(M/2)-by-ceil(N/2). Support gray or rgb image.
%	B will be transformed to double class.
%	Results the same w/ MATLAB funcation impyramid( A , 'reduce' ).

% creating Gaussian kernel
% reference: http://www.cs.utah.edu/~arul/report/node12.html
kernel = Create5plus5Kernel( gussianKernelCentreWeight );

inputImage = im2double(inputImage);
imageSize = size(inputImage);
outputImage = [];

% RGB have 3 channels
for i = 1:size(inputImage,3)
    
    imageChannel = inputImage(:,:,i);
    % convolution
    channelFiltered = imfilter(imageChannel,kernel,'replicate','same');
    outputImage(:,:,i) = channelFiltered(1:2:imageSize(1),1:2:imageSize(2));
end

end

function [ outputImage ] = PyramidExpand( inputImage , gussianKernelCentreWeight )
%   PyramidExpand Image pyramid expansion
%   B = PYR_EXPAND( A )  If A is M-by-N, then the size of B
%	is (2*M-1)-by-(2*N-1). Support gray or rgb image.
%	B will be transformed to double class.
%	Results the same w/ MATLAB func impyramid( A , 'expand' ) .

kernelWidth = 5; % default kernel width
kernel = Create5plus5Kernel( gussianKernelCentreWeight );
kernel = kernel*4;

% expand [a] to [A00 A01;A10 A11] with 4 kernels
% choose kernel patch from kernel
%point index 1,1 1,3 1,5 3,1 3,3 3,5 5,1 5,3 5,5
ker00 = kernel(1:2:kernelWidth,1:2:kernelWidth); % 3*3
%point index 2,2 2,4 4,2 4,4
ker01 = kernel(1:2:kernelWidth,2:2:kernelWidth); % 3*2
%point index 1,2 1,4 3,2 3,4 5,2 5,4
ker10 = kernel(2:2:kernelWidth,1:2:kernelWidth); % 2*3
%point index 2,2 2,4 4,2 4,4
ker11 = kernel(2:2:kernelWidth,2:2:kernelWidth); % 2*2

inputImage = im2double(inputImage);
expandedImageSize = size(inputImage(:,:,1)) * 2 - 1;
outputImage = zeros(expandedImageSize(1),expandedImageSize(2),size(inputImage,3));

for i = 1:size(inputImage,3)
    imageChannel = inputImage(:,:,i);
    
    % extend one column in both side
    imageColumnExtended = padarray(imageChannel,[0 1],'replicate','both');
    % extend one row in both side
    imageRowExtended = padarray(imageChannel,[1 0],'replicate','both');
    
    img00 = imfilter(imageChannel,ker00,'replicate','same');
    img01 = conv2(imageRowExtended,ker01,'valid');
    img10 = conv2(imageColumnExtended,ker10,'valid');
    img11 = conv2(imageChannel,ker11,'valid');
    
    outputImage(1:2:expandedImageSize(1),1:2:expandedImageSize(2),i) = img00;
    outputImage(2:2:expandedImageSize(1),1:2:expandedImageSize(2),i) = img10;
    outputImage(1:2:expandedImageSize(1),2:2:expandedImageSize(2),i) = img01;
    outputImage(2:2:expandedImageSize(1),2:2:expandedImageSize(2),i) = img11;
end

end

function [ kernel ] = Create5plus5Kernel( centreWight )
%   PyramidExpand Image pyramid expansion
ker1d = [ (0.25-centreWight/2) 0.25 centreWight 0.25 (0.25-centreWight/2) ];
kernel = kron(ker1d,ker1d');
end
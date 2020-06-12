%First Step is to recognize the number of plates in image
%Then get each plate separated to process
%This function take image and return the regionprops of each plate in image
%This function will be used in recognizing plates 
%It also will be used in rotated image problem
function[platesNums]=platesDetection(coloredImage)
%Convert to grayScale
image=rgb2gray(coloredImage);

%Use clf to clear figure
clf;
subplot(3,3,1)
imshow(image)
title('Orginal Image')

%Structual element will be used
se=strel('disk',1);

%Threshold and binarize
bin=image<128;
subplot(3,3,2)
imshow(bin)
title('Binary image')

%Dialte to make borders of palte detectable
binDil=imdilate(bin,se);
subplot(3,3,3)  
imshow(binDil)
title('Dilate Image')

%use fill holes to get plates as connected shape
filled=imfill(bin,'holes');
subplot(3,3,4)  
imshow(filled);
title('Plates in image')

%Remove small pixels and save only plate shape
numberOfArea = bwareaopen(binDil, 600);
%Get region Prop
regionProp=regionprops(numberOfArea,'Area','BoundingBox','Orientation');
subplot(3,3,5)
imshow(numberOfArea);
title('Plates with rectanlge border')
%Draw rectangle on plates
hold on
for i = 1:length(regionProp)
    box=regionProp(i).BoundingBox;
    rectangle('Position', [box(1),box(2),box(3),box(4)], 'Linewidth', 1, 'EdgeColor', 'r');
end
hold off

message = sprintf('Dectect plates function results');
questdlg(message, 'Plate Detection', 'Continue','Continue');
platesNums=regionProp;



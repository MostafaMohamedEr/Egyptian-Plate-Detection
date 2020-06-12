%This function for extracting plate from rotated plates
function[rotatedImage]=rotatedPlate(image,rotationAngel)
coloredImage=image;
%Convert to grayScale
image=rgb2gray(image);
se=strel('disk',2);
%First thrshold the image 
binaryImage=image<128;
%Use clf to clear subplot first
clf;
subplot(2,3,1)
imshow(binaryImage);
title('Binary image')

%Dilate it to connect rectangle pixels of plate
dilatedImage=imdilate(binaryImage,se);
subplot(2,3,2)
imshow(dilatedImage);
title('Connected plate')

%Rotate the image to get positions of plate after rotating 
rotated=imrotate(dilatedImage,rotationAngel);
subplot(2,3,3)
imshow(rotated)
title('Rotated Image');

%Then fill image to get position of rectangle
filled=imfill(rotated,'holes');
%Remove some pixels to save only plate shape
Plate = bwareaopen(filled, 500);

%Get plate positions
regionProp=regionprops(Plate,'BoundingBox');
subplot(2,3,4)
imshow(Plate);
title('Plates with rectanlge border')

%Draw rectangle on plate
hold on
for i = 1:length(regionProp)
    box=regionProp(i).BoundingBox;
    rectangle('Position', [box(1),box(2),box(3),box(4)], 'Linewidth', 1, 'EdgeColor', 'r');
end
hold off

%Then rotate the orignal grayscale image 
OrginalRotated=imrotate(coloredImage,rotationAngel);
subplot(2,3,5)
imshow(OrginalRotated);
title('full image')

%Then get the plate 
b=regionProp(1).BoundingBox;
rotatedImage = imcrop(OrginalRotated, [b(1),b(2),b(3),b(4)]);
subplot(2,3,6)
imshow(rotatedImage);
title('Plate image')

message = sprintf('Dectect Rotated image');
questdlg(message, 'Rotated Image', 'Continue','Continue');

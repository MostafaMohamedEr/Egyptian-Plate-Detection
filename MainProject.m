clear
clc
%A browse box for easier testing
[image,path] = uigetfile({'*.jpg';'*.png';},'Select a image');
%Reading the image
coloredImage=imread(fullfile(path,image));
%Pass the image to plateDetection function to get structure of plates loction
platesRegions=platesDetection(coloredImage);

%Number of plates in image
numberOfPlates=numel(platesRegions);
%Intialize cell of images to number of detected plates
imageList=cell(length(numberOfPlates),1);

%Get Each Plate separated
for i=1:numberOfPlates
    b=platesRegions(i).BoundingBox;
    %Check if the image is rotated by using region orientation
    croppedImage = imcrop(coloredImage, [b(1),b(2),b(3),b(4)]);
    %IF image is rotated then , pass the image to rotation function
    if platesRegions(i).Orientation >10 || platesRegions(i).Orientation<-10
        croppedImage=rotatedPlate(croppedImage, (-platesRegions(i).Orientation) );
        imageList{i}=croppedImage;
    else
        imageList{i}=croppedImage;
    end
end

%Use clf to clear window ,then plot
clf;
info=cell(numberOfPlates,1);
for i=1:numberOfPlates
    %Get the cutpoint of plate bases on that egyptian plate dimension are 17cm* 32cm
    %And the top plate is 63cm height of plate ,so we get the cut point by (63/170)
    Height=size(imageList{i},1);
    cut=ceil(Height*(0.37));
    %Pass top plate to color function to get car type
    carType=colorDetection(imageList{i},cut);
    carType=strcat("\n Vehicle : ",carType);
    %Pass bottom plate to detect government
    carGoverno=characterDetection(imageList{i},cut);
    info{i}=strcat(carGoverno,carType);
end

clf;
for i=1:numberOfPlates
    subplot(2,2,i)
    imshow(imageList{i});
    title('Plate '+ string(i));
    xlabel(sprintf(info{i}));
end



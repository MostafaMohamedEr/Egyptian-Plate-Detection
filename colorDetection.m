function[kind]=colorDetection(coloredImage,cutPoint)

%Get Greyscale of image
greyScaleImage=rgb2gray(coloredImage);

%Get gray scale and channels that needed
RedChannel=coloredImage(1:cutPoint,:,1);
BlueChannel=coloredImage(1:cutPoint,:,3);
greyScaleImage=greyScaleImage(1:cutPoint,:);

%Color detection function based on calculating mean of components of each color then get the nearest result
%First we have to calculate each color 
%To get red Color only we have to subtract gray scale from red channel
redColor=imsubtract(RedChannel,greyScaleImage);
%Orange Color is mixture of red and green ,so to get orange color we have to subtract blue channel from gray scale 
orangeColor=imsubtract(greyScaleImage,BlueChannel);
%LightBlue(i think color of plate is dodgar blue) consists of blue and green mixture, so we subtract red channel from grayscale image
lightBlue=imsubtract(greyScaleImage,RedChannel);
%Gray color is easily defiend as dividing the there channels / 3 (Average of there channels)
greyColor=greyScaleImage/3;

%Then we calculate mean of four colors and color of plate belongs to color with maxium mean
redMean=mean(redColor(:));
orangeMean=mean(orangeColor(:));
blueMean=mean(lightBlue(:));
greyMean=mean(greyColor(:));

%we get highest value(highest value means that image contain pixels of this color)
nearestColor=max([redMean,orangeMean,blueMean,greyMean]);

switch nearestColor
    case redMean 
        kind='Transport';
    case orangeMean
        kind='Taxi';
    case blueMean
        kind='Owner cars';
    case greyMean
        kind='government cars ';
end
end


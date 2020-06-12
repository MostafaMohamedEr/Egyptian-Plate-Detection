function[city]=characterDetection(coloredImage,cutPoint)
%Function based on segment each charcter then use cross correlation with
%images in template that i created then decide num
%First Read and load template for arabic letters

path="letters\\"; 
%Get all bmp images in file by using *
letterImages= dir(strcat(path,'*.bmp'));
%Read lettersImages to cell of array
letterTemplate=cell(length(letterImages),1);
for i=1:length(letterImages)
    letterTemplate{i}=imread(strcat(path,letterImages(i).name));
    %%Convert rgb to gray if it is rgb
    if size(letterTemplate{i},3)==3
        letterTemplate{i}=rgb2gray(letterTemplate{i});
    end
    letterTemplate{i}=letterTemplate{i};
end

%Read template for arabic numbersg
path="numbers\\"; 
%Get all bmp images in file by using *
numberImages= dir(strcat(path,'*.bmp'));
%Read numberImages to cell of images
numberTemplate=cell(length(numberImages),1);
for i=1:length(numberImages)
    numberTemplate{i}=imread(strcat(path,numberImages(i).name));
    %%Convert rgb to gray if it is rgb
    if size(numberTemplate{i},3)==3
        numberTemplate{i}=rgb2gray(numberTemplate{i});
    end
    numberTemplate{i}=numberTemplate{i};
end

%After reading the template ,we should extract charcters from plate
Height=size(coloredImage,1);
bottomPlate=coloredImage(cutPoint:Height,:,:);
%Convert to grayscale
grayImage=rgb2gray(bottomPlate);
%Convert to binary
b1=~imbinarize(grayImage);
%Structual element
se=strel('disk',1);
%Dilate not to lose points of charcters 
dilated=imdilate(b1,se);
%Then filtering ang get charcters only and avoid borders and small pixels
realLetters=bwareafilt(dilated,[10 400]);
%get the charcters using regionprops boundingbox 
plateRegion=regionprops(realLetters,'BoundingBox');
%This condition if there are nosiy elements or unncessary elments
%As it is known maxium number of charcters in plate is 7 , if there are
%more than 7,then it must be unnecssary elments ,so removing it usingerode
if length(plateRegion)>7
    realLetters=imerode(realLetters,strel('disk',1)');
    realLetters=bwareafilt(realLetters,[50 300]);
    plateRegion=regionprops(realLetters,'BoundingBox','Area');
end
%then separate each plate Charcter
plateLetter=cell(length(plateRegion),1);
%save charcters in charList to return it
charList=cell(length(plateRegion),1);

clf
for i = 1 : length(plateRegion)
    %Get position of charcter and crop it from plate image
     rect = plateRegion(i).BoundingBox;
     charList{i}=imcrop(grayImage,rect);
     plateLetter{i}=imcrop(dilated,rect);
     plateLetter{i}=imerode(plateLetter{i},strel('disk',1));
     plateLetter{i}=imresize(plateLetter{i},[50 50]);
end

%Create cell for features to store calculations of cross correlation
%Cell consists of two layes first layer consist of number of plate charcters
%Second layer is array of size 28 (number of charcters)
letterFeatures=cell(length(plateRegion),1);
for i=1:length(letterFeatures)
    letterFeatures{i}=zeros(length(letterImages),1);
end

%Calculating cross correlation of each charcter in plate with the letters set
for i=1:length(plateRegion)
    for j=1:length(letterImages)
    letterFeatures{i}(j)=corr2(letterTemplate{j},plateLetter{i});
    end
end

%Create cell for features to store calculations of cross correlation
%Cell consists of two layes first layer consist of number of plate charcters
%Second layer is array of numbers
numberFeatures=cell(length(plateRegion),1);
for i=1:length(plateRegion)
    numberFeatures{i}=zeros(length(numberImages),1);
end

%Calculating cross correlation of each charcter in plate with the numbers set
for i=1:length(plateRegion)
    for j=1:length(numberImages)
    numberFeatures{i}(j)=corr2(numberTemplate{j},plateLetter{i});
    end
end


%Counter to count occurance of numbers
numberCount=0;
for i=1:length(plateRegion)
    %Take the nearest shape in numbers and in charcters to the plate charcter
    maxLetter=max(letterFeatures{i});
    maxNumber=max(numberFeatures{i});  
    %Then compare if charcter in plate is letter do no thing
    if maxLetter>maxNumber
        continue;
    %If charcter in plate is number increase the counter of numbers
    else
        numberCount=numberCount+1;
    end
end

%Set the conditions to detect car governorate
if length(plateRegion)==6 && numberCount==3
   city='Cairo';
   city=strcat("Character=6,Numbers=3\nCity :",city);
elseif length(plateRegion)==6 && numberCount==4
   city='Giza';
   city=strcat("Character=6,Numbers=4\nCity :",city);
else
   city='Other governorate ';
   city=strcat("Character=7,Numbers=4 \n City :",city);
end

%Loop to show charcters of plate
      for i = 1 : length(plateRegion)
          subplot(2,length(plateRegion),i)
          %Resize only for better visualization
          imshow(imresize(charList{i},[50 50]));
          subplot(2,length(plateRegion),i+length(plateRegion))
          imshow(imresize(plateLetter{i},[50 50]));
          t=strcat('Charcter : ',int2str(i));
          title(t)
          if i<=numberCount
              xlabel('Number');
          else
             xlabel('Letter');
          end
      end
message = sprintf('Charcters Detection');
questdlg(message, 'Show Chars', 'Continue','Continue');




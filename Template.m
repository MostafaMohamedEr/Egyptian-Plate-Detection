letters=imread('dataset\\letters.jpg');

%RGB to gray
if size(letters,3)>1
    letters=rgb2gray(letters);
end

%Binarize
letters=imbinarize(letters);

% process data to get accurate positions of letters
 se=strel('disk',2);
 se2=strel('disk',3);
 letterWithPoints=imdilate(letters,se);
 spearted=regionprops(letterWithPoints,'BoundingBox');
 
%Save letters in cell
 lettersSeparted=cell(28,1);
 for i=1:28
     rect = spearted(i).BoundingBox;
     lettersSeparted{i}=imcrop(letters,rect);
     lettersSeparted{i}=imresize(lettersSeparted{i},[50 50]);
     subplot(4,7,i)
     imshow(lettersSeparted{i});
 end
 
 disp('Press Any button to continue')
 %waitforbuttonpress;
 
  %Based on order of reading charters
 Array=["mem.bmp","een.bmp","sen.bmp",'hah.bmp','zah.bmp','lam.bmp','yaa.bmp','gim.bmp','zen.bmp','taa.bmp'....
     'kaf.bmp','tha.bmp','raa.bmp','waw.bmp','dad.bmp','kaff.bmp','teh.bmp','zaa.bmp','haa.bmp','sad.bmp',....
     'dal.bmp','baa.bmp','faa.bmp','non.bmp','kha.bmp','alf.bmp','shn.bmp','khn.bmp'];
 
%Write charceters in folder of template
%We can see that letter haa is not as required ,so we will ignore it 
 for i=1:28
     if strcmp(Array(i),'haa.bmp')==1
         continue
     end
     imwrite(lettersSeparted{i},fullfile("letters\" ,Array(i) ));
 end
 
clf
%Create haa 
haa=rgb2gray(imread('dataset\\heh.bmp'));
haa=imbinarize(haa);
haa=imresize(haa,[150 150]);
haa=imerode(haa,se);
haa=bwareaopen(haa,5);
haRegion=regionprops(haa,'BoundingBox','Area'); 
newHa=imcrop(haa,haRegion(1).BoundingBox);
newHa=imresize(newHa,[50 50]);
imwrite(newHa,fullfile("letters\" ,"haa.bmp" ));
imshow(newHa)
disp('Press Any button to continue')
%waitforbuttonpress;


%Create Numbers
numbers=rgb2gray(imread('dataset\\numbers.jpg'));
numbers=~imbinarize(numbers);
numbers=imerode(numbers,strel('disk',1));
numbersRegion=regionprops(numbers,'BoundingBox');
%Save numbers in cell
 numbersSeparted=cell(10,1);
 numberArray=["num5.bmp",'num0.bmp','num9.bmp','num4.bmp','num8.bmp','num3.bmp','num7.bmp'....
     'num2.bmp','num6.bmp','num1.bmp'];
 clf;
 for i=1:10
     rect = numbersRegion(i).BoundingBox;
     numbersSeparted{i}=imcrop(numbers,rect);
     %in case of number 5 we need it filled because in segmented plate characters five is filled
     if strcmp(numberArray(i),'num5.bmp')==1
         numbersSeparted{i}=imfill(numbersSeparted{i},'holes');
         numbersSeparted{i}=imerode(numbersSeparted{i},strel('disk',6));
     end
     numbersSeparted{i}=imresize(numbersSeparted{i},[50 50]);
      subplot(2,5,i)
     imshow(numbersSeparted{i});
 end
 %Numbers with order of identification
 
%Write numbers to its file 
for i=1:10
     if strcmp(numberArray(i),"num0.bmp")==1
         numbersSeparted{i}=imerode(numbersSeparted{i},strel('disk',7));
     elseif strcmp(numberArray(i),"num1.bmp")==1
         numbersSeparted{i}=imerode(numbersSeparted{i},strel('disk',4)); 
     elseif strcmp(numberArray(i),"num9.bmp")==1
         imwrite(imfill(numbersSeparted{i},'holes'),fullfile("numbers\","num9F.bmp"));
     end
     imwrite(numbersSeparted{i},fullfile("numbers\",numberArray(i)));
 end

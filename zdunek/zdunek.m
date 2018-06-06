% Paper Zdunek et al. (2013)
% The biospeckle method for investigation of agricultural crops: a review

% Created on: 2018.06.06

clear all
close all
clc

% Load input image
pathImgs='C:\Users\Pingu\Pictures\Biospeckle\exp180523-tomates-meiaFase\tomate1\180523-093656\';
ext='.png';
N=128;

for id=0:N-1
    fileName=[pathImgs,num2str(id,'%06d'),ext];
    temp=rgb2gray(imread(fileName));
    if(id==0)
        temp_row0=0.5*size(temp,1);
        temp_row1=0.9*size(temp,1);
        temp_col0=0.1*size(temp,2);
        temp_col1=0.4*size(temp,2);
        imgs=uint8(zeros(temp_row1-temp_row0+1,temp_col1-temp_col0+1,N));
    end
    imgs(:,:,id+1)=temp(temp_row0:temp_row1,temp_col0:temp_col1);
end

figure;
subplot(3,3,1); imshow(imgs(:,:,1)); title('0');
subplot(3,3,2); imshow(imgs(:,:,20)); title('19');
subplot(3,3,3); imshow(imgs(:,:,40)); title('39');
subplot(3,3,4); imshow(imgs(:,:,60)); title('59');
subplot(3,3,5); imshow(imgs(:,:,80)); title('79');
subplot(3,3,6); imshow(imgs(:,:,100)); title('99');
subplot(3,3,7); imshow(imgs(:,:,120)); title('119');
subplot(3,3,8); imshow(imgs(:,:,128)); title('127');




clear temp*
clc;clear;close all;
I =imread('Fig1038.tif');
level =global_threshold(I);           
J = imbinarize(I,level);    
subplot(121)
imshow(I);
title('original image');
subplot(122)
imshow(J);
title('after global threshold');
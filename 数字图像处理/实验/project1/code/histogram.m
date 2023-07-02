clear;clc;close all;
% 读取图像
image=imread('spine.tif');
% 直方图均衡
image_hist = histeq(image);
figure(1);
subplot(1,2,1);imshow(image);title('原图');
subplot(1,2,2);imshow(image_hist);title('均衡化后');
figure(2);
subplot(1,2,1);imhist(image);title('原图像直方图');
subplot(1,2,2);imhist(image_hist);title('均衡化后直方图');

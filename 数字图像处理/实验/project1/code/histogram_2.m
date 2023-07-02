clear;clc;close all;
x=-25:1:-6;
y=[-30.88,-29.92,-28.98,-28.08,-27.16,-26.28,-25.41,-24.60,-23.78,-23.02,-22.33,-21.71,-21.14,-20.62,-20.22,-19.86,-19.56,-19.33,-19.15,-19.01];
z=((30.88-25.41)/6)*(x+25)-30.88;










% pic_ori = imread('spine.tif');
% size = size(pic_ori);
% % 若图像是rbg的，则转化为灰度图
% if( numel(size) > 2 )
%     pic_ori = rgb2gray(pic_ori);
%     size = size(pic_ori);
% end
% height = size(1);
% width = size(2);
% gray_level = 256;
% 
% % 获取灰度值频数分布
% P = zeros(gray_level,1);
% for i = 1:height
%     for j = 1:width
%         gray_value = pic_ori(i,j)+1;
%         P(gray_value) = P(gray_value) + 1;
%     end
% end
% 
% % 获得灰度值累积分布
% cdf = zeros(gray_level,1);
% cdf(1) = P(1);
% cdf_min = 0;
% for i = 2:gray_level
%     cdf(i) = cdf(i-1) + P(i);
%     if(cdf_min == 0 && cdf(i) > 0)
%         cdf_min = cdf(i);
%     end
% end
% 
% % 对灰度值累积分布进行转化
% cdf_equal = zeros(gray_level, 1);
% for i = 1:gray_level
%     cdf_equal(i) = round( (cdf(i)-cdf_min) / (height * width - cdf_min) * (gray_level - 1) ) + 1;
% end
% 
% % 计算图像像素点新的灰度值
% pic_equal = pic_ori;
% for i = 1:height
%     for j = 1:width
%         pic_equal(i,j) = cdf_equal( pic_equal(i,j) + 1 );
%     end
% end
% 
% % 获取均衡后的灰度值频数分布
% P_equal = zeros(gray_level,1);
% for i = 1:height
%     for j = 1:width
%         gray_value = pic_equal(i,j)+1;
%         P(gray_value) = P(gray_value) + 1;
%     end
% end
% figure(1);
% subplot(121);imshow(pic_ori);title('原图')
% subplot(122);imshow(pic_equal);title('均衡化后');
% figure(2);
% subplot(121);imhist(pic_ori);title('原图像直方图');
% subplot(122);imhist(pic_equal);title('均衡化后直方图');
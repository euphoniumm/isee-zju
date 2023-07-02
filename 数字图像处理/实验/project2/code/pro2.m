clear; clc; close all
%% 主函数
image= imread('./5_7.TIF');

% 原图像
subplot(1, 3, 1)
imshow(image)
title('original image')

% 加噪图像
image_noise = imnoise(image, 'salt & pepper', 0.2);
subplot(1, 3, 2)
imshow(image_noise)
title('image with salt & papper noise')

% 恢复图像
image_filtered = median_filter(image_noise);
subplot(1, 3, 3)
imshow(image_filtered)
title('image after median filter')

figure(2);
subplot(121);imshow(image_filtered);title('image after median filter self design');
subplot(122);imshow(medfilt2(image_noise));title('image after median filter standard');

%% 3*3中值滤波器
function image_filter = median_filter(image) % 彩色图中值滤波器

% 获取图像大小
[rows, cols, k] = size(image);

% 创建矩阵，用于存储结果
image_filter = zeros(rows, cols, 'uint8');

% 对边界像素进行扩展
image_extend = zeros(rows+2, cols+2, 'uint8');
image_extend(:,:) = padarray(image(:,:), [1, 1]);

for i = 1:rows
    for j = 1:cols
        Rect = double(image_extend(i:i+2, j:j+2));
        image_filter(i, j) = uint8(median(Rect, 'all')); 
    end
end

end
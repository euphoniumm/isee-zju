close all;clc;clear;

% load image and display
img = imread('Fig110.tif');
figure(1);subplot(1,2,1);
imshow(img);
title('original image');

% read basic image information
img = double(img);
[M, N] = size(img);
gray_level = 256;
R = zeros(M, N);
G = zeros(M, N);
B = zeros(M, N);

% process four gray levels separately
for i = 1:M
    for j = 1:N
        if(img(i, j) < 20)
            R(i,j) = gray_level;
            G(i,j) = gray_level;
            B(i,j) = 0;
        else if(img(i, j) > 1)
                R(i, j) = img(i, j);
                G(i, j) = img(i, j);
                B(i, j) = img(i, j);
            end
        end
    end
end

% merge three channels of RBG
img1 = zeros(M, N);
for i = 1:M
    for j = 1:N
        img1(i, j, 1) = R(i, j);
        img1(i, j, 2) = G(i, j);
        img1(i, j, 3) = B(i, j);
    end
end
img1 = img1 / 256;

subplot(1,2,2);
imshow(img1);
title('Pseudo-Color');
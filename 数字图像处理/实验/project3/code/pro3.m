close all;clc;clear;

% load image and display
img = imread('Fig623.tif');
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
        if(img(i, j) < gray_level/4)
            R(i, j) = 0;
            G(i, j) = 4 * img(i, j);
            B(i, j) = gray_level;
        else if(img(i, j) < gray_level/2)
                R(i, j) = 0;
                G(i, j) = gray_level;
                B(i, j) = gray_level*2 - 4 * img(i, j);
            else if(img(i, j) < 3*gray_level/4)
                    R(i, j) = 4 * img(i, j) - gray_level*2;
                    G(i, j) = gray_level;
                    B(i, j) = 0;
                else
                    R(i, j) = gray_level;
                    G(i, j) = 4 * gray_level - 4 * img(i, j);
                    B(i, j) = 0;
                end
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
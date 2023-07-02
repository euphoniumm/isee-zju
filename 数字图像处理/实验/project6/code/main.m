clear all;
close all;
clc;
 
img=imread('fig.tif');
[m n]=size(img);
 
imgn=zeros(m,n);        %边界标记图像
ed=[-1 -1;0 -1;1 -1;1 0;1 1;0 1;-1 1;-1 0]; %从左上角像素，逆时针搜索
for i=2:m-1
    for j=2:n-1
        if img(i,j)==1 && imgn(i,j)==0      %当前是没标记的白色像素
            if sum(sum(img(i-1:i+1,j-1:j+1)))~=9    %块内部的白像素不标记
                ii=i;         %像素块内部搜寻使用的坐标
                jj=j;
                imgn(i,j)=2;    %本像素块第一个标记的边界，第一个边界像素为2
                
                while imgn(ii,jj)~=2    %是否沿着像素块搜寻一圈了。
                    for k=1:8           %逆时针八邻域搜索
                        tmpi=ii+ed(k,1);        %八邻域临时坐标
                        tmpj=jj+ed(k,2);
                        if img(tmpi,tmpj)==1 && imgn(tmpi,tmpj)~=2  %搜索到新边界，并且没有搜索一圈
                            ii=tmpi;        %更新内部搜寻坐标，继续搜索
                            jj=tmpj;
                            imgn(ii,jj)=1;  %边界标记图像该像素标记，普通边界为1
                            break;
                        end
                    end
                end
                
            end
        end
    end
end
 
figure;
imgn=imgn>=1;
subplot(1,2,2);
imshow(imgn,[]);
title('边界')
subplot(1,2,1);
imshow(img);
title('原图')
 
% %不过要是真取二值图像内边界，通常是原图减去其腐蚀图就行了
% se = strel('square',3); 
% imgn=img-imerode(img,se);    
% figure;
% imshow(imgn)
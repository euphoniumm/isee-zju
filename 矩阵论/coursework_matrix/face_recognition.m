clear all;
close all;

%任务一
%加载数据
load('YaleBExtend.mat');

%得到6*6的人脸矩阵face_all
face1=[];
for i=1:6
    face1=[face1,reshape(X{1,i}(:,1),192,168)];
end
face2=[];
for i=7:12
    face2=[face2,reshape(X{1,i}(:,1),192,168)];
end
face3=[];
for i=13:18
    face3=[face3,reshape(X{1,i}(:,1),192,168)];
end
face4=[];
for i=19:24
    face4=[face4,reshape(X{1,i}(:,1),192,168)];
end
face5=[];
for i=25:30
    face5=[face5,reshape(X{1,i}(:,1),192,168)];
end
face6=[];
for i=31:36
    face6=[face6,reshape(X{1,i}(:,1),192,168)];
end
face_all=[face1;face2;face3;face4;face5;face6];
figure(1);imagesc(face_all), colormap gray;




%任务二
%得到前36个人的人脸数据矩阵
data=[];
for k=1:36
    data=[data,X{1,k}];
end

%得到平均脸maenface向量
meanface=mean(data,2);
%figure(2);imagesc(reshape(meanface,192,168)), colormap gray;

%去均值，再做SVD
data_sub=data-repmat(mean(data,2),1,2286);
[U,S,V]=svd(data_sub,'econ');

figure(3);
subplot(2,2,1);imagesc(reshape(U(:,1),192,168)), colormap gray;
subplot(2,2,2);imagesc(reshape(U(:,2),192,168)), colormap gray;
subplot(2,2,3);imagesc(reshape(U(:,3),192,168)), colormap gray;
subplot(2,2,4);imagesc(reshape(U(:,4),192,168)), colormap gray;




%任务三
%用第38个人的脸测试
X_38=X{1,38};
face_test1=X_38(:,1);
face_fit1=U(:,1:25)*U(:,1:25)'*face_test1;%rank=25
face_fit2=U(:,1:50)*U(:,1:50)'*face_test1;%rank=50
face_fit3=U(:,1:100)*U(:,1:100)'*face_test1;%rank=100
face_fit4=U(:,1:200)*U(:,1:200)'*face_test1;%rank=200
face_fit5=U(:,1:400)*U(:,1:400)'*face_test1;%rank=400
face_fit6=U(:,1:800)*U(:,1:800)'*face_test1;%rank=800
face_fit7=U(:,1:1600)*U(:,1:1600)'*face_test1;%rank=1600
figure(4);
subplot(2,4,1);imagesc(reshape(face_test1,192,168)), colormap gray;title('Test image');
subplot(2,4,2);imagesc(reshape(face_fit1,192,168)), colormap gray;title('rank=25');
subplot(2,4,3);imagesc(reshape(face_fit2,192,168)), colormap gray;title('rank=50');
subplot(2,4,4);imagesc(reshape(face_fit3,192,168)), colormap gray;title('rank=100');
subplot(2,4,5);imagesc(reshape(face_fit4,192,168)), colormap gray;title('rank=200');
subplot(2,4,6);imagesc(reshape(face_fit5,192,168)), colormap gray;title('rank=400');
subplot(2,4,7);imagesc(reshape(face_fit6,192,168)), colormap gray;title('rank=800');
subplot(2,4,8);imagesc(reshape(face_fit7,192,168)), colormap gray;title('rank=1600');

%自选图片测试
load('testimage.mat');
face2_test=im2double(testimage);
face2_fit1=U(:,1:25)*U(:,1:25)'*face2_test;%rank=25
face2_fit2=U(:,1:50)*U(:,1:50)'*face2_test;%rank=50
face2_fit3=U(:,1:100)*U(:,1:100)'*face2_test;%rank=100
face2_fit4=U(:,1:200)*U(:,1:200)'*face2_test;%rank=200
face2_fit5=U(:,1:400)*U(:,1:400)'*face2_test;%rank=400
face2_fit6=U(:,1:800)*U(:,1:800)'*face2_test;%rank=800
face2_fit7=U(:,1:1600)*U(:,1:1600)'*face2_test;%rank=1600
figure(5);
subplot(2,4,1);imagesc(reshape(face2_test,192,168)), colormap gray;title('Test image');
subplot(2,4,2);imagesc(reshape(face2_fit1,192,168)), colormap gray;title('rank=25');
subplot(2,4,3);imagesc(reshape(face2_fit2,192,168)), colormap gray;title('rank=50');
subplot(2,4,4);imagesc(reshape(face2_fit3,192,168)), colormap gray;title('rank=100');
subplot(2,4,5);imagesc(reshape(face2_fit4,192,168)), colormap gray;title('rank=200');
subplot(2,4,6);imagesc(reshape(face2_fit5,192,168)), colormap gray;title('rank=400');
subplot(2,4,7);imagesc(reshape(face2_fit6,192,168)), colormap gray;title('rank=800');
subplot(2,4,8);imagesc(reshape(face2_fit7,192,168)), colormap gray;title('rank=1600');


%任务四
%二维空间可视化
X_2=X{1,2};%第二个人所有脸的数据
X_3=X{1,3};%第三个人所有脸的数据
X_7=X{1,7};%第七个人所有脸的数据
pc5_2=[];pc6_2=[];%第二个人脸在pc5和pc6上的投影
pc5_7=[];pc6_7=[];%第七个人脸在pc5和pc6上的投影
pc5_3=[];pc6_3=[];%第三个人脸在pc5和pc6上的投影
for i=1:64
    pc5_2(i)=X_2(:,i)'*U(:,5)/norm(U(:,5));
    pc6_2(i)=X_2(:,i)'*U(:,6)/norm(U(:,6));
end
for j=1:64
    pc5_7(j)=X_7(:,j)'*U(:,5)/norm(U(:,5));
    pc6_7(j)=X_7(:,j)'*U(:,6)/norm(U(:,6));
end
for k=1:64
    pc5_3(k)=X_3(:,k)'*U(:,5)/norm(U(:,5));
    pc6_3(k)=X_3(:,k)'*U(:,6)/norm(U(:,6));
end
figure(6);
scatter(pc5_2,pc6_2,'r','^');
hold on;
scatter(pc5_7,pc6_7,'g','d');
hold on;
scatter(pc5_3,pc6_3,'b','*');

%三维空间可视化
kpc4_2=[];kpc5_2=[];kpc6_2=[];%第二个人脸在pc5和pc6上的投影
kpc4_7=[];kpc5_7=[];kpc6_7=[];%第七个人脸在pc5和pc6上的投影
kpc4_3=[];kpc5_3=[];kpc6_3=[];%第三个人脸在pc5和pc6上的投影
for i=1:64
    kpc5_2(i)=X_2(:,i)'*U(:,5)/norm(U(:,5));
    kpc6_2(i)=X_2(:,i)'*U(:,6)/norm(U(:,6));
    kpc4_2(i)=X_2(:,i)'*U(:,4)/norm(U(:,4));
end
for j=1:64
    kpc5_7(j)=X_7(:,j)'*U(:,5)/norm(U(:,5));
    kpc6_7(j)=X_7(:,j)'*U(:,6)/norm(U(:,6));
    kpc4_7(i)=X_7(:,i)'*U(:,4)/norm(U(:,4));
end
for k=1:64
    kpc5_3(k)=X_3(:,k)'*U(:,5)/norm(U(:,5));
    kpc6_3(k)=X_3(:,k)'*U(:,6)/norm(U(:,6));
    kpc4_3(i)=X_3(:,k)'*U(:,4)/norm(U(:,4));
end
figure(9);
scatter3(kpc4_2,kpc5_2,kpc6_2,'r','^');
hold on;
scatter3(kpc4_7,kpc5_7,kpc6_7,'g','d');
hold on;
scatter3(kpc4_3,kpc5_3,kpc6_3,'b','*');



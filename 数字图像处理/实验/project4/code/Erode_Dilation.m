function [imd,ime]= Erode_Dilation(ima,A)
    %ima为输入图像，A为输入的3*3结构元
    %imd为输出的膨胀图，ime为输出的腐蚀图
    [m,n]=size(ima);
    imd=ones(m,n);
    ime=zeros(m,n);
    p=zeros(3,3);
    q=zeros(3,3);
    %将输入图像四周添加一圈0元素
    imb=zeros(m+2,n+2);
    for i=2:m+1
        for j=2:n+1
            imb(i,j)=ima(i-1,j-1);
        end
    end
    for i=2:m+1
        for j=2:n+1
            %膨胀计算
            p=A&[imb(i-1,j-1),imb(i-1,j),imb(i-1,j+1);
                 imb(i,j-1),imb(i,j),imb(i,j+1);
                 imb(i+1,j-1),imb(i+1,j),imb(i+1,j+1)];
            if (p==zeros(3,3))
                imd(i-1,j-1)=0;
            end
            %腐蚀计算
            q=A&[imb(i+1,j+1),imb(i+1,j),imb(i+1,j-1);
                 imb(i,j+1),imb(i,j),imb(i,j-1);
                 imb(i-1,j+1),imb(i-1,j),imb(i-1,j-1)];
            if (q==A)
                ime(i-1,j-1)=1;
            end
        end
    end
end

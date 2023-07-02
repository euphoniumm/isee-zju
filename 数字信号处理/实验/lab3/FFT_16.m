function y=FFT_16(x)
    %分组
    x1=[x(1),x(5),x(9),x(13)];
    x2=[x(3),x(7),x(11),x(15)];
    x3=[x(2),x(6),x(10),x(14)];
    x4=[x(4),x(8),x(12),x(16)];
    
    %4点DFT
    y1=DFT_4(x1);
    y2_b=DFT_4(x2);
    y3=DFT_4(x3);
    y4_b=DFT_4(x4);
    
    %对y2_b，y4_b乘以旋转因子
    y2=[];
    for i=1:4
        y2(i)=y2_b(i)*exp(-1j*pi/4*(i-1));
    end
    y4=[];
    for i=1:4
        y4(i)=y4_b(i)*exp(-1j*pi/4*(i-1));
    end
    
    %第二级
    yy1=[];
    for i=1:4
        yy1(i)=y1(i)+y2(i);
    end
    for j=5:8
        yy1(j)=y1(j-4)-y2(j-4);
    end
    
    yy2_b=[];
    for i=1:4
        yy2_b(i)=y3(i)+y4(i);
    end
    for j=5:8
        yy2_b(j)=y3(j-4)-y4(j-4);
    end
    
    yy2=[];
    for i=1:8
        yy2(i)=yy2_b(i)*exp(-1j*pi/8*(i-1));
    end
    
    y=[];
    for i=1:8
        y(i)=yy1(i)+yy2(i);
    end
    for j=9:16
        y(j)=yy1(j-8)-yy2(j-8);
    end
end
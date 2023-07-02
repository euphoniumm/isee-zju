function funDTFT(n,x)
    k=-4000:4000;%控制作图范围
    w=(pi/1000)*k;%omiga，即横坐标
    X_w=x*(exp(-j*pi/1000)).^(n'*k);%DTFT，得到频域上的函数
    magX = abs(X_w);%幅度
    angX = angle(X_w);%相位
    realX = real(X_w);%实部
    imagX = imag(X_w);%虚部

    subplot(2,2,1);
    plot(w/pi,magX);
    title('Magnitude Part');
    xlabel('w/pi');ylabel('Magnitude');
    
    subplot(2,2,2);
    plot(w/pi,angX);
    title('Angle Part');
    xlabel('w/pi');ylabel('Radians');

    subplot(2,2,3);
    plot(w/pi,realX);
    title('Real part');
    xlabel('w/pi');ylabel('Real');

    subplot(2,2,4);
    plot(w/pi,imagX);
    title('Imaginary Part');
    xlabel('w/pi');ylabel('Imaginary');
end
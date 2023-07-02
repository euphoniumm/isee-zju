function funDFT(n,x)
    N=length(n);%求序列长度，确定参数N
    k=-2*N:1:N*2;%横坐标范围
    X_k=x*(exp(-j*2*pi/N)).^(n'*k);%DFT，得到频域上的函数
    magX = abs(X_k);%幅度
    angX = angle(X_k);%相位
    realX = real(X_k);%实部
    imagX = imag(X_k);%虚部
    
    subplot(2,2,1);
    stem(k,magX);
    title('Magnitude Part');
    xlabel('k');ylabel('Magnitude');
    
    subplot(2,2,2);
    stem(k,angX);
    title('Angle Part');
    xlabel('k');ylabel('Radians');

    subplot(2,2,3);
    stem(k,realX);
    title('Real part');
    xlabel('k');ylabel('Real');

    subplot(2,2,4);
    stem(k,imagX);
    title('Imaginary Part');
    xlabel('k');ylabel('Imaginary');
end
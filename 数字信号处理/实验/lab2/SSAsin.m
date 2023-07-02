function SSAsin(T,N0)
    f=50;
    N=0:N0;
    t=0:0.0005:0.1;
    x0=sin(2*pi*f*t);%原信号
    x1=sin(2*pi*f*T*N);%抽样序列
    
    %时域图
    figure
    subplot(4,2,[1,2]);plot(t,x0);title('原信号');
    subplot(4,2,[3,4]);stem(N,x1);title('抽样序列');
    
    %时域图2
    subplot(4,2,5);%实部
    stem(N,real(x1));
    title('实部');
 
    subplot(4,2,6);%虚部
    stem(N,imag(x1));
	title('虚部');

    subplot(4,2,7);%模
    stem(N,abs(x1));
    title('幅度');
 
    subplot(4,2,8);%相角
    stem(N,angle(x1));
    title('相角');

    %频谱
    x2=fft(x1,N0+1);
    magX=abs(x2);%幅度
    realX=real(x2);%实部
    imagX=imag(x2);%虚部
    figure
    subplot(3,1,1);stem(N,magX);title('幅度');
    subplot(3,1,2);stem(N,realX);title('实部');
    subplot(3,1,3);stem(N,imagX);title('虚部');
    
    %DTFT与DFT对比
    w=0:pi/1000:2*pi;
    Xw=x1*(exp(-1*j)).^(N'*w);%利用公式，求DTFT
    figure
    subplot(2,1,1);plot(w,abs(Xw));title('DTFT');
    subplot(2,1,2);stem(N,magX);title('DFT');
end
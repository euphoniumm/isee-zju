clear;clc;close all;
%% 参数设置
Ts = 0.1;                               %符号周期
df = 1/Ts;                              %子载波频率间隔
f0 = 10000;                             %第一个子载波中心频率
Nc = 128;                               %子载波个数
Nfft = 256;                             %IFFT点数

%% 符号产生
bit_transfer = round(rand(1,Nfft));     %产生每个子载波对应的符号
bit_transfer = bit_transfer*2-1;        %将0和1映射为-1和1
for i=2:2:256                           %把偶数位置的bit都设为0
    bit_transfer(i) = 0;
end

%一个子载波传输信号，取第一个子载波
bit_transfer1 = bit_transfer;
bit_transfer1(1)=1;
for i=2:256
    bit_transfer1(i) = 0;
end

%四个子载波传输信号，取前四个子载波
bit_transfer2 = bit_transfer;
bit_transfer2(1)=1;
bit_transfer2(2)=0;
bit_transfer2(3)=1;
bit_transfer2(4)=0;
bit_transfer2(5)=1;
bit_transfer2(6)=0;
bit_transfer2(7)=1;
bit_transfer2(8)=0;
for i=5:256
    bit_transfer2(i) = 0;
end

%128个子载波传输信号
bit_transfer3 = bit_transfer;

%% 信号产生
t = 0:Ts/256:(Ts-Ts/256);               %将时间设为0-Ts，即一个符号周期
carry = exp(1j*2*pi*f0*t);              %得到中心频率为f0的子载波
signal1_band = ifft(bit_transfer1);     %ifft得到情况1的基带波形
signal2_band = ifft(bit_transfer2);     %ifft得到情况2的基带波形
signal3_band = ifft(bit_transfer3);     %ifft得到情况3的基带波形
signal1 = real(signal1_band.*carry);    %乘以载波上变频得到odfm波形
signal2 = real(signal2_band.*carry);    %乘以载波上变频得到odfm波形
signal3 = real(signal3_band.*carry);    %乘以载波上变频得到odfm波形

%% 时域波形
figure(1);
subplot(311);plot(t,signal1);xlabel('时间(s)');ylabel('幅度');
title('OFDM信号时域波形');
subplot(312);plot(t,signal2);xlabel('时间(s)');ylabel('幅度');
subplot(313);plot(t,signal3);xlabel('时间(s)');ylabel('幅度');

%% 频谱图
%目标是做8912点fft求频谱，所以需要先对原始信号做内插，得到8192点的信号
t1 = 0:Ts/8192:(Ts-Ts/8912);            %时间坐标            
carry1 = exp(1j*2*pi*f0*t1);            %载波
signal_interp1 = real(interp(signal1_band,32).*carry1);   %内插后上变频
signal_interp2 = real(interp(signal2_band,32).*carry1);   %内插后上变频
signal_interp3 = real(interp(signal3_band,32).*carry1);   %内插后上变频
figure(2);
subplot(311);plot(t1,signal_interp1);xlabel('时间(s)');ylabel('幅度');
title('增加采样点数后的OFDM信号时域波形');
subplot(312);plot(t1,signal_interp2);xlabel('时间(s)');ylabel('幅度');
subplot(313);plot(t1,signal_interp3);xlabel('时间(s)');ylabel('幅度');

%求频谱
Fs = 8192/Ts;                             %采样率
y1 = fftshift(fft(signal_interp1));       %fft求频谱
y2 = fftshift(fft(signal_interp2));       %fft求频谱
y3 = fftshift(fft(signal_interp3));       %fft求频谱
f=(-8192/2:8192/2-1)*(Fs/8192);           %频率范围
figure(3);
subplot(311);plot(f,abs(y1));xlabel('频率(Hz)');ylabel('幅度');
title('OFDM信号频谱图');
subplot(312);plot(f,abs(y2));xlabel('频率(Hz)');ylabel('幅度');
subplot(313);plot(f,abs(y3));xlabel('频率(Hz)');ylabel('幅度');

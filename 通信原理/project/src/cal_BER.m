function BER = cal_BER(snr,qpsk,zb1,zb2,Rb,Fs,soure,L,M)
tz=awgn(qpsk,snr);            % 信号qpsk中加入白噪声，信噪比为SNR=20dB

tz1=tz.*zb1;                % 相干解调，乘以相干载波
tz2=tz.*zb2;                % 相干解调，乘以相干载波

% 低通滤波器设计
fp=2*Rb;                      % 低通滤波器截止频率，乘以2是因为下面要将模拟频率转换成数字频率wp=Rb/(Fs/2)
b=fir1(30, fp/Fs, boxcar(31));% 生成fir滤波器系统函数中分子多项式的系数
% fir1函数三个参数分别是阶数，数字截止频率，滤波器类型
% 这里是生成了30阶(31个抽头系数)的矩形窗滤波器
[h,w]=freqz(b, 1,512);        % 生成fir滤波器的频率响应
% freqz函数的三个参数分别是滤波器系统函数的分子多项式的系数，分母多项式的系数(fir滤波器分母系数为1)和采样点数(默认)512
lvbo1=fftfilt(b,tz1);         % 对信号进行滤波，tz1是等待滤波的信号，b是fir滤波器的系统函数的分子多项式系数
lvbo2=fftfilt(b,tz2);         % 对信号进行滤波，tz2是等待滤波的信号，b是fir滤波器的系统函数的分子多项式系数
% figure(1);                  % 绘制第4幅图  
% plot(w/pi*Fs/2,20*log(abs(h)),'LineWidth',2); % 绘制滤波器的幅频响应
% title('低通滤波器的频谱');  % 标题
% xlabel('频率/Hz');          % x轴标签
% ylabel('幅度/dB');          % y轴标签
k=0;                        % 设置抽样限值
pdst1=1*(lvbo1<0);          % 滤波后的向量的每个元素和0进行比较，大于0为1，否则为0
pdst2=1*(lvbo2<0);          % 滤波后的向量的每个元素和0进行比较，大于0为1，否则为0
% pdstt1=2*(lvbo1<0)-1;
% pdstt2=2*(lvbo2<0)-1;

I_zong = [];
Q_zong = [];
% I_zong1 = [];
% Q_zong1 = [];
% 取码元的中间位置上的值进行判决
for j=L/2:L:(L*M/2)
    if pdst1(j)>0
        I_zong=[I_zong,1];
    else
        I_zong=[I_zong,0];
    end
end
% 取码元的中间位置上的值进行判决
for k=L/2:L:(L*M/2)
    if pdst2(k)>0
        Q_zong=[Q_zong,1];
    else
        Q_zong=[Q_zong,0];
    end
end

% for j=L/2:L:(L*M/2)
%     I_zong1=[I_zong1,lvbo1(j)];
% end
% % 取码元的中间位置上的值进行判决
% for k=L/2:L:(L*M/2)
%     Q_zong1=[Q_zong1,lvbo2(k)];
% end

code = [];
% 将I路码元为最终输出的奇数位置码元，将Q路码元为最终输出的偶数位置码元
for n=1:M
    if mod(n, 2)~=0
        code = [code, I_zong((n+1)/2)];
    else
        code = [code, Q_zong(n/2)];
    end
end
BER=sum(abs(soure-code))/length(soure);
end
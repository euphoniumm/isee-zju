clear all;
close all;
n0=1:16;
n1=1:10;
x0=[3,2,0,0,1,0,5,4,2,6,0,0,0,0,0,0];
x1=[3,2,0,0,1,0,5,4,2,6];
y0=FFT_16(x0);%基4fft
y1=fft(x1);%不填零的DFT
y2=fft(x0);%DFT
%figure(1);
%stem(n,x);title('原序列');
figure(2);
subplot(3,2,1);stem(n0,real(y0));title('fig.1 FFT变换实部序列');
subplot(3,2,2);stem(n0,imag(y0));title('fig.2 FFT变换虚部序列');

subplot(3,2,3);stem(n1,real(y1));title('fig.3 10点DFT变换实部序列');
subplot(3,2,4);stem(n1,imag(y1));title('fig.4 10点DFT变换虚部序列');

subplot(3,2,5);stem(n0,real(y2));title('fig.5 16点DFT变换实部序列');
subplot(3,2,6);stem(n0,imag(y2));title('fig.6 16点DFT变换虚部序列');
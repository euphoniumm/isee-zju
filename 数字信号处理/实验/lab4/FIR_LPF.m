clear;
close all;

%%2-1 设计两个FIR滤波器h1(n) h2(n)
%参数定义
n1=0:14;
n2=15;
n3=16:30;
n=[n1,n2,n3];
w=0:0.005:pi;
wc=0.5*pi;
N=31;
tao=(N-1)/2;
%求解h(n)，因为n=15时分母为0，所以分段考虑
h1_1=sin((n1-tao)*wc)./((n1-tao)*pi);
h1_2=0.5;
h1_3=sin((n3-tao)*wc)./((n3-tao)*pi);
% 矩形窗
h1=[h1_1,h1_2,h1_3];
H1=h1*(exp(-1j).^(n'*w));

% 汉明窗
w_n=hamming(N);
h2=h1.*w_n';
H2=h2*(exp(-1j).^(n'*w));
%{
%作图
figure(1);
subplot(2,1,1);stem(n,h1);xlabel('n');ylabel('h1(n)');
subplot(2,1,2);stem(n,h2);xlabel('n');ylabel('h2(n)');
figure(2);
subplot(2,2,1);plot(w/pi,abs(H1));xlabel('w/pi');ylabel('|H1(e^jw)|');axis([0 1 -0.1 1.1]);
subplot(2,2,2);plot(w/pi,abs(H2));xlabel('w/pi');ylabel('|H2(e^jw)|');axis([0 1 -0.1 1.1]);
subplot(2,2,3);plot(w/pi,20*log10(abs(H1)));xlabel('w/pi');ylabel('20lg|H1(e^jw)|');
subplot(2,2,4);plot(w/pi,20*log10(abs(H2)));xlabel('w/pi');ylabel('20lg|H2(e^jw)|');
%}
%{
h1_new=fir1(N-1,wc/pi,boxcar(N));
[H1_new, w1]=freqz(h1_new);
%}

n_1=0:199;
xn=rand(1,200)-0.5;
Xk=xn*(exp(-1j).^(n_1'*w));
%%2-3 滤波
%得到滤波序列
y1=filter(h1,1,xn);
y2=filter(h2,1,xn);

%得到滤波序列的幅频响应
[Y1,w_y1]=freqz(y1);
[Y2,w_y2]=freqz(y2);

%%2-4 N=127的低通滤波器设计
%参数定义
n1_3=0:62;
n2_3=63;
n3_3=64:126;
n_3=[n1_3,n2_3,n3_3];
N_3=127;
tao=(N_3-1)/2;
h3_1=sin((n1_3-tao)*wc)./((n1_3-tao)*pi);
h3_2=0.5;
h3_3=sin((n3_3-tao)*wc)./((n3_3-tao)*pi);
% 矩形窗
h3=[h3_1,h3_2,h3_3];
[H3, w1]=freqz(h3);
figure(1);
subplot(3,1,1);plot(w/pi,20*log10(abs(H1)));xlabel('w/pi');ylabel('20lg|H1(e^jw)|');
subplot(3,1,2);plot(w/pi,20*log10(abs(H2)));xlabel('w/pi');ylabel('20lg|H2(e^jw)|');
subplot(3,1,3);plot(w1/pi,20*log10(abs(H3)));xlabel('w/pi');ylabel('20lg|H3(e^jw)|');
%得到滤波序列
y3=filter(h3,1,xn);
%得到滤波序列的幅频响应
[Y3,w_y3]=freqz(y3);
%{
figure(3);
subplot(2,1,1);stem(n_1,xn);xlabel('n');ylabel('x(n)');
subplot(2,1,2);plot(w/pi,abs(Xk));xlabel('w/pi');ylabel('|X(e^jw)|');
figure(4);
subplot(3,1,1);plot(w_y1/pi,abs(Y1));xlabel('w/pi');ylabel('|Y1(k)|');
subplot(3,1,2);plot(w_y2/pi,abs(Y2));xlabel('w/pi');ylabel('|Y2(k)|');
subplot(3,1,3);plot(w_y3/pi,abs(Y3));xlabel('w/pi');ylabel('|Y3(k)|');
figure(5);
subplot(3,1,1);plot(w_y1/pi,20*log10(abs(Y1)));xlabel('w/pi');ylabel('20lg|Y1(k)|');
subplot(3,1,2);plot(w_y2/pi,20*log10(abs(Y2)));xlabel('w/pi');ylabel('20lg|Y2(k)|');
subplot(3,1,3);plot(w_y3/pi,20*log10(abs(Y3)));xlabel('w/pi');ylabel('20lg|Y3(k)|');
%}
%{
%作图
figure(3);
subplot(3,1,1);plot(w/pi,abs(Xk));xlabel('w/pi');ylabel('|X(k)|');
title('幅度响应对比图','FontWeight','bold');
subplot(3,1,2);plot(w_y1/pi,abs(Y1));xlabel('w/pi');ylabel('|Y1(k)|');
subplot(3,1,3);plot(w_y2/pi,abs(Y2));xlabel('w/pi');ylabel('|Y2(k)|');
figure(4);
subplot(3,1,1);plot(w/pi,20*log10(abs(Xk)));xlabel('w/pi');ylabel('20lg|X(k)|');
title('幅度响应(dB)对比图','FontWeight','bold');
subplot(3,1,2);plot(w_y1/pi,20*log10(abs(Y1)));xlabel('w/pi');ylabel('20lg|Y1(k)|');
subplot(3,1,3);plot(w_y2/pi,20*log10(abs(Y2)));xlabel('w/pi');ylabel('20lg|Y2(k)|');
%}
%{
%%2-4 N=127的低通滤波器设计
%参数定义
n1_3=0:62;
n2_3=63;
n3_3=64:126;
n_3=[n1_3,n2_3,n3_3];
N_3=127;
tao=(N_3-1)/2;
h3_1=sin((n1_3-tao)*wc)./((n1_3-tao)*pi);
h3_2=0.5;
h3_3=sin((n3_3-tao)*wc)./((n3_3-tao)*pi);
% 矩形窗
h3=[h3_1,h3_2,h3_3];

%得到滤波序列
y3=filter(h3,1,xn);
%得到滤波序列的幅频响应
[Y3,w_y3]=freqz(y3);
%作图
figure(5);
subplot(2,1,1);plot(w_y1/pi,abs(Y1));xlabel('w/pi');ylabel('|Y1(k)|');
title('幅度响应对比图','FontWeight','bold');
subplot(2,1,2);plot(w_y3/pi,abs(Y3));xlabel('w/pi');ylabel('|Y3(k)|');
figure(6);
subplot(2,1,1);plot(w_y1/pi,20*log10(abs(Y1)));xlabel('w/pi');ylabel('20lg|Y1(k)|');
title('幅度响应(dB)对比图','FontWeight','bold');
subplot(2,1,2);plot(w_y3/pi,20*log10(abs(Y3)));xlabel('w/pi');ylabel('20lg|Y3(k)|');
%}
%{
n_2=0:229;
Y1k=y1*(exp(-1j).^(n_2'*w));
Y2k=y2*(exp(-1j).^(n_2'*w));

n1_3=0:62;
n2_3=63;
n3_3=64:126;
n_3=[n1_3,n2_3,n3_3];
N_3=127;
tao=(N_3-1)/2;
h3_1=sin((n1_3-tao)*wc)./((n1_3-tao)*pi);
h3_2=0.5;
h3_3=sin((n3_3-tao)*wc)./((n3_3-tao)*pi);
% 矩形窗
h3=[h3_1,h3_2,h3_3];
y3=conv(xn,h3);
nn=0:325;
Y3k=y3*(exp(-1j).^(nn'*w));

figure(3);
subplot(4,1,1);plot(w/pi,abs(Xk));xlabel('w/pi');ylabel('|X(k)|');
subplot(4,1,2);plot(w/pi,abs(Y1k));xlabel('w/pi');ylabel('|Y1(k)|');
subplot(4,1,3);plot(w/pi,abs(Y2k));xlabel('w/pi');ylabel('|Y2(k)|');
subplot(4,1,4);plot(w/pi,abs(Y3k));xlabel('w/pi');ylabel('|Y3(k)|');
%}

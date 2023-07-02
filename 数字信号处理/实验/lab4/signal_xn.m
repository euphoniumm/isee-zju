clear;
close all;

%%2-1 设计两个FIR滤波器h1(n) h2(n)
N1=31;
N2=127;
n1=0:30;
n2=0:126;
wc=0.5*pi;
h1=fir1(N1-1,wc/pi,boxcar(N1));
[H1,w1]=freqz(h1);

% 汉明窗
h2=fir1(N1-1,wc/pi,hamming(N1));
[H2,w2]=freqz(h2);

h3=fir1(N2-1,wc/pi,boxcar(N2));
[H3,w3]=freqz(h3);

n_2=0:199;
xn=rand(1,200)-0.5;
[Xk,wxk]=freqz(xn);

y1=filter(h1,1,xn);
y2=filter(h2,1,xn);
y3=filter(h3,1,xn);

%得到滤波序列的幅频响应
[Y1,w_y1]=freqz(y1);
[Y2,w_y2]=freqz(y2);
[Y3,w_y3]=freqz(y3);
%{
figure(1);
subplot(3,1,1);stem(n1,h1);xlabel('n');ylabel('h1(n)');
subplot(3,1,2);stem(n1,h2);xlabel('n');ylabel('h2(n)');
subplot(3,1,3);stem(n2,h3);xlabel('n');ylabel('h3(n)');
%}

figure(1);
subplot(5,1,1);stem(n_2,xn);xlabel('n');ylabel('x(n)');
subplot(5,1,2);plot(w1/pi,abs(Xk));xlabel('w/pi');ylabel('|X(e^jw)|');
subplot(5,1,3);plot(w1/pi,abs(Y1));xlabel('w/pi');ylabel('|Y1(e^jw)|');
subplot(5,1,4);plot(w2/pi,abs(Y2));xlabel('w/pi');ylabel('|Y2(e^jw)|');
subplot(5,1,5);plot(w3/pi,abs(Y3));xlabel('w/pi');ylabel('|Y3(e^jw)|');

figure(2);
subplot(3,1,1);plot(w1/pi,20*log10(abs(Y1)));xlabel('w/pi');ylabel('20lg|Y1(e^jw)|');
subplot(3,1,2);plot(w2/pi,20*log10(abs(Y2)));xlabel('w/pi');ylabel('20lg|Y2(e^jw)|');
subplot(3,1,3);plot(w3/pi,20*log10(abs(Y3)));xlabel('w/pi');ylabel('20lg|Y3(e^jw)|');
%{
figure(2);
subplot(3,1,1);plot(w1/pi,20*log10(abs(H1)));xlabel('w/pi');ylabel('20lg|H1(e^jw)|');
subplot(3,1,2);plot(w2/pi,20*log10(abs(H2)));xlabel('w/pi');ylabel('20lg|H2(e^jw)|');
subplot(3,1,3);plot(w3/pi,20*log10(abs(H3)));xlabel('w/pi');ylabel('20lg|H3(e^jw)|');
%}


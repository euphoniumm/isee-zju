clc;
clear;
%real sequence
length_n=[10;10;20];%序列长度
a=[0.5;0.9;0.9];
n1=0:1:length_n(1)-1;
n2=0:1:length_n(2)-1;
n3=0:1:length_n(3)-1;
x1=a(1).^n1;
x2=a(2).^n2;
x3=a(3).^n3;

%Complex sequence
re=0.5;
im=0.8;
x4=(re+im*i).^n1;

%sin/cos sequence
f1=1;f2=3;%频率
delta=0;%正弦信号和余弦信号的初始相位
T=0.1;%抽样间隔
phi=[0;pi/2;pi];%符合函数序列的初始相位
x5=sin(2*pi*f1*n1*T+delta);
x6=cos(2*pi*f1*n1*T+delta);
x7=sin(2*pi*f1*n1*T)+0.5*sin(2*pi*f2*n1*T+phi(1));
x8=sin(2*pi*f1*n1*T)+0.5*sin(2*pi*f2*n1*T+phi(2));
x9=sin(2*pi*f1*n1*T)+0.5*sin(2*pi*f2*n1*T+phi(3));

figure(1);fundraw(n1,x5);sgtitle('x5');
figure(2);funDTFT(n1,x5);sgtitle('DTFT');
figure(3);funDFT(n1,x5);sgtitle('DFT');


%{
figure(2);fundraw(n2,x2);sgtitle('x2');
figure(3);fundraw(n3,x3);sgtitle('x3');
figure(4);fundraw(n1,x4);sgtitle('x4');
figure(5);fundraw(n1,x5);sgtitle('x5');
figure(6);fundraw(n1,x6);sgtitle('x6');
figure(7);fundraw(n1,x7);sgtitle('x7');
figure(8);fundraw(n1,x8);sgtitle('x8');
figure(9);fundraw(n1,x9);sgtitle('x9');
%}
%{
figure(1);funDTFT(x5,n1);
figure(2);funDFT(x5,n1);
%}



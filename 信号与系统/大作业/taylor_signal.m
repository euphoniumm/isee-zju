clear
tmin=-10;tmax=10;
dt=0.05;%采样周期
t=tmin:dt:tmax;
x=0.3*sinc(2*pi*t)+0.4*cos(2.5*pi*t+pi/4)+0.3*cos(pi*t+pi/3);%原信号
T=2.35675412668*dt;%延时
x1=0.3*sinc(2*pi*(t-T))+0.4*cos(2.5*pi*(t-T)+pi/4)+0.3*cos(pi*(t-T)+pi/3);%延时信号

%作图
figure(1);
subplot(2,2,1);plot(t,x);ylabel('原信号');
subplot(2,2,2);plot(t,x1);ylabel('延时信号');
subplot(2,2,3);stem(t,x);ylabel('样值');
subplot(2,2,4);stem(t,x1);ylabel('样值');

%求x与x1的互相关
[c,lags]=xcorr(x,x1,'normalized');
figure(2);
stem(lags,c);

%求第一次互相关得到的估计延时T1
cm=max(c);
id=find(c==cm);
lagsm=lags(id);
T1=lagsm*dt;
x2=0.3*sinc(2*pi*(t-T-T1))+0.4*cos(2.5*pi*(t-T-T1)+pi/4)+0.3*cos(pi*(t-T-T1)+pi/3);%将原信号平移T1得到x2

%利用级数展开解-(T+T1)
f=0.3*sinc(2*pi*(0-T-T1))+0.4*cos(2.5*pi*(0-T-T1)+pi/4)+0.3*cos(pi*(0-T-T1)+pi/3);%f为x2在0处的函数值
syms a
x3=0.3*sinc(2*pi*a)+0.4*cos(2.5*pi*a+pi/4)+0.3*cos(pi*a+pi/3);%将原信号表示为符号函数形式，方便求级数等数学操作
xx=[];
len=1:6;
for p=2:6
    y=taylor(x3,a,0,'Order',p);%y为x3在0处的泰勒展开，展开到第p项
    eqn= y-f==0;%列方程
    format long
    m=solve(eqn,a);
    h=vpa(m);%解出-(T+T1)
    T2=-(T1+h);%得到最终延时
    qeT2=T2(1,1)/dt;
    xx(p)=qeT2;
end
figure(3)
stem(len,xx);
axis([1 7 2.32 2.38]);
title('Ts=2.35675412668*dt');
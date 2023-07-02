clear all;
close all;
T=[0.000625,0.005,0.0046875,0.004,0.0025];%抽样间隔
NN0=31;%采样数
NN1=15;%采样数
SSAsin(T(1),NN0);
%{
SSAsin(T(2),NN0);
SSAsin(T(3),NN0);
SSAsin(T(4),NN0);
SSAsin(T(5),NN1);
%}
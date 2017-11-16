% refer to the 《数学建模算法与应用 · 第2版》 chapter 3
% modified by 石鹏
% 参考自P23第三章的例3.2
function NP()  %将代码保存为function格式可实现直接将文件拖拽进命令窗口就执行
clear
clc
X0=rand(3,1);
A=[];  %线性不等式约束系数矩阵
b=[];  %线性不等式约束的不等号右侧取值向量
Aeq=[];  %线性等式约束系数矩阵
Beq=[];  %线性等式约束的等号右侧取值向量
LB=zeros(3,1);  %决策变量下界向量
UB=[];
[x,fval]=fmincon(@Tar,X0,A,b,Aeq,Beq,LB,UB,@NONLCON);  %求解
x
fval

function f=Tar(x)
f=x(1)^2+x(2)^2+x(3)^2+8;  %目标函数

function [g,h]=NONLCON(x)
g=[-x(1)^2+x(2)-x(3)^2
    x(1)+x(2)^2+x(3)^3-20];  %非线性不等式约束
h=[-x(1)-x(2)^2+2
    x(2)+2*x(3)^2-3];  %非线性等式约束

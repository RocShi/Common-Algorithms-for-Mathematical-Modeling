% refer to the 《数学建模算法与应用 · 第2版》 chapter 3
% modified by 石鹏
% 求解的是《MATLAB在数学建模中的应用 · 第2版》 chapter 11中的蒙特卡罗模拟实例
% 从运算结果来看，要优于蒙特卡罗法
function NP()  %将代码保存为function格式可实现直接将文件拖拽进命令窗口就执行
clear
clc
X0=rand(3,1);
A=[1 -2 -2;1 2 2];  %不等式约束系数矩阵
b=[0 72];  %不等式约束的不等号右侧取值向量
Aeq=[1 -1 0];  %等式约束系数矩阵
Beq=[10];  %等式约束的等号右侧取值向量
LB=[-inf;10;-inf];  %决策变量下界向量
UB=[inf;20;inf];
[x,fval]=fmincon(@Tar,X0,A,b,Aeq,Beq,LB,UB,[]);  %求解
x
-fval

function f=Tar(x)
f=-x(1)*x(2)*x(3);  %目标函数

% function [g,h]=NONLCON(x)
% g=[ x(1)-2*x(2)-2*x(3)
%     x(1)+2*x(2)+2*x(3)-72
%     -x(2)+10
%     x(2)-20];  %非线性不等式约束
% h=[ ];  %非线性等式约束
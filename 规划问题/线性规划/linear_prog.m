% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 2
% modified by 石鹏
% 参考自P24第二章的例2-4
function linear_prog  %将代码保存为function格式可实现直接将文件拖拽进命令窗口就执行
clear
clc
c=[-2 -3 5];  %目标函数系数向量
A=[-2 5 -1];  %不等式约束系数矩阵
b=[-10];  %不等式约束的不等号右侧取值向量
Aeq=[1 1 1];  %等式约束系数矩阵
Beq=[7];  %等式约束的等号右侧取值向量
LB=zeros(3,1);  %决策变量下界向量
[x,fval]=linprog(c,A,b,Aeq,Beq,LB);  %求解
x
maxz=-fval  %由于原题目中为求最大值，故需对linprog的目标函数值取相反数

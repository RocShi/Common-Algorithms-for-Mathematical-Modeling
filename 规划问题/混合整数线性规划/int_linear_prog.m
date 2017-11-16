% refer to the 《数学建模算法与应用 · 第2版》 chapter 2
% modified by 石鹏
% 参考自P18第三章的例2.8
function int_linear_prog()  %将代码保存为function格式可实现直接将文件拖拽进命令窗口就执行
clear
clc
f=[-3 -2 -1];  %目标函数系数矩阵
intcon=3;  %整数变量位置
A=[1 1 1];  %不等式约束系数矩阵
b=[7];  %不等式约束的不等号右侧取值向量
Aeq=[4 2 1];  %等式约束系数矩阵
Beq=[12];  %等式约束的等号右侧取值向量
LB=zeros(3,1);  %决策变量下界向量
UB=[inf;inf;1];  %决策变量上界向量
[x,fval]=intlinprog(f,intcon,A,b,Aeq,Beq,LB,UB);  %求解，MATLAB 2012a版本无法运行
x
fval

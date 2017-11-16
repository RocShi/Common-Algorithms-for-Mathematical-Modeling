% refer to the 《数学建模算法与应用 · 第2版》 chapter 2
% modified by 石鹏
% 参考自P15第三章的例2.8，对于最优值-12，最优解并不唯一，x=[0 5.5 1]，[0 6 0]均为最优解
function ZO_MonteCarlo  %基于蒙特卡罗算法求解0-1整数规划
clear,clc
rand('state',sum(clock));  %初始化随机数生成器
p0=-10;  %初始解 
x0=[2 2 0];
tic  %计时开始
for  i=1:10^6  %大概需要24s
    x(3)=randi([0,1],1,1);  %随机生成1行5列在区间[0,99]上的随机整数
    x(1)=3*rand;
    x(2)=(12-4*x(1)-x(3))/2;
    [f,g]=TarCon(x);
    if (g(1)<=0)&&(x(2)>=0)  %满足所有不等式约束条件的另一种写法是 if sum(g<=0)=4
        if p0>f
            x0=x;
            p0=f;  %记录当前更优解
        end
    end
end
x0,p0  %输出最优解
toc  %计时结束

function [f,g]=TarCon(x)  %定义目标函数与约束条件
f=-3*x(1)-2*x(2)-x(3);  %目标函数
g=[x(1)+x(2)+x(3)-7  %约束条件向量
    4*x(1)+2*x(2)+x(3)];

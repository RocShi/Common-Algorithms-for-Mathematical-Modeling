% refer to the 《数学建模算法与应用 · 第2版》 chapter 2
% modified by 石鹏
% 参考自P15第三章的例2.6
function MonteCarlo
clear,clc
rand('state',sum(clock));  %初始化随机数生成器
p0=0;  %初始解
tic  %计时开始
for  i=1:10^7  %循环10^6次大概需要30s
    x=randi([0,99],1,5);  %随机生成1行5列在区间[0,99]上的随机整数
    [f,g]=TarCon(x);
    if all(g<=0)  %满足所有不等式约束条件的另一种写法是 if sum(g<=0)=4
        if p0<f
            x0=x;
            p0=f;  %记录当前更优解
        end
    end
end
x0,p0  %输出最优解
toc  %计时结束

function [f,g]=TarCon(x)  %定义目标函数与约束条件
f=x(1)^2+x(2)^2+3*x(3)^2+4*x(4)^2+2*x(5)^2-8*x(1)-2*x(2)-3*x(3)-x(4)-2*x(5);  %目标函数
g=[x(1)+x(2)+x(3)+x(4)+x(5)-400  %约束条件向量
    x(1)+2*x(2)+2*x(3)+x(4)+6*x(5)-800
    2*x(1)+x(2)+6*x(3)-200
    x(3)+x(4)+5*x(5)-200];

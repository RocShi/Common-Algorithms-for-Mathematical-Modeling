% 子程序：计算适应度函数, 函数名称存储为fitnessfun
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% modified by 石鹏

function [Fitvalue,cumsump]=fitnessfun(population);
global BitLength  %种群个体二进制编码长度
global boundsbegin  %规划边界起点值
global boundsend  %规划边界终点值
popsize=size(population,1);   %有popsize个个体，size(a,1)：求矩阵a的行数
for i=1:popsize
   x=transform2to10(population(i,:));  %将二进制转换为十进制
    %转化为[-2,2]区间的实数
xx=boundsbegin+x*(boundsend-boundsbegin)/(power(2,BitLength)-1);  %此处将原程序中power函数的第一参数（boundsend）改为2 
   Fitvalue(i)=targetfun(xx);  %计算种群中第i个个体的目标函数值，即适应度
end
%给适应度函数加上一个大小合理的数以便保证种群适应度为正数
Fitvalue=Fitvalue'+230;
%计算种群个体的被选择复制概率
fsum=sum(Fitvalue);  %种群适应度总和
Pperpopulation=Fitvalue/fsum;
%计算种群个体的被选择复制累积概率
cumsump(1)=Pperpopulation(1);
for i=2:popsize
   cumsump(i)=cumsump(i-1)+Pperpopulation(i);
end
cumsump=cumsump';
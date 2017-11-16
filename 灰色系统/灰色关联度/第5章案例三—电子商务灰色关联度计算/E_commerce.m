%第5章案例三——电子商务搜索流量占比、商品价格、页面平均停留时间与转化率的灰色关联度计算
%与采用遗传算法工具箱得到的结果相比，关联度相对大小有所差异

clc, clear all, close all
A=[0.317 0.461 0.649 1.000 0.256 0.156 0.576 0.077 0.000 0.271];
B=[0.600 0.100 0.000 0.000 0.100 1.000 0.099 0.999 0.800 0.400];
C=[0.489 1.000 0.000 0.529 0.460 0.632 0.305 0.529 0.138 0.408];
D=[0.060 0.141 0.467 1.000 0.085 0.060 0.430 0.029 0.000 0.140];
data=[A;B;C;D];
consult=D;
compare=[A;B;C];
m1=size(consult,1);  %参考数列行数
m2=size(compare,1);   %比较数列行数
for i=1:m1
for j=1:m2
t(j,:)=compare(j,:)-consult(i,:);
end
min_min=min(min(abs(t')));  %min、max函数的输入参数为矩阵时，输出为该矩阵每一列的最值
max_max=max(max(abs(t')));
% 通常分辨率都是取0.5
resolution=0.5;
% 计算关联系数
coefficient=(min_min+resolution*max_max)./(abs(t)+resolution*max_max);  %子因素的五行数据与母因素的第i行数据的关联系数矩阵
% 计算关联度
corr_degree=sum(coefficient')/size(coefficient,2);  %sum函数的输入参数为矩阵时，输出为该矩阵每一列的和
r(i,:)=corr_degree;
end
r

% 子程序：新种群选择操作, 函数名称存储为selection.m
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% modified by 石鹏

function seln=selection(cumsump);  %删除了原程序中selection的第一参数population
%依照“轮盘选择法”从种群中选择两个个体
for i=1:2
   r=rand;  %产生一个随机数
   prand=cumsump-r;
   j=1;
   while prand(j)<0
       j=j+1;
   end
   seln(i)=j; %选中个体的序号
end

% 子程序：判断遗传运算是否需要进行交配或变异, 函数名称存储为IfCroIfMut.m
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% modified by 石鹏

function pcc=IfCroIfMut(pcORpm);  %输入参数pcORpm为交配概率或变异概率
test(1:100)=0;
l=round(100*pcORpm);
test(1:l)=1;
n=round(rand*99)+1;  %rand等价于rand(1)
pcc=test(n);  
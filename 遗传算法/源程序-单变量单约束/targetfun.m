% 子程序：对于优化最大值或极大值函数问题，目标函数可以作为适应度函数
% 函数名称存储为targetfun.m
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% modified by 石鹏

function y=targetfun(x); %目标函数
y=200*exp(-0.05*x).*sin(x);
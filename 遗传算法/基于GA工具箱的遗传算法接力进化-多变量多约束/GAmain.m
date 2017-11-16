%主程序：本程序采用遗传算法接力进化，
%将上次进化结束后得到的最终种群作为下次输入的初始种群
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% modified by 石鹏

clc;
close all;
clear all;
T=500;  %进化代数
optionsOrigin=gaoptimset('Generations',T/2,'Populationsize',35,'StallGenLimit',250);  %初次进化属性，gaoptimset函数属性可参考《MATLAB在数学建模中的应用·第2版》P91
[x,fval,reason,output,finnal_pop]=ga(@ConstAndFit,2,optionsOrigin);
options1=gaoptimset('Generations',T/2,'InitialPopulation',finnal_pop,'Populationsize',35,'StallGenLimit',250,...
    'PlotFcns',@gaplotbestf);  %第二次进化属性
[x,fval,reason,output,finnal_pop]=ga(@ConstAndFit,2,options1);   %进行第二次接力进化
Bestx=x  %适应度最优个体
BestFval=-fval  %最佳适应度值
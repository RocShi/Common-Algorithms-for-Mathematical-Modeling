% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 3
% modified by 石鹏
% 与基于源代码的计算结果相比较，存在细微差别
%% 读入数据
clear,clc
data=xlsread('Coporation_evaluation.xlsx', 'B2:I16');  %读取数据
%% PCA计算
[pc,score] = princomp(data);
%% 计算主成分总得分
rows=size(data,1);
for i=1:rows
    total_score(i,1)=i;
    total_score(i,2)=sum(score(i,:));
end
%% 结果显示
result_report=[total_score score];
result_report_s=sortrows(result_report,-2);  %“-2”：按result_report的第二列降序排序
disp('主成分分数排序：')
result_report_s  %第1列为序号，第二列为各公司的主成分总得分，后三列分别为三个主成分的得分

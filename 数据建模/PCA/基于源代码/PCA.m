% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 3
% modified by 石鹏
clear,clc
A=xlsread('Coporation_evaluation.xlsx', 'B2:I16');  %读取数据
a=size(A,1);
b=size(A,2);
for i=1:b
    SA(:,i)=(A(:,i)-mean(A(:,i)))/std(A(:,i));  %数据标准化处理
end

CM=corrcoef(SA);  %计算相关系数矩阵

[V, D]=eig(CM);  %计算相关系数矩阵的特征值与特征向量

for j=1:b
    DS(j,1)=D(b+1-j, b+1-j);  %特征值，按降序进行排序
end
for i=1:b
    DS(i,2)=DS(i,1)/sum(DS(:,1));  %每个特征值的贡献率
    DS(i,3)=sum(DS(1:i,1))/sum(DS(:,1));  %特征值累计贡献率
end

%选择主成分及对应的特征向量
T=0.9;  %主成分信息保留率
for K=1:b
    if DS(K,3)>=T
        Com_num=K;  %根据累计贡献率求得的主成分数
        break;
    end
end

%提取主成分对应的特征向量
for j=1:Com_num
    PV(:,j)=V(:,b+1-j);
end

%计算各评价对象的主成分得分
new_score=SA*PV;
for i=1:a
    total_score(i,1)=i;
    total_score(i,2)=sum(new_score(i,:));
end
result_report=[total_score new_score];
result_report_s=sortrows(result_report,-2);  %“-2”：按result_report的第二列降序排序

% Displays result reports
disp('特征值及贡献率、累计贡献率：')
DS
disp('阀值T对应的主成分数与特征向量：')
Com_num
PV
disp('主成分分数：')
new_score
disp('主成分分数排序：')
result_report_s  %第1列为序号，第二列为各公司的主成分总得分，后三列分别为三个主成分的得分

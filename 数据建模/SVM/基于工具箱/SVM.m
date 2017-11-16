% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 3
% modified by 石鹏
%% 数据处理
clear,clc
X0=xlsread('SVM_data.xlsx', 'B2:E19');  %读入数据
Training=X0(:,1:3);  %特征数据
Group=X0(:,4);  %分类数据
%% SVM分类
SVMStruct = svmtrain(Training,Group);
%% 数据预测，此处使用的训练数据
pre = svmclassify(SVMStruct,Training)

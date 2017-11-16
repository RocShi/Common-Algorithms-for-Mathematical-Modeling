% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 3
% modified by 石鹏
% 采用“朴素贝叶斯判别”的方法求解SVM中的“银行贷款”实例，训练中间数据，预测边缘
% 数据，类似于SVM分类结果，同样存在判别误差。训练边缘数据，预测中间数据，误差更显著。
clear,clc
train_sam=xlsread('SVM_data.xlsx', 'B6:E15');  %读取部分数据用作训练集，其余数据用作测试集
ObjBayes=NaiveBayes.fit(train_sam(:,1:3),train_sam(:,4));  %训练数据
test1=xlsread('SVM_data.xlsx', 'B2:D5');  %读取测试数据集1
test2=xlsread('SVM_data.xlsx', 'B16:D19');  %读取测试数据集2
test=[test1 test2];
pre1=ObjBayes.predict(test1)  %预测测试数据集1
pre2=ObjBayes.predict(test2)  %预测测试数据集2

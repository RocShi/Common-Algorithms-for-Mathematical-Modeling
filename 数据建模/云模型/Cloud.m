% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 3
% modified by 石鹏
function Cloud()  %云模型主程序
clear,clc
N = 1500;  % 每幅图生成N个云滴

% 原始数据，按列存储
Y = [9.5 10.3 10.1 8.1 
10.3 9.7 10.4 10.1 
10.6 8.6 9.2 10.0 
10.5 10.4 10.1 10.1 
10.9 9.8 10.0 10.1 
10.6 9.8 9.7 10.0 
10.4 10.5 10.6 10.3
10.1 10.2 10.8 8.4 
9.3 10.2 9.6 10.0 
10.5 10.0 10.7 9.9]';

for i = 1:size(Y,1)
    subplot(size(Y,1)/2,2,i)
    % 调用函数
    [x,y,Ex,En,He] = cloud_transform(Y(i,:),N);
    plot(x,y,'r.');
    xlabel('射击成绩分布/环');
    ylabel('确定度');
    title(strcat('第',num2str(i),'人射击云模型还原图谱'));  %巧妙设置title
    % 控制坐标轴的范围
    % 统一坐标轴范围才会在云模型形态上具有可比性
    axis([8,12,0,1]);
end

function [x,y,Ex,En,He] = cloud_transform(y_spor,n)  %云转换子函数
 % x 表示云滴
 % y 表示隶属度（这里是“钟形”隶属度），意义是度量倾向的稳定程度
 % Ex 云模型的数字特征，表示期望
 % En 云模型的数字特征，表示熵
 % He 云模型的数字特征，表示超熵
 
 % 通过统计数据样本计算云模型的数字特征
 Ex = mean(y_spor);
 En = mean(abs(y_spor-Ex))*sqrt(pi/2);
 He = sqrt(var(y_spor)-En^2);

 % 通过云模型的数字特征还原更多的“云滴”
 for q = 1:n
     Enn = randn(1)*He + En ;  %正态分布的定义
     x(q) = randn(1)*Enn + Ex ;
     y(q) = exp(-(x(q) - Ex)^2/(2*Enn^2));
 end

% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 4
% modified by 石鹏
clc;
close;
clear all;
format short;  % 控制输出结果精度
% 原始数据矩阵
x=[308.58 310 295 346 367
195.4 189.9 187.2 205 222.7
24.6 21 12.2 15.1 14.57
20 25.6 23.3 29.2 30
18.98 19 22.3 23.5 27.655
170 174 197 216.4 235.8
57.55 70.74 76.8 80.7 89.85
88.56 70 85.38 99.83 103.4
11.19 13.28 16.82 18.9 22.8
4.03 4.26 4.34 5.06 5.78
13.7 15.6 13.77 11.98 13.95];
n1=size(x,1);  %求数据矩阵行数
n2=size(x,2);
% 数据标准化处理
% for i = 1:n1
% x(i,:) = x(i,:)/x(i,1);
% end  %该数据处理方法有误，应为每列数据除以该列所对应的固定资产投资，或直接采用源数据

consult=x(6:n1,:);  % 分离参考数列（母因素）
m1=size(consult,1);  %参考数列行数

compare=x(1:5,:);  % 分离比较数列（子因素）
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

% 输出关联度值并绘制柱形图
r
bar(r,0.90);  %绘制关联度矩阵的柱状图，并设置每个柱形的宽度为0.9
axis tight;  %Set the axis limits to the range of the data.
% 从左至右依次是 固定资产投资,工业投资,农业投资,科技投资,交通投资
le=legend('固定资产投资','工业投资','农业投资','科技投资','交通投资');  %le为图例句柄
set(le,'fontname','楷体');  %此句自行添加，设置图例字体为楷体


% 以下程序是为了给x轴添加汉字标签
% 其基本原理是先去掉x轴上的固有标签，然后用文本标注x轴

set(gca,'XTickLabel','');  % 去掉当前X轴上的刻度值

%  设定X轴刻度的位置，这里有6个母因素
n=6;
% 这里注意：x_range范围如果是[1 n]会导致部分柱形条不能显示出来
% 所以范围要缩一点
x_value = 1:1:n;
x_range = [0.6 n+.4];  %[0.6 6.4]
% 获取当前图形的句柄
set(gca,'XTick',x_value,'XLim',x_range);

% 在X轴上标记6个母因素
profits={'国民收入','工业收入','农业收入','商业收入','交通收入','建筑业收入'};
y_range = ylim;
% 用文本标注母因素名称
handle_date = text(x_value,y_range(1)*ones(1,n)-.001,profits(1:1:n));  %handle_date为添加的文本的句柄。此处text函数的用法为text(x,y,'String')，String为欲显示的文本，x、y为文本坐标
% 把文本的字体设置合适的格式和大小并旋转一定的角度
set(handle_date,'HorizontalAlignment','right','VerticalAlignment','top', 'Rotation',35,...
'fontname','楷体','fontsize',10.5);
% y轴标记
ylabel('y');
ti=title('投资对收入的作用');  %ti为figure标题的句柄
set(ti,'fontname','楷体','fontsize',10.5);  %此句自行添加，设置figure标题字体为楷体

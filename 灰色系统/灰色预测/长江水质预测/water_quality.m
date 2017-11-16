% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 4
% modified by 石鹏

clc, clear all, close all
syms a b;
u=[a b]';
x0=[174	179	183	189	207 234	220.5 256	270	285];  %原始数据
x1=cumsum(x0);  % 原始数据累加
n=length(x0);
for i=1:(n-1)
    C(i)=(x1(i)+x1(i+1))/2;  % 计算紧邻均值
end
% 计算待定参数的值
Y=x0(2:end)';
B=[-C;ones(1,n-1)];
u=inv(B*B')*B*Y;
u=u';
a=u(1);b=u(2);
% 预测后续数据
forcast_temp=[];forcast_temp(1)=x0(1);
for i=2:(n+10)
    forcast_temp(i)=(x0(1)-b/a)/exp(a*(i-1))+b/a ;
end
forecast=[];forecast(1)=x0(1);
for i=2:(n+10)
    forecast(i)=forcast_temp(i)-forcast_temp(i-1); %得到预测出来的数据
end 
t1=1995:2004;
t2=1995:2014;
forecast, a, b % 输出预测值，发展系数和灰色作用量

epsilon = x0 - forecast(1:n);  % 计算残差
delta = abs(epsilon./x0);  % 计算相对误差

% 检验模型的误差
% 检验方法一：相对误差Q检验法，Q越小模型越精确
Q = mean(delta)

% 检验方法二：方差比C检验法
% 计算标准差函数为std（x,a）
% 如果后面一个参数a取0表示的是除以n－1，如果是1就是最后除以n
C = std(epsilon,1)/std(x0,1)

% 检验方法三：小误差概率P检验法
S1 = std(x0,1);
S1_new = S1*0.6745;
temp_P = find(abs(epsilon-mean(epsilon)) < S1_new);
P = length(temp_P)/n

plot(t1,x0,'ko', 'LineWidth',2)
hold on
plot(t2,forecast,'k', 'LineWidth',2)
xlabel('年份', 'fontsize',12)
ylabel('污水量/亿吨','fontsize',12)
set(gca,  'LineWidth',2);

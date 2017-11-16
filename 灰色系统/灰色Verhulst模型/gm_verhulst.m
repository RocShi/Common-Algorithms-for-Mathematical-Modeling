% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 4
% modified by 石鹏

clc, clear all, close all
% 大肠杆菌测定的光密度值
x1=[0.025 0.023 0.029 0.044 0.084 0.164 0.332 0.521 0.97 1.6 2.45 3.11 3.57 3.76 3.96 4 4.46 4.4 4.49 4.76 5.01];
n=length(x1);
time=0:n-1;
figure(1);
plot(time,x1,'k*');  %绘制实际数据
x0=diff(x1);
x0=[x1(1),x0];  %需通过x0生成Y
for i=2:n
    z1(i)=0.5*(x1(i)+x1(i-1));
end
z1;
B=[-z1(2:end)',z1(2:end)'.^2];
Y=x0(2:end)';
% 当然也可以使用最小二乘法和verhulst灰色模型的具体表达式来求解
% 前面章节已经有很详细的讲解了
abvalue=B\Y;
x=dsolve('Dx+a*x=b*x^2','x(0)=x0');
x=subs(x,{'a','b','x0'},{abvalue(1),abvalue(2),x1(1)});
forecast=subs(x,'t',0:n-1);
digits(6);x=vpa(x);
forecast

epsilon = x1 - forecast;  % 计算残差
delta = abs(epsilon./x1);  % 计算相对误差

% 检验模型的误差
% 检验方法一：相对误差Q检验法，Q越小模型越精确
Q = mean(delta)

% 检验方法二：方差比C检验法
% 计算标准差函数为std（x,a）
% 如果后面一个参数a取0表示的是除以n－1，如果是1就是最后除以n
C = std(epsilon,1)/std(x1,1)

% 检验方法三：小误差概率P检验法
S1 = std(x1,1);
S1_new = S1*0.6745;
temp_P = find(abs(epsilon-mean(epsilon)) < S1_new);
P = length(temp_P)/n

% 绘图
hold on;
plot(time,forecast,'k-.','linewidth',3);
xlabel('时间均匀采样/5小时','fontsize',12);
ylabel('细菌培养液吸光度/OD600', 'fontsize',12);
legend('实际数量','预测数量');
title('大肠杆菌培养S形增长曲线','fontsize',12);
axis tight;

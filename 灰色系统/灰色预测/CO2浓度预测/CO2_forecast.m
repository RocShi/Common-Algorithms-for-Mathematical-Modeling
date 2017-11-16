format short g  %关闭科学计数法
data=load('CO2.txt');  %加载数据，来源于https://www.co2.earth/annual-co2
nn = size(data,1);
x0 = data(1:54,2)';  %取源数据前54年计算灰色模型
n = length(x0);

% 做级比判断，看看是否适合用GM(1，1)建模
lamda = x0(1:n-1)./x0(2:n);  %级比
range = minmax(lamda);  %输出级比向量lamda的最值
% 判定是否适合用一阶灰色模型建模
if range(1,1) < exp(-(2/(n+1))) | range(1,2) > exp(2/(n+1))  %更正了原程序中级比界限的错误
    error('级比没有落入灰色模型的范围内');  %输出错误信息
else
   % 空行输出
    disp('              ');
    disp('可用G(1，1)建模');
end

% 做AGO累加处理
x1 = cumsum(x0);  % Returns a vector containing the cumulative sum of the elements of x0.
for i = 2:n
    % 计算紧邻均值，也就是白化背景值
    z(i) = 0.5*(x1(i)+x1(i-1));
end
B = [-z(2:n)',ones(n-1,1)];
Y = x0(2:n)';
% 矩阵做除法，计算发展系数a和灰色作用量b
% 千万注意：这里是右除，不是左除
u = B\Y;  %注意此处并不等效于inv(B)*Y，因为inv函数的输入必须为方阵
x = dsolve('Dx+a*x=b','x(0)=x0');  %dsolve函数用来求解符号常微分方程,此处用法为dsolve('方程','初始条件')。此模型为GM(1,1)白化模型，变量x实为x1
x = subs(x,{'a','b','x0'},{u(1),u(2),x1(1)});  %将符号表达式x中的a,b,x0换成具体u(1),u(2),x1(1)数值，此处x1(1)=x0(1)
forecast1 = subs(x,'t',[0:nn-1]);  %forecast1为预测得到的x1序列
% digits和vpa函数用来控制计算的有效数字位数
digits(6);  %设置6位有效数字
% y值是AGO形式的（还是累加的）
y = vpa(x);  %将灰色模型预测值有效位数保留为6位
% 把AGO输出值进行累减
% diff用于对符号表达式进行求导
% 但是如果输入的是向量，则表示计算原向量相邻元素的差
forecast11 = double(forecast1);
exchange = diff(forecast11);  %通过模型预测得到的为x1序列，需对预测数列进行IAGO处理才可得到x0序列
forecast = [x0(1),exchange]  % 输出灰色模型预测的值

epsilon = x0 - forecast(1:54);  % 计算残差
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

% 绘制原始数列与灰色模型预测得出的数列差异折线图
plot(1959:2015,data(1:nn,2),'*','markersize',11);
hold on
plot(1959:2015,forecast,'k-','linewidth',2.5);
grid on;
axis tight;
xlabel('年份');
ylabel('CO2年浓度/ppm');
title('1959-2015全球CO2年浓度');
legend('原始数据','灰色模型预测数据');
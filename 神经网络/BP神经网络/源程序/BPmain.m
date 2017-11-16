% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 7
% modified by 石鹏
function main()
clc                         %清屏
clear all;                  %清除内存以便加快运算速度
close all;                  %关闭当前所有figure图像
SamNum=20;                  %输入样本数量20
TestSamNum=20;              %测试样本数量20
ForcastSamNum=2;            %预测样本数量为2
HiddenUnitNum=8;            %中间层隐节点数量取8,比工具箱程序多1个
InDim=3;                    %网络输入维度
OutDim=2;                   %网络输出维度

%原始数据，程序入口，可修改
%人数(单位：万人)
sqrs=[20.55 22.44 25.37 27.13 29.45 30.10 30.96 34.06 36.42 38.09 39.13 39.99 ...
       41.93 44.59 47.30 52.89 55.73 56.76 59.17 60.63];
%机动车数(单位：万辆)
sqjdcs=[0.6 0.75 0.85 0.9 1.05 1.35 1.45 1.6 1.7 1.85 2.15 2.2 2.25 2.35 2.5 2.6...
        2.7 2.85 2.95 3.1];
%公路面积(单位：万平方公里)
sqglmj=[0.09 0.11 0.11 0.14 0.20 0.23 0.23 0.32 0.32 0.34 0.36 0.36 0.38 0.49 ... 
         0.56 0.59 0.59 0.67 0.69 0.79];
%公路客运量(单位：万人)
glkyl=[5126 6217 7730 9145 10460 11387 12353 15750 18304 19836 21024 19490 20433 ...
        22598 25107 33442 36836 40548 42927 43462];
%公路货运量(单位：万吨)
glhyl=[1237 1379 1385 1399 1663 1714 1834 4322 8132 8936 11099 11203 10524 11115 ...
        13320 16762 18673 20724 20803 21804];
p=[sqrs;sqjdcs;sqglmj];    %输入数据矩阵
t=[glkyl;glhyl];           %目标数据矩阵
[SamIn,minp,maxp,tn,mint,maxt]=premnmx(p,t); %原始样本对（输入和输出）归一化到[-1,1]间，SamIn为归一化后的输入矩阵，tn为归一化后的输出矩阵。premnmx进行归一化的数据必须列数相同

rand('state',sum(100*clock))      %依据系统时钟种子产生随机数         
NoiseVar=0.01;                    %噪声强度为0.01（添加噪声的目的是为了防止网络过度拟合）
Noise=NoiseVar*randn(2,SamNum);   %生成噪声，randn函数：生成服从正态分布的随机矩阵
SamOut=tn + Noise;                %将噪声添加到输出样本上

TestSamIn=SamIn;                           %这里取输入样本与测试样本相同因为样本容量偏少
TestSamOut=SamOut;                         %也取输出样本与测试样本相同

MaxEpochs=50000;                              %最大训练次数为50000
lr=0.035;                                     %学习速率为0.035
E0=0.65*10^(-3);                              %目标误差为0.65*10^(-3)
W1=0.5*rand(HiddenUnitNum,InDim)-0.1;   %初始化输入层与隐含层之间的权值。假设输入层与输出层放置的均为线性函数。为什么要左乘0.5，右减0.1？
B1=0.5*rand(HiddenUnitNum,1)-0.1;       %初始化输入层与隐含层之间的阈值
W2=0.5*rand(OutDim,HiddenUnitNum)-0.1;  %初始化输出层与隐含层之间的权值              
B2=0.5*rand(OutDim,1)-0.1;              %初始化输出层与隐含层之间的阈值

ErrHistory=[];                          %给中间变量预先占据内存
for i=1:MaxEpochs  %开始训练网络
    
    HiddenOut=logsig(W1*SamIn+repmat(B1,1,SamNum)); % 隐含层网络输出。logsig,S型传递函数。因为输入层放置的为线性函数，所以输入层输出=输入。隐含层输出维度：[HiddenUnitNum,SamNum]
    NetworkOut=W2*HiddenOut+repmat(B2,1,SamNum);    % 输出层网络输出。repmat（x,m,n）：重铺函数,将x视作整体以进行m×n重铺。输出层输出维度：[OutDim,SamNum]
    Error=SamOut-NetworkOut;                        % 实际输出与网络输出之差。SamOut与NetworkOut的维度均为：[OutDim,SamNum]
    SSE=sumsqr(Error)                               % 能量函数（误差平方和）。sumsqr：求平方和函数

    ErrHistory=[ErrHistory SSE];   %此行有什么作用？ 

    if SSE<E0,break, end   %如果达到误差要求则跳出学习循环
    
    % 以下六行是BP网络最核心的程序
    % 它们是权值（阈值）依据能量函数负梯度下降原理所作的每一步动态调整量。关于权值、阈值调整量，参考《MATLAB在数学建模中的应用 ·
    % 第2版》 chapter 7的P130、P131
    Delta2=Error;
    Delta1=W2'*Delta2.*HiddenOut.*(1-HiddenOut);   %应理解.*与*的区别    

    dW2=Delta2*HiddenOut';
    dB2=Delta2*ones(SamNum,1);
    
    dW1=Delta1*SamIn';
    dB1=Delta1*ones(SamNum,1);
    %对输出层与隐含层之间的权值和阈值进行修正。此处不应是减么？
    W2=W2+lr*dW2;
    B2=B2+lr*dB2;
    %对输入层与隐含层之间的权值和阈值进行修正。此处不应是减么？
    W1=W1+lr*dW1;
    B1=B1+lr*dB1;
end

HiddenOut=logsig(W1*SamIn+repmat(B1,1,TestSamNum)); % 隐含层输出最终结果
NetworkOut=W2*HiddenOut+repmat(B2,1,TestSamNum);    % 输出层输出最终结果
a=postmnmx(NetworkOut,mint,maxt);                   % 还原网络输出层的结果。postmnmx：逆归一化函数，以premnmx的参数进行逆归一化。a为行数为2的矩阵
x=1990:2009;                                        % 时间轴刻度
newk=a(1,:);                                        % 取出矩阵a的首行元素值——网络输出客运量，用于绘图。
newh=a(2,:);                                        % 取出矩阵a的次行元素值——网络输出货运量，用于绘图。
figure ;
subplot(2,1,1);plot(x,newk,'r-o',x,glkyl,'b--+')    %绘值公路客运量对比图。subplot(m,n,p)：将图像排列成m行n列，并开始绘制第p幅图
legend('网络输出客运量','实际客运量');
xlabel('年份');ylabel('客运量/万人');
subplot(2,1,2);plot(x,newh,'r-o',x,glhyl,'b--+')    %绘制公路货运量对比图；
legend('网络输出货运量','实际货运量');
xlabel('年份');ylabel('货运量/万吨');

% 利用训练好的网络进行预测
% 当用训练好的网络对新数据pnew进行预测时，也应作相应的处理
pnew=[73.39 75.55
      3.9635 4.0975
      0.9880 1.0268];                  %2010年和2011年的相关数据，一列为一年
pnewn=tramnmx(pnew,minp,maxp);         %利用原始输入数据的归一化参数对新数据进行归一化。tramnmx：对预测数据进行归一化，需要在premnmx后使用
HiddenOut=logsig(W1*pnewn+repmat(B1,1,ForcastSamNum)); % 隐含层输出预测结果
anewn=W2*HiddenOut+repmat(B2,1,ForcastSamNum);         % 输出层输出预测结果

%把网络预测得到的数据还原为原始的数量级；
anew=postmnmx(anewn,mint,maxt)         

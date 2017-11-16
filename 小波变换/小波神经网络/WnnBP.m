% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 10
% modified by 石鹏

function main()
clc;clear all;close all;
%用Mexihat函数作为样本输入和输出
x=0:0.03:3; %样本输入值
c=2/(sqrt(3).*pi.^(1/4));
d=1/sqrt(2);
u=x/2-1;
targ=d.*c.*exp(-u.^2/2).*(1-u.^2);  % 目标函数的样本输出值
eta=0.02; aerfa=0.735; %赋予网络学习速率和动量因子初始值
%初始化输出层和隐含层的连接权值wjh及隐含层和输入层的连接权值whi.
%假设小波函数节点数为H,样本数为P,输出节点数为J,输入节点数为I.
H=15;P=2;I=length(x);J=length(targ);
b=rand(H,1);a=rand(H,1); %初始化小波参数。伸缩因子与平移因子向量
whi=rand(I,H);wjh=rand(H,J); %初始化权系数；
b1=rand(H,1);b2=rand(J,1); %初始化阈值;
p=0;
Err_NetOut=[]; %保存的误差；
flag=1;count=0;
while flag>0
flag=0;
count=count+1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xhp1=0;
for h=1:H  %此循环完成后便得到了隐含层各节点的净输入
    for i=1:I
        xhp1=xhp1+whi(i,h)*x(i);  %xhp1为输入层对第h个隐含层节点的加权输入
    end
ixhp(h)=xhp1+b1(h);  %ixhp(h)为第h个隐含层节点的净输入（包括加权输入与阈值在内）
xhp1=0;  %xhp1清零
end

for h=1:H
oxhp(h)=fai((ixhp(h)-b(h))/a(h));  %oxhp(h)为隐含层第h个节点的输出，fai为隐含层小波传递函数
end

ixjp1=0;
for j=1:J  %此循环完成后便得到了输出层各节点的净输入
  for h=1:H
      ixjp1=ixjp1+wjh(h,j)*oxhp(h);  %ixjp1为隐含层对第j个输出层节点的加权输入
  end
ixjp(j)=ixjp1+b2(j);  %ixjp(j)为第j个输出层节点的净输入（包括加权输入与阈值在内）
ixjp1=0;  %ixjp1清零
end

for j=1:J
    oxjp(j)=fnn(ixjp(j));  %oxjp(j)为输出层第j个节点的输出
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
wuchayy=1/2*sumsqr(oxjp-targ);
Err_NetOut=[Err_NetOut wuchayy];  %保存每次的误差
%求解小波网络运用BP算法，各参数每次学习的调整量
for j=1:J
    detaj(j)=-(oxjp(j)-targ(j))*oxjp(j)*(1-oxjp(j));
end
for j=1:J
  for h=1:H
      detawjh(h,j)=eta*detaj(j)*oxhp(h);
  end
end
detab2=eta*detaj;
sum=0;
for h=1:H
  for j=1:J
      sum=detaj(j)*wjh(h,j)*diffai((ixhp(h)-b(h))/a(h))/a(h)+sum;
  end
detah(h)=sum;
sum=0;
end
for h=1:H
  for i=1:I
      detawhi(i,h)=eta*detah(h)*x(i);
  end
end
detab1=eta*detah;
detab=-eta*detah;
for h=1:H
    detaa(h)=-eta*detah(h)*((ixhp(h)-b(h))/a(h));
end

%引入动量因子aerfa，加快收敛速度和阻碍陷入局部极小值。动态调整加权系数、阈值、伸缩因子、平移因子
wjh=wjh+(1+aerfa)*detawjh;
whi=whi+(1+aerfa)*detawhi;
a=a+(1+aerfa)*detaa';
b=b+(1+aerfa)*detab';
b1=b1+(1+aerfa)*detab1';
b2=b2+(1+aerfa)*detab2';

%本算法采用的是样本逐个处理而不是数据批处理
p=p+1;
if p~=P
    flag=flag+1;
else
    if Err_NetOut(end)>0.008  %网络输出误差不满足精度要求，且学习次数不超过6000，则继续学习
        flag=flag+1;  
    else  %网络输出误差满足精度要求  
        figure;
        plot(Err_NetOut);
        xlabel('网络学习次数');ylabel('网络输出误差');
        title('网络学习误差曲线','fontsize',20,'color',[0 1 1],'fontname','隶书');
    end
end
if count>6000  %学习次数超过6000，停止学习
    figure(1);
    subplot(1,2,1)
    plot(Err_NetOut,'color','b','linestyle','-','linewidth',2.2,...
        'marker','^','markersize',3.5);
    xlabel('网络学习次数');ylabel('网络输出误差');
    title('误差曲线','fontsize',20,'color',[1 1 1],'fontname','隶书');
    subplot(1,2,2)
    plot(x,targ,'color','r','linestyle','--','linewidth',2.2,...
        'marker','p','markersize',3.5);
    hold on  %同一幅图像上绘制多条曲线，需要进行曲线保持
    plot(x,oxjp,'color','g','linestyle','-.','linewidth',2.2,...
        'marker','d','markersize',3.5);
    xlabel('样本输入值');ylabel('样本目标值与网络输出值');
    title('目标值与网络输出值比较','fontsize',20,'color',[1 1 1],'fontname','隶书');
    legend('样本目标值','网络仿真值');
    break;
end
end

function y3=diffai(x)  %子程序，计算参数调整量时用到
y3=-1.75*sin(1.75*x).*exp(-x.^2/2)-cos(1.75*x).*exp(-x.^2/2).*x;

function yl=fai(x)  %隐含层传递函数子程序，Morlet小波？
yl=cos(1.75.*x).*exp(-x.^2/2);

function y2=fnn(x)  %子程序，输出层放置的是S型传递函数logsig？
y2=1/(1+exp(-x));

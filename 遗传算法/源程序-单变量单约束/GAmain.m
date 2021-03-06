% 主程序：用遗传算法求解y=200*exp(-0.05*x).*sin(x)在[-2 2]区间上的最大值
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% modified by 石鹏

clc;
clear all;
close all;
global BitLength  %种群个体二进制编码长度
global boundsbegin  %规划边界起点值
global boundsend  %规划边界终点值
bounds=[-2 2];  %一维自变量的取值范围
precision=0.0001;  %运算精度
boundsbegin=bounds(:,1);
boundsend=bounds(:,2);
BitLength=ceil(log2((boundsend-boundsbegin)' ./ precision)); %计算种群个体二进制编码长度，ceil函数：朝正无穷方向取整
popsize=100; %初始种群大小。种群数量取大些往往能在多次的程序运行中都进化出较好的结果（种群平均适应度与最大适应度在进化后期的平稳趋近程度）
Generationnmax=12  %最大代数
pcrossover=0.90; %交配概率
pmutation=0.09; %变异概率
population=round(rand(popsize,BitLength));  %rand函数用于产生服从标准正态分布，且元素取值在0-1间的随机数组；round函数为四舍五入函数。最终生成种群各个个体的二进制串
[Fitvalue,cumsump]=fitnessfun(population);  %计算适应度,返回适应度Fitvalue和累积概率cumsump
Generation=1;
while Generation<Generationnmax+1
   for j=1:2:popsize  %依照“轮盘选择法”每次从原种群中选择、复制两个个体，被选出的个体交配、变异与否“听天由命”。程序的逻辑与书中描述的遗传算法原理有出入 
      %选择复制操作
      seln=selection(cumsump);
      %交配操作
      scro=crossover(population,seln,pcrossover);
      scnew(j,:)=scro(1,:);
      scnew(j+1,:)=scro(2,:);
      %变异操作
      smnew(j,:)=mutation(scnew(j,:),pmutation);
      smnew(j+1,:)=mutation(scnew(j+1,:),pmutation);
   end
   population=smnew;  %产生了新的种群
   %计算新种群的适应度   
   [Fitvalue,cumsump]=fitnessfun(population);
   %记录当前代最好的适应度和平均适应度
   [fmax,nmax]=max(Fitvalue);  %求适应度列向量中的最大值及其位置
   fmean=mean(Fitvalue);
   ymax(Generation)=fmax;  %当前代种群最佳适应度
   ymean(Generation)=fmean;  %当前代种群平均适应度
   %记录当前代的最佳染色体个体
   x=transform2to10(population(nmax,:));
   %自变量取值范围是[-2 2],需要把经过遗传运算的最佳染色体整合到[-2 2]区间
  xx=boundsbegin+x*(boundsend-boundsbegin)/(power(2,BitLength)-1);  %此处将原程序中power函数的第一参数（boundsend）改为2
   xmax(Generation)=xx;  %当前代适应度最佳个体
   Generation=Generation+1;
end
Generation=Generation-1;  %最终遗传代数
Bestpopulation=xx  %最佳个体
Besttargetfunvalue=targetfun(xx)  %最佳目标值

%绘制经过遗传运算后的适应度曲线。一般地，如果进化过程中种群的平均适应度与最大适
%应度在曲线上有相互趋同的形态，表示算法收敛进行得很顺利，没有出现震荡；在这种前
%提下，最大适应度个体连续若干代都没有发生进化表明种群已经成熟。
figure(1);
hand1=plot(1:Generation,ymax);  %各代种群中个体的最佳适应度值
set(hand1,'linestyle','-','linewidth',1.8,'marker','^','markersize',6)  %set函数非常实用
hold on;
hand2=plot(1:Generation,ymean);   %各代种群的平均适应度值
set(hand2,'color','r','linestyle','-','linewidth',1.8,...
'marker','h','markersize',6)
xlabel('进化代数'); ylabel('最大/平均适应度'); xlim([1 Generationnmax]);  %xlim函数用于指定figure中横坐标取值范围
legend('最大适应度','平均适应度');
box off;  %用于关闭figure中的上边框与右边框
hold on;  %关闭figure保持
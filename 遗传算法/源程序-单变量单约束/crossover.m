% 子程序：新种群交配操作,函数名称存储为crossover.m
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% modified by 石鹏

function scro=crossover(population,seln,pc);
BitLength=size(population,2);  %个体二进制串长度，size(a,2)：求矩阵a的列数
pcc=IfCroIfMut(pc);  %根据交配概率决定是否进行交配操作，1则是，0则否
if pcc==1
   chb=round(rand*(BitLength-2))+1;  %在[1,BitLength-1]范围内随机产生一个交配位
   %将selection函数选择的两个个体进行单点交配，scro为交配后的新个体
   scro(1,:)=[population(seln(1),1:chb) population(seln(2),chb+1:BitLength)];
   scro(2,:)=[population(seln(2),1:chb) population(seln(1),chb+1:BitLength)];
else
   scro(1,:)=population(seln(1),:);
   scro(2,:)=population(seln(2),:);
end
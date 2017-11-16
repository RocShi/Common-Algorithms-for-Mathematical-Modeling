% 子程序：新种群变异操作，函数名称存储为mutation.m
% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 5
% modified by 石鹏

function snnew=mutation(snew,pm);  %pm为变异概率
BitLength=size(snew,2);
snnew=snew;
pmm=IfCroIfMut(pm);  %根据变异概率决定是否进行变异操作，1则是，0则否
if pmm==1
   chb=round(rand*(BitLength-1))+1;  %在[1,BitLength]范围内随机产生一个变异位
   snnew(chb)=abs(snew(chb)-1);
end
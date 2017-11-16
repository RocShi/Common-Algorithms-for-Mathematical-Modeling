% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 6
% modified by 石鹏
clear
clc
a = 0.95;  %温度下降系数
t0 = 97; tf = 3; t = t0;  %t0为初始温度，tf为终止温度，t为当前温度
k = [5;10;13;4;3;11;13;10;8;16;7;4];
k = -k;	% 模拟退火算法是求解最小值，故取负数
price = [2;5;18;3;2;5;10;4;11;7;14;6];
restriction = 46;  %重量约束
num = 12;
sol_new = ones(1,num);         % 生成初始解
E_current = inf;
E_best = inf;  
% E_current是当前解对应的目标函数值（即背包中物品总价值）；
% E_new是新解的目标函数值；
% E_best是最优解的
sol_current = sol_new; 
sol_best = sol_new;
p=1;

while t>=tf
	for r=1:100  %每一当前温度下，进行100次迭代
		%产生随机扰动
		tmp=ceil(rand.*num);
		sol_new(1,tmp)=~sol_new(1,tmp);
		
		%检查是否满足约束
		while 1
			q=(sol_new*price <= restriction);  %总重量判别标志
			if ~q
                p=~p;	%实现交错着逆转头尾的第一个1
                tmp=find(sol_new==1);  %寻找新解01串中“1”的位置，输出为一个行向量
                if p
                    sol_new(1,tmp)=0;  %什么意思？为什么要这么做？
                else
                    sol_new(1,tmp(end))=0;  %什么意思？为什么要这么做？
                end
            else
                break
			end
		end
		
		% 计算背包中的物品价值
		E_new=sol_new*k;
		if E_new<E_current
            E_current=E_new;
            sol_current=sol_new;
            if E_new<E_best
				% 把冷却过程中最好的解保存下来
                E_best=E_new;
                sol_best=sol_new;
            end
		else
            if rand<exp(-(E_new-E_current)./t)
                E_current=E_new;
                sol_current=sol_new;
            else
                sol_new=sol_current;
            end
		end
	end
	t=t.*a;
end

disp('最优解为：')
sol_best
disp('物品总价值等于：')
val=-E_best;
disp(val)
disp('背包中物品重量是：')
disp(sol_best * price)

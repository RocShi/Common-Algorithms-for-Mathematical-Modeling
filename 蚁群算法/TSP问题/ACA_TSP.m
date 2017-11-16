% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 9
% modified by 石鹏
% 蚁群算法解决的问题实质上都属于排序问题？
%% 数据准备
clear all,clc
t0 = clock;  % 进行程序运行计时，可查询clock函数
citys=xlsread('data.xlsx', 'B2:C53');  % 导入数据
%--------------------------------------------------------------------------
%% 计算城市间相互距离
n = size(citys,1);  % 城市数量
D = zeros(n,n);
for i = 1:n
    for j = 1:n
        if i ~= j
            D(i,j) = sqrt(sum((citys(i,:) - citys(j,:)).^2));  % 城市间距离对角矩阵
        else
            D(i,j) = 1e-4;      % 设定的对角矩阵修正值
        end
    end    
end
%--------------------------------------------------------------------------
%% 初始化参数
m = 75;                              % 蚂蚁数量。蚂蚁数量与城市数量比值为1.5时较为合理
alpha = 1;                           % 信息素重要程度因子（信息素因子）。信息素因子处于[1,4]之间较为合理
beta = 4.5;                          % 启发函数重要程度因子（启发函数因子）。启发函数因子处于[3,4.5]之间较为合理
vol = 0.2;                           % 信息素挥发(volatilization)因子。信息素挥发因子处于[0.2,0.5]之间较为合理
Q = 10;                              % 信息素常系数。信息素常系数处于[10,1000]之间较为合理
Heu_F = 1./D;                        % 启发函数(heuristic function)
Tau = ones(n,n);                     % 信息素矩阵
Table = zeros(m,n);                  % 路径记录表
iter = 1;                            % 迭代次数初值
iter_max = 100;                      % 最大迭代次数 
Route_best = zeros(iter_max,n);      % 各代最佳路径       
Length_best = zeros(iter_max,1);     % 各次迭代的最佳路径长度  
Length_ave = zeros(iter_max,1);      % 各次迭代的路径平均长度  
Limit_iter = 0;                      % 程序收敛时迭代次数
%-------------------------------------------------------------------------
%% 迭代寻找最佳路径
while iter <= iter_max  % 每迭代1次
    % 随机产生各个蚂蚁的起点城市
      start = zeros(m,1);
      for i = 1:m
          temp = randperm(n);
          start(i) = temp(1);
      end
      Table(:,1) = start; 
      % 构建解空间
      citys_index = 1:n;
      % 逐个蚂蚁路径选择
      for i = 1:m
          % 逐个城市路径选择
         for j = 2:n  % 生成第i个蚂蚁剩余的访问城市路径
             tabu = Table(i,1:(j - 1));         % 已访问的城市集合(禁忌表)
             allow_index = ~ismember(citys_index,tabu);    % ismember(a,b):查找矩阵或向量a中是否存在矩阵或向量b中的元素，返回与a同维度的逻辑矩阵
             allow = citys_index(allow_index);  % 待访问的城市集合
             P = allow;  % 对P赋的值（allow）并无实际意义，仅为了使P与allow具有相同维度
             % 计算城市间转移概率
             for k = 1:length(allow)
                 P(k) = Tau(tabu(end),allow(k))^alpha * Heu_F(tabu(end),allow(k))^beta;  % 计算从当前位置出发至未访问城市的概率，tabu(end)为当前位置，allow(k)为第k个未访问的城市
             end
             P = P/sum(P);
             % 轮盘法选择下一个访问城市
             Pc = cumsum(P);     % 计算累积转移概率
             target_index = find(Pc >= rand);   
             target = allow(target_index(1));
             Table(i,j) = target;
         end
      end
      % 计算各个蚂蚁的路径距离
      Length = zeros(m,1);
      for i = 1:m
          Route = Table(i,:);
          for j = 1:(n - 1)
              Length(i) = Length(i) + D(Route(j),Route(j + 1));
          end
          Length(i) = Length(i) + D(Route(n),Route(1));  %第i个蚂蚁的路径寻迹距离
      end
      % 计算最短路径距离及平均距离
      if iter == 1
          [min_Length,min_index] = min(Length);  % [min_value,min_index] = min(a):返回向量a中的最小元素min_value与min_value在在向量a中的位置
          Length_best(iter) = min_Length;  
          Length_ave(iter) = mean(Length);
          Route_best(iter,:) = Table(min_index,:);
          Limit_iter = 1; 
          
      else
          [min_Length,min_index] = min(Length);
          Length_best(iter) = min(Length_best(iter - 1),min_Length);
          Length_ave(iter) = mean(Length);
          if Length_best(iter) == min_Length
              Route_best(iter,:) = Table(min_index,:);
              Limit_iter = iter; 
          else
              Route_best(iter,:) = Route_best((iter-1),:);
          end
      end
      % 更新信息素
      Delta_Tau = zeros(n,n);  % 初始化信息素增量
      % 逐个蚂蚁计算
      for i = 1:m
          for j = 1:(n - 1)   % 计算
              Delta_Tau(Table(i,j),Table(i,j+1)) = Delta_Tau(Table(i,j),Table(i,j+1)) + Q/Length(i);  % 路径长度大，信息素增量便小
          end
          Delta_Tau(Table(i,n),Table(i,1)) = Delta_Tau(Table(i,n),Table(i,1)) + Q/Length(i);  % 路径长度大，信息素增量便小
      end
      Tau = (1-vol) * Tau + Delta_Tau;  % 更新信息素。信息素的大小影响了蚂蚁在两城市间的转移概率
    % 迭代次数加1，清空路径记录表
    iter = iter + 1;
    Table = zeros(m,n);
end
%--------------------------------------------------------------------------
%% 结果显示
[Shortest_Length,index] = min(Length_best);
Shortest_Route = Route_best(index,:);
Time_Cost=etime(clock,t0);  % etime(b,a)：截取时间向量a与时间向量b间的时间差（以秒计量）
disp(['最短距离:' num2str(Shortest_Length)]);  % num2str：数字向字符串转换
disp(['最短路径:' num2str([Shortest_Route Shortest_Route(1)])]);  % 路径封闭为一环形
disp(['收敛迭代次数:' num2str(Limit_iter)]);
disp(['程序执行时间:' num2str(Time_Cost) '秒']);
%--------------------------------------------------------------------------
%% 绘图
figure(1)  %绘制多福图形
plot([citys(Shortest_Route,1);citys(Shortest_Route(1),1)],...  % 绘图的横纵坐标此处纠结了很久，忽略了citys(Shortest_Route,1)与citys(Shortest_Route,2)均为列向量的问题
     [citys(Shortest_Route,2);citys(Shortest_Route(1),2)],'o-');
grid on
for i = 1:size(citys,1)
    text(citys(i,1),citys(i,2),['   ' num2str(i)]);  % 利用text函数在城市坐标点旁放置城市标号 
end
text(citys(Shortest_Route(1),1),citys(Shortest_Route(1),2),'       起点');
text(citys(Shortest_Route(end),1),citys(Shortest_Route(end),2),'       终点');
xlabel('城市位置横坐标')
ylabel('城市位置纵坐标')
title(['ACA最优化路径(最短距离:' num2str(Shortest_Length) ')'])
figure(2)
plot(1:iter_max,Length_best,'b');
xlabel('迭代次数');
ylabel('最短距离');
title('算法收敛轨迹');
%--------------------------------------------------------------------------

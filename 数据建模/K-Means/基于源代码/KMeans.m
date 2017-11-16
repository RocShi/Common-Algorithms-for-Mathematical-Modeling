% refer to the 《MATLAB在数学建模中的应用 · 第2版》 chapter 3
% modified by 石鹏
% 虽然可找到聚类中心，但无法标识出不同类的数据
%% 数据准备和初始化
clear,clc
x=[0 0;1 0; 0 1; 1 1;2 1;1 2; 2 2;3 2; 6 6; 7 6; 8 6; 6 7; 7 7; 8 7; 9 7 ; 7 8; 8 8; 9 8; 8 9 ; 9 9];
z=zeros(2,2);
z1=zeros(2,2);
z=x(1:2, 1:2);
%% 寻找聚类中心
while 1
    count=zeros(2,1);
    allsum=zeros(2,2);
    for i=1:20  %对每一个样本i，计算到2个聚类中心的距离
        temp1=sqrt((z(1,1)-x(i,1)).^2+(z(1,2)-x(i,2)).^2);
        temp2=sqrt((z(2,1)-x(i,1)).^2+(z(2,2)-x(i,2)).^2);
        if(temp1<temp2)  %样本点距第一个聚类中心更近
            count(1)=count(1)+1;
            allsum(1,1)=allsum(1,1)+x(i,1);
            allsum(1,2)=allsum(1,2)+x(i,2);
        else  %样本点距第二个聚类中心更近
            count(2)=count(2)+1;
            allsum(2,1)=allsum(2,1)+x(i,1);
            allsum(2,2)=allsum(2,2)+x(i,2); 
        end
    end
    z1(1,:)=allsum(1,:)/count(1);  %重新计算第1聚类中心
    z1(2,:)=allsum(2,:)/count(2);  %重新计算第2聚类中心
    if(z==z1)  %若聚类中心不再变化，则停止迭代
        break;
    else
        z=z1;
    end
end
%% 结果显示
disp('聚类中心特征值为：');
disp(z1);  %输出聚类中心
plot(x(:,1), x(:,2),'b*',...
    'MarkerSize',10);  %绘制样本点
hold on
plot(z1(:,1),z1(:,2),'ko',...
    'LineWidth',2,...
    'MarkerSize',10,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','r');
set(gca,'linewidth',2);

kt=[xlabel('特征x1','fontsize',13,'fontname','楷体');
ylabel('特征x2', 'fontsize',13,'fontname','楷体');
title('K-means分类图','fontsize',12,'fontname','楷体')];  %绘制聚类中心

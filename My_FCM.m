function [label_1,para_miu_new,iter,responsivity,X_num]=My_FCM(data,K)
%输入K：聚类数
%输出：label_1:聚的类, para_miu_new:模糊聚类中心μ，responsivity:模糊隶属度
format long
eps=0.001;  %定义迭代终止条件的eps
m=2;  %模糊加权指数，[1,+无穷)
T=100;  %最大迭代次数
fitness=zeros(T,1);
[data_num,~]=size(data);
count=zeros(data_num,1);  %统计distant中每一行为0的个数
responsivity=zeros(data_num,K);
R_up=zeros(data_num,K);
%----------------------------------------------------------------------------------------------------
%对data做最大-最小归一化处理
X=(data-ones(data_num,1)*min(data))./(ones(data_num,1)*(max(data)-min(data)));
[X_num,X_dim]=size(X);
%----------------------------------------------------------------------------------------------------
%随机初始化K个聚类中心
rand_array=randperm(X_num);  %产生1~X_num之间整数的随机排列
para_miu=X(rand_array(1:K),:);  %随机排列取前K个数，在X矩阵中取这K行作为初始聚类中心
%para_miu1=X(rand_array(1:K),:);
% ----------------------------------------------------------------------------------------------------


% FCM算法
for t=1:T
     %改进的距离，计算（X-para_miu）^2=X^2+para_miu^2-2*para_miu*X'，矩阵大小为X_num*K
      distant=1-exp((sum(X.*X,2))*ones(1,K)+ones(X_num,1)*(sum(para_miu.*para_miu,2))'-2*X*para_miu');
     % distant1=1-exp((sum(X.*X,2))*ones(1,K)+ones(X_num,1)*(sum(para_miu1.*para_miu1,2))'-2*X*para_miu1');
   %模糊因子
     sik=exp(-distant.^2/10000)/sum(exp(-distant.^2/10000));
    % sik1=exp(-distant1.^2/10000)/sum(exp(-distant1.^2/10000));
     Gij=sum(30*sik).*(sqrt(distant));
    % Gij1=sum(30*sik1).*(sqrt(distant1));
     %更新隶属度矩阵X_num*K
    for i=1:X_num
        count(i)=sum(distant(i,:)==0);
        if count(i)>0
            for k=1:K
                if distant(i,k)==0
                    responsivity(i,k)=1./count(i);
                else
                    responsivity(i,k)=0;
                end
            end
        else
            R_up(i,:)=distant(i,:).^(-1/(m-1));  %隶属度矩阵的分子部分
           responsivity(i,:)= R_up(i,:)./sum( R_up(i,:),2); 
         
        end
    end
   if responsivity<=0.35
        pai=(6/7)*responsivity;
    else
        pai=(6/7)+(-6/7)*responsivity;
    end
    responsivity=responsivity.*(1-pai);
    %目标函数值
    fitness(t)=sum(sum((distant+Gij).*(responsivity.^(m))));
     %更新聚类中心K*X_dim
    miu_up=(responsivity'.^(m))*X;  %μ的分子部分
    para_miu=miu_up./((sum(responsivity.^(m)))'*ones(1,X_dim));
    if t>1  
        if abs(fitness(t)-fitness(t-1))<eps
            break;
        end
    end
end
para_miu_new=para_miu;
iter=t;  %实际迭代次数
[~,label_1]=max(responsivity,[],2);

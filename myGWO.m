function [p,Convergence_curve,myP] = myGWO(y_SVR,y_LSTM)
SearchAgents_no=20; % 狼群数量，Number of search agents
Max_iteration=30; % 最大迭代次数，Maximum numbef of iterations
dim=3; % 此例需要优化两个参数c和g，number of your variables
lb=[-10,-10,-10]; % 参数取值下界
ub=[10,10,10]; % 参数取值上界

% initialize alpha, beta, and delta_pos
Alpha_pos=zeros(1,dim); % 初始化Alpha狼的位置
Alpha_score=inf; % 初始化Alpha狼的目标函数值，change this to -inf for maximization problems

Beta_pos=zeros(1,dim); % 初始化Beta狼的位置
Beta_score=inf; % 初始化Beta狼的目标函数值，change this to -inf for maximization problems

Delta_pos=zeros(1,dim); % 初始化Delta狼的位置
Delta_score=inf; % 初始化Delta狼的目标函数值，change this to -inf for maximization problems

%Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb);
myP(:,:,1) = Positions;
Convergence_curve=zeros(1,Max_iteration);

l=0; % Loop counter循环计数器

% Main loop主循环
while l<Max_iteration  % 对迭代次数循环
    
    for i=1:size(Positions,1)  % 遍历每个狼
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb; % ~表示取反
        myP(:,:,l+1) = Positions;
      % 计算适应度函数值
       fitness=fun_C(Positions(i,:),y_SVR,y_LSTM); 
        % Update Alpha, Beta, and Delta
        if fitness<Alpha_score % 如果目标函数值小于Alpha狼的目标函数值
            Alpha_score=fitness; % 则将Alpha狼的目标函数值更新为最优目标函数值，Update alpha
            Alpha_pos=Positions(i,:); % 同时将Alpha狼的位置更新为最优位置
        end        
        if fitness>Alpha_score && fitness<Beta_score % 如果目标函数值介于于Alpha狼和Beta狼的目标函数值之间
            Beta_score=fitness; % 则将Beta狼的目标函数值更新为最优目标函数值，Update beta
            Beta_pos=Positions(i,:); % 同时更新Beta狼的位置
        end        
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score  % 如果目标函数值介于于Beta狼和Delta狼的目标函数值之间
            Delta_score=fitness; % 则将Delta狼的目标函数值更新为最优目标函数值，Update delta
            Delta_pos=Positions(i,:); % 同时更新Delta狼的位置
        end
    end
    a=2-l*((2)/Max_iteration); % 对每一次迭代，计算相应的a值，a decreases linearly fron 2 to 0
    % Update the Position of search agents including omegas
    for i=1:size(Positions,1) % 遍历每个狼 
        for j=1:size(Positions,2) % 遍历每个维度
            
            % 包围猎物，位置更新
            
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % 计算系数A，Equation (3.3)
            C1=2*r2; % 计算系数C，Equation (3.4)
            
            % Alpha狼位置更新
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j)); % Equation (3.5)-part 1
            X1=Alpha_pos(j)-A1*D_alpha; % Equation (3.6)-part 1
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % 计算系数A，Equation (3.3)
            C2=2*r2; % 计算系数C，Equation (3.4)
            
            % Beta狼位置更新
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); % Equation (3.5)-part 2
            X2=Beta_pos(j)-A2*D_beta; % Equation (3.6)-part 2       
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a; % 计算系数A，Equation (3.3)
            C3=2*r2; % 计算系数C，Equation (3.4)
            
            % Delta狼位置更新
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); % Equation (3.5)-part 3
            X3=Delta_pos(j)-A3*D_delta; % Equation (3.5)-part 3             
           %% 原算法
            Positions(i,j)=(X1+X2+X3)/3;% Equation (3.7)%原本方程
        end
    end
        l=l+1;
%%  
        for i=1:size(Positions,1)  % 遍历每个狼
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb; % ~表示取反
        myP(:,:,l+1) = Positions;
      % 计算适应度函数值
        fitness=fun_C(Positions(i,:),y_SVR,y_LSTM); 
        % Update Alpha, Beta, and Delta
        if fitness<Alpha_score % 如果目标函数值小于Alpha狼的目标函数值
            Alpha_score=fitness; % 则将Alpha狼的目标函数值更新为最优目标函数值，Update alpha
            Alpha_pos=Positions(i,:); % 同时将Alpha狼的位置更新为最优位置
        end   
        end
%%
        
    Convergence_curve(l)=Alpha_score;
end
p=Alpha_pos;
% bestGWOaccuarcy=Alpha_score;
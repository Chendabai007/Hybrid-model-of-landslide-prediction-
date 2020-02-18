function [p,Convergence_curve,myP] = myGWO(y_SVR,y_LSTM)
SearchAgents_no=20; % ��Ⱥ������Number of search agents
Max_iteration=30; % ������������Maximum numbef of iterations
dim=3; % ������Ҫ�Ż���������c��g��number of your variables
lb=[-10,-10,-10]; % ����ȡֵ�½�
ub=[10,10,10]; % ����ȡֵ�Ͻ�

% initialize alpha, beta, and delta_pos
Alpha_pos=zeros(1,dim); % ��ʼ��Alpha�ǵ�λ��
Alpha_score=inf; % ��ʼ��Alpha�ǵ�Ŀ�꺯��ֵ��change this to -inf for maximization problems

Beta_pos=zeros(1,dim); % ��ʼ��Beta�ǵ�λ��
Beta_score=inf; % ��ʼ��Beta�ǵ�Ŀ�꺯��ֵ��change this to -inf for maximization problems

Delta_pos=zeros(1,dim); % ��ʼ��Delta�ǵ�λ��
Delta_score=inf; % ��ʼ��Delta�ǵ�Ŀ�꺯��ֵ��change this to -inf for maximization problems

%Initialize the positions of search agents
Positions=initialization(SearchAgents_no,dim,ub,lb);
myP(:,:,1) = Positions;
Convergence_curve=zeros(1,Max_iteration);

l=0; % Loop counterѭ��������

% Main loop��ѭ��
while l<Max_iteration  % �Ե�������ѭ��
    
    for i=1:size(Positions,1)  % ����ÿ����
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb; % ~��ʾȡ��
        myP(:,:,l+1) = Positions;
      % ������Ӧ�Ⱥ���ֵ
       fitness=fun_C(Positions(i,:),y_SVR,y_LSTM); 
        % Update Alpha, Beta, and Delta
        if fitness<Alpha_score % ���Ŀ�꺯��ֵС��Alpha�ǵ�Ŀ�꺯��ֵ
            Alpha_score=fitness; % ��Alpha�ǵ�Ŀ�꺯��ֵ����Ϊ����Ŀ�꺯��ֵ��Update alpha
            Alpha_pos=Positions(i,:); % ͬʱ��Alpha�ǵ�λ�ø���Ϊ����λ��
        end        
        if fitness>Alpha_score && fitness<Beta_score % ���Ŀ�꺯��ֵ������Alpha�Ǻ�Beta�ǵ�Ŀ�꺯��ֵ֮��
            Beta_score=fitness; % ��Beta�ǵ�Ŀ�꺯��ֵ����Ϊ����Ŀ�꺯��ֵ��Update beta
            Beta_pos=Positions(i,:); % ͬʱ����Beta�ǵ�λ��
        end        
        if fitness>Alpha_score && fitness>Beta_score && fitness<Delta_score  % ���Ŀ�꺯��ֵ������Beta�Ǻ�Delta�ǵ�Ŀ�꺯��ֵ֮��
            Delta_score=fitness; % ��Delta�ǵ�Ŀ�꺯��ֵ����Ϊ����Ŀ�꺯��ֵ��Update delta
            Delta_pos=Positions(i,:); % ͬʱ����Delta�ǵ�λ��
        end
    end
    a=2-l*((2)/Max_iteration); % ��ÿһ�ε�����������Ӧ��aֵ��a decreases linearly fron 2 to 0
    % Update the Position of search agents including omegas
    for i=1:size(Positions,1) % ����ÿ���� 
        for j=1:size(Positions,2) % ����ÿ��ά��
            
            % ��Χ���λ�ø���
            
            r1=rand(); % r1 is a random number in [0,1]
            r2=rand(); % r2 is a random number in [0,1]
            
            A1=2*a*r1-a; % ����ϵ��A��Equation (3.3)
            C1=2*r2; % ����ϵ��C��Equation (3.4)
            
            % Alpha��λ�ø���
            D_alpha=abs(C1*Alpha_pos(j)-Positions(i,j)); % Equation (3.5)-part 1
            X1=Alpha_pos(j)-A1*D_alpha; % Equation (3.6)-part 1
                       
            r1=rand();
            r2=rand();
            
            A2=2*a*r1-a; % ����ϵ��A��Equation (3.3)
            C2=2*r2; % ����ϵ��C��Equation (3.4)
            
            % Beta��λ�ø���
            D_beta=abs(C2*Beta_pos(j)-Positions(i,j)); % Equation (3.5)-part 2
            X2=Beta_pos(j)-A2*D_beta; % Equation (3.6)-part 2       
            
            r1=rand();
            r2=rand(); 
            
            A3=2*a*r1-a; % ����ϵ��A��Equation (3.3)
            C3=2*r2; % ����ϵ��C��Equation (3.4)
            
            % Delta��λ�ø���
            D_delta=abs(C3*Delta_pos(j)-Positions(i,j)); % Equation (3.5)-part 3
            X3=Delta_pos(j)-A3*D_delta; % Equation (3.5)-part 3             
           %% ԭ�㷨
            Positions(i,j)=(X1+X2+X3)/3;% Equation (3.7)%ԭ������
        end
    end
        l=l+1;
%%  
        for i=1:size(Positions,1)  % ����ÿ����
        Flag4ub=Positions(i,:)>ub;
        Flag4lb=Positions(i,:)<lb;
        Positions(i,:)=(Positions(i,:).*(~(Flag4ub+Flag4lb)))+ub.*Flag4ub+lb.*Flag4lb; % ~��ʾȡ��
        myP(:,:,l+1) = Positions;
      % ������Ӧ�Ⱥ���ֵ
        fitness=fun_C(Positions(i,:),y_SVR,y_LSTM); 
        % Update Alpha, Beta, and Delta
        if fitness<Alpha_score % ���Ŀ�꺯��ֵС��Alpha�ǵ�Ŀ�꺯��ֵ
            Alpha_score=fitness; % ��Alpha�ǵ�Ŀ�꺯��ֵ����Ϊ����Ŀ�꺯��ֵ��Update alpha
            Alpha_pos=Positions(i,:); % ͬʱ��Alpha�ǵ�λ�ø���Ϊ����λ��
        end   
        end
%%
        
    Convergence_curve(l)=Alpha_score;
end
p=Alpha_pos;
% bestGWOaccuarcy=Alpha_score;
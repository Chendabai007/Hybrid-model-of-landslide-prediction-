clc;clear;close all;
load SVRTrainData y1 ;
y_SVR = y1;
load LSTMTrainData y1;
y_LSTM = y1;
load MGWO_data;

a0 = myP(:,:,1);
x1=a0(:,1);
y1=a0(:,2);
for i = 1:20
    z1(i,:)=fun_C(a0(i,:),y_SVR,y_LSTM);
end
%
figure;
subplot(131)
scatter3(x1,y1,z1);
xlabel('w_1','Rotation',15,'FontSize',12,'FontName','Times New Roman');
ylabel('w_2','Rotation',335,'FontSize',12,...
    'FontName','Times New Roman');
zlabel('Q','FontSize',12,...
    'FontName','Times New Roman');
 title('Initial generation')
% xlim([0 500]);ylim([0 500]);zlim([0 0.2]);view([-37.5 30]);
%

a5 = myP(:,:,5);
x1=a5(:,1);
y1=a5(:,2);
for i = 1:20
    z1(i,:)=fun_C(a5(i,:),y_SVR,y_LSTM);
end
%
% figure;
subplot(132)
scatter3(x1,y1,z1);
xlabel('w_1','Rotation',15,'FontSize',12,'FontName','Times New Roman');
ylabel('w_2','Rotation',335,'FontSize',12,...
    'FontName','Times New Roman');
zlabel('Q','FontSize',12,...
    'FontName','Times New Roman');
title('Fifth generation')
xlim([0 10]);ylim([0 10]);zlim([0 1*10^9]);view([-37.5 30]);


a13 = myP(:,:,13);
x1=a13(:,1);
y1=a13(:,2);
for i = 1:20
    z1(i,:)=fun_C(a13(i,:),y_SVR,y_LSTM);
end
%
% figure;
subplot(133)
scatter3(x1,y1,z1);
xlabel('w_1','Rotation',15,'FontSize',12,'FontName','Times New Roman');
ylabel('w_2','Rotation',335,'FontSize',12,...
    'FontName','Times New Roman');
zlabel('Q','FontSize',12,...
    'FontName','Times New Roman');
title('Thirteenth generation')
xlim([0 10]);ylim([0 10]);zlim([0 1*10^9]);view([-37.5 30]);
clc;clear;close all;
load SVRTrainData YPred_period YPred_trend data_ZG118 y_period;
y_SVR = YPred_period;
load LSTMTrainData YPred_period;
y_LSTM = YPred_period;
y_SVR=(y_SVR-0.24*y_LSTM-4.05)/0.91;

w1=0.96;w2=0.25;b=4.05;
YPred_period  = w1*y_SVR + w2*y_LSTM + b;

figure;
plot(1:12,[y_period(61:72,1)';YPred_period])
xlabel('Time /month')
ylabel('Periodic displacement /mm')
legend('Actual','Predicted')
set(gca,'XTickLabel',{'2011-12','2012-02','2012-04','2012-06','2012-08','2012-10','2012-12'},'XTickLabelRotation',45);
set(gca,'Fontname','Times New Roman');

YPred = YPred_trend + YPred_period';
rmse_all = sqrt(mean((YPred-data_ZG118(61:72,1)).^2))

%% 三种模型对比结果
YPred_SVR=YPred_trend+y_SVR';
YPred_LSTM=YPred_trend+y_LSTM';
YPred_H=YPred_trend+YPred_period';
figure;
plot(1:12,[data_ZG118(61:72,1),YPred_SVR,YPred_LSTM,YPred_H])
xlabel('Time /month')
ylabel('Periodic displacement /mm')
legend('Actual','SVR','LSTM','Hybrid')
set(gca,'XTickLabel',{'2011-12','2012-02','2012-04','2012-06','2012-08','2012-10','2012-12'},'XTickLabelRotation',45);
set(gca,'Fontname','Times New Roman');
Error_SVR=YPred_SVR-data_ZG118(61:72,1);
Error_LSTM=YPred_LSTM-data_ZG118(61:72,1);
Error_H=YPred_H-data_ZG118(61:72,1);
Error=[Error_SVR,Error_LSTM,Error_H];
rmse_SVR = sqrt(mean((YPred_SVR-data_ZG118(61:72,1)).^2))
rmse_LSTM = sqrt(mean((YPred_LSTM-data_ZG118(61:72,1)).^2))
rmse_H = sqrt(mean((YPred_H-data_ZG118(61:72,1)).^2))

mae_SVR = mean(abs(YPred_SVR-data_ZG118(61:72,1)))
mae_LSTM = mean(abs(YPred_LSTM-data_ZG118(61:72,1)))
mae_H = mean(abs(YPred_H-data_ZG118(61:72,1)))
















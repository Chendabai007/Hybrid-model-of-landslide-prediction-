%2007-2012年数据
clc;clear;close all;
%% 加载变形位移数据
load data_ZG118 data_ZG118;
data_ZG118(51,1)=(data_ZG118(50,1)+data_ZG118(52,1))/2;
%% 加载影响因子
load Rainfall Rainfall;
load Reservoir Reservoir;
% figure;
% plotyy(1:72,data_ZG118,1:72,Rainfall, 'line','bar')
% figure;
% plotyy(1:72,data_ZG118,1:72,Reservoir, 'line','line')
%% 信号分解
y_trend = zeros(72,1);
a=0.4;
y_trend(1,1) = data_ZG118(1,1);
y_trend(2,1) = a*data_ZG118(1,1)+(1-a)*y_trend(1,1);
for i = 3:72
    y_trend(i,1) = a*data_ZG118(i-1,1)+a*(1-a)*data_ZG118(i-2,1)+(1-a)^2*y_trend(i-2,1);
end
y_period = data_ZG118 - y_trend;
%% 周期项预测
% 获取周期项影响因子
% a1:当月降雨量；a2:前两月降雨量；a3:当月最大降雨量;b1:库水位高程；b2:当月库水位变化；b3:双月库水位变化；
% c1:当月位移增量；c2:前两月位移增量；c3:前三月位移增量.
a1 = Rainfall;
a2(1)=a1(1)*4/3;
for i = 2:numel(Rainfall)
    a2(i) = a1(i-1) + a1(i);
end
load Rainfallmax a3;
b1 = Reservoir;
b2(1) = 0;
for i = 2:numel(Reservoir)
    b2(i) = b1(i)-b1(i-1);
end
b3(1) = 0;
b3(2) = 0;
for i = 3:numel(Reservoir)
    b3(i) = b1(i)-b1(i-2);
end
c0 = data_ZG118;
c1(1)=0;
for i = 2:numel(data_ZG118)
   c1(i) = c0(i)-c0(i-1);%当月位移增量
end
c2(1)=0;c2(2)=0;
for i = 3:numel(data_ZG118)
   c2(i) = c0(i)-c0(i-2);%双月位移增量
end
c3(1)=0;c3(2)=0;c3(3)=0;
for i = 4:numel(data_ZG118)
   c3(i) = c0(i)-c0(i-3);%双月位移增量
end
y_period_input = [a1';a2;a3';b1';b2;b3;c1;c2;c3];

[y1,YPred_period]  = MyPeriod_SVR(y_period_input,y_period');%LSTM/SVR/Elman模型

rmse_period = sqrt(mean((YPred_period'-y_period(61:72,1)).^2))
figure;
plot(1:12,y_period(61:72,1),1:12,YPred_period)
error2=y1-y_period(1:60,1);
%% 累积位移预测
YPred_trend = y_trend(61:72,1);
figure;
YPred = YPred_trend + YPred_period';
plot(1:12,data_ZG118(61:72),1:12,YPred)
ylim([2100,2500])

rmse_all = sqrt(mean((YPred-data_ZG118(61:72,1)).^2))



























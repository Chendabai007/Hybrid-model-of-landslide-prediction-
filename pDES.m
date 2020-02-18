clc;clear;close all;
%2007-2012年数据
clc;clear;close all;
%% 加载变形位移数据
load data_ZG118 data_ZG118;
data_ZG118(51,1)=(data_ZG118(50,1)+data_ZG118(52,1))/2;
%% 加载影响因子
load Rainfall Rainfall;
load Reservoir Reservoir;
%% 信号分解
y_trend = zeros(72,1);
a=0.4;
y_trend(1,1) = data_ZG118(1,1);
y_trend(2,1) = a*data_ZG118(1,1)+(1-a)*y_trend(1,1);
for i = 3:72
    y_trend(i,1) = a*data_ZG118(i-1,1)+a*(1-a)*data_ZG118(i-2,1)+(1-a)^2*y_trend(i-2,1);
end
y_period = data_ZG118 - y_trend;
%
% plot(1:72,[data_ZG118,y_trend,y_period])

figure;
plotyy(1:72,[data_ZG118,y_trend],1:72,y_period);
legend('Cumulative displacement','Trend displacement','Periodic displacement')
xlabel('Time /month')
ylabel('Displacement /mm')
set(gca,'XTickLabel',{'2006-12','2007-10','2008-08','2009-06','2010-04','2011-02','2011-12','2012-10','2013-08'},'XTickLabelRotation',45);
set(gca,'Fontname','Times New Roman');



